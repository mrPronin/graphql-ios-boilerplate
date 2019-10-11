//
//  LoginViewController.swift
//  boilerplate
//
//  Created by Aleksandr Pronin on 20.04.19.
//  Copyright © 2019 Aleksandr Pronin. All rights reserved.
//

import UIKit
import ReusableDataInput
import iOSReusableExtensions
import CryptoSwift
import GoogleSignIn
import FBSDKLoginKit
import FBSDKCoreKit

class LoginViewController: BaseViewController
{
    // MARK: - Public API
    
    // MARK: - View Lifecycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().presentingViewController = self

        self.setupViewsOnLoad()
    }
    
    // MARK: - Actions
    @IBAction func loginAction(_ sender: Any)
    {
        self.doLogin()
    }
    
    @IBAction func loginWithGoogleAction(_ sender: Any)
    {
        self.showModalActivityIndicator()
        
        GIDSignIn.sharedInstance().signIn()
    }
    
    @IBAction func loginWithFacebookAction(_ sender: Any)
    {
        let loginManager = LoginManager()
        loginManager.logIn(permissions: ["public_profile"], from: self) { (loginResult, error) in
            guard let accessToken = loginResult?.token?.tokenString else {
                // TODO: show error
                return
            }
            self.doLoginUpWithFacebook(token: accessToken)
        }
    }
    
    // MARK: - Display logic
    
    // MARK: - Private
    @IBOutlet weak internal var emailTextInput: DesignableTextInput!
    @IBOutlet weak internal var passwordTextInput: DesignableTextInput!
    
    @IBOutlet var iconImageViewCollection: [UIImageView]!
    
    private let errorMessageHeader = "Error while attempting to login.".localized
}

// MARK: - TextInputDelegate
extension LoginViewController: TextInputDelegate
{
    func textInputShouldReturn(_ textInput: DesignableTextInput) -> Bool
    {
        if let nextInput = textInput.nextInput {
            nextInput.becomeFirstResponderForInputView()
        } else {
            textInput.resignFirstResponderForInputView()
        }
        return true
    }
}

// MARK: - InputViewValidator
extension LoginViewController: InputViewValidator
{
    func inputView(_ inputView: InputView, shouldValidateValue perhapsValue: String?) -> Bool
    {
        guard let validationRules = inputView.validationRules else {
            return true
        }
        for validationRule in validationRules {
            if !validationRule.rule.validationHandler(perhapsValue) {
                if let message = validationRule.message {
                    inputView.errorMessage = message
                }
                inputView.state = .error
                return false
            }
        }
        
        return true
    }
}

// MARK: - InputViewValidatable
extension LoginViewController: InputViewValidatable
{
    func validate() -> Bool
    {
        return self.inputViewCollection
            .map({ $0.validate() })
            /*.forEachPerform { print("[\(type(of: self)) \(#function)]: \($0)") }*/
            .reduce(true) { $0 && $1 }
    }
}

// MARK: - GIDSignInDelegate
extension LoginViewController: GIDSignInDelegate
{
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!)
    {
        #if !PROD
        print("[\(type(of: self)) \(#function)]")
        #endif
        
        if let error = error {
            self.hideModalActivityIndicator()
            #if !PROD
            print("[\(type(of: self)) \(#function)] error: \(error.localizedDescription)")
            #endif
            return
        }
        
        guard
            let authentication = user.authentication,
            let idToken = authentication.idToken,
            let refreshToken = authentication.refreshToken
        else
        {
            return
        }
        
        let input = AuthInput(accessToken: idToken, refreshToken: refreshToken)
        let continueWithGoogle = ContinueWithGoogleMutation(data: input)
        ApolloManager.shared.client.perform(mutation: continueWithGoogle) { [weak self] result in
            guard let strongSelf = self else { return }
            strongSelf.hideModalActivityIndicator()
            switch result {
            case .success(let graphQLResult):
                guard let token = graphQLResult.data?.continueWithGoogle.token else {
                    let message = "Wrong server response.".localized
                    let errorMessage = "\(strongSelf.errorMessageHeader) \(message)"
                    #if !PROD
                    print("[\(type(of: self)) \(#function)] 3: errorMessage: \(errorMessage)")
                    #endif
                    strongSelf.displayError(message: errorMessage)
                    return
                }
                ApolloManager.shared.setAuthorization(token: token)
                
                strongSelf.showModalActivityIndicator()

                ApolloManager.shared.client.fetch(query: MeQuery(), cachePolicy: .fetchIgnoringCacheData, queue: .main) { [weak self] result in
                    guard let strongSelf = self else { return }
                    strongSelf.hideModalActivityIndicator()
                    switch result {
                    case .success(let graphQLResult):
                        guard let user = graphQLResult.data?.me.fragments.userDetails else {
                            let message = "Unable to login.".localized
                            let errorMessage = "\(strongSelf.errorMessageHeader) \(message)"
                            strongSelf.displayError(message: errorMessage)
                            ApolloManager.shared.removeAuthorization()
                            return
                        }
                        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
                        appDelegate.repository.user = User(user)
                        let tabBar = TabBarController.instantiate(fromAppStoryboard: .Main)
                        appDelegate.window?.rootViewController = tabBar
                    case .failure( _):
                        /*
                        if let _ = result?.errors?.first {
                            let message = "Unable to login.".localized
                            let errorMessage = "\(self.errorMessageHeader) \(message)"
                            self.displayError(message: errorMessage)
                            return
                        }
                        */
                        let message = "Unable to login.".localized
                        let errorMessage = "\(strongSelf.errorMessageHeader) \(message)"
                        strongSelf.displayError(message: errorMessage)
                        return
                    }
                }
            case .failure(let error):
                /*
                if let error = result?.errors?.first {
                    let errorMessage = "\(self.errorMessageHeader) \(error.localizedDescription)"
                    #if !PROD
                    print("[\(type(of: self)) \(#function)] 2: \(errorMessage)")
                    #endif
                    self.displayError(message: errorMessage)
                    return
                }
                */
                let errorMessage = "\(strongSelf.errorMessageHeader) \(error.localizedDescription)"
                #if !PROD
                print("[\(type(of: self)) \(#function)]: \(errorMessage)")
                #endif
                strongSelf.displayError(message: errorMessage)
                return
            }
            
            
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!)
    {
        #if !PROD
        print("[\(type(of: self)) \(#function)]")
        #endif
    }
}

// MARK: - Private
extension LoginViewController
{
    internal func doLogin()
    {
        self.view.endEditing(true)
        guard self.validate() else {
            return
        }
        self.inputViewCollection.forEach {
            $0.errorMessage = nil
            $0.state = .normal
        }
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        guard let email = self.emailTextInput.value?.lowercased().trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) else { return }
        guard let password = self.passwordTextInput.value?.bytes.sha256().toBase64() else { return }
        
        #if !PROD
        print("[\(type(of: self)) \(#function)] email: \(email) password: \(password)")
        #endif
        
        let input = LoginUserInput(email: email, password: password)
        let loginUser = LoginMutation(data: input)
        
        self.showModalActivityIndicator()
        
        ApolloManager.shared.client.perform(mutation: loginUser) { [weak self] result in
            guard let strongSelf = self else { return }
            strongSelf.hideModalActivityIndicator()
            switch result {
            case .success(let graphQLResult):
                guard let token = graphQLResult.data?.login.token, !token.isEmpty, let user = graphQLResult.data?.login.user.fragments.userDetails else {
                    let message = "Wrong server response.".localized
                    let errorMessage = "\(strongSelf.errorMessageHeader) \(message)"
                    #if !PROD
                    print("[\(type(of: self)) \(#function)] graphQLResult: \(graphQLResult)")
                    #endif
                    strongSelf.displayError(message: errorMessage)
                    return
                }
                
                #if !PROD
                print("[\(type(of: self)) \(#function)] token: \(token)")
                #endif
                
                ApolloManager.shared.setAuthorization(token: token)
                appDelegate.repository.user = User(user)
                ApolloManager.shared.client.fetch(query: MeQuery(), cachePolicy: .fetchIgnoringCacheData, queue: .main) { [weak self] result in
                    guard let strongSelf = self else { return }
                    strongSelf.hideModalActivityIndicator()
                    switch result {
                    case .success(let graphQLResult):
                        guard let user = graphQLResult.data?.me.fragments.userDetails else {
                            let message = "Unable to login.".localized
                            let errorMessage = "\(strongSelf.errorMessageHeader) \(message)"
                            strongSelf.displayError(message: errorMessage)
                            ApolloManager.shared.removeAuthorization()
                            return
                        }
                        appDelegate.repository.user = User(user)
                        let tabBar = TabBarController.instantiate(fromAppStoryboard: .Main)
                        appDelegate.window?.rootViewController = tabBar
                    case .failure( _):
                        let message = "Unable to login.".localized
                        let errorMessage = "\(strongSelf.errorMessageHeader) \(message)"
                        strongSelf.displayError(message: errorMessage)
                        return
                    }
                }
            case .failure(let error):
                /*
                if let message = error["message"] {
                    let errorMessage = "\(self.errorMessageHeader) \(message)"
                    #if !PROD
                    print("[\(type(of: self)) \(#function)] 2: errorMessage: \(errorMessage)")
                    #endif
                    self.displayError(message: errorMessage)
                    return
                }
                */
                
                let errorMessage = "\(strongSelf.errorMessageHeader) \(error.localizedDescription)"
                #if !PROD
                print("[\(type(of: self)) \(#function)] 3: errorMessage: \(errorMessage)")
                #endif
                strongSelf.displayError(message: errorMessage)
                return
            }
        }
    }
    
    internal func doLoginUpWithFacebook(token: String)
    {
        self.showModalActivityIndicator()
        let input = AuthInput(accessToken: token, refreshToken: "")
        let continueWithFacebook = ContinueWithFacebookMutation(data: input)
        ApolloManager.shared.client.perform(mutation: continueWithFacebook) { [weak self] result in
            guard let strongSelf = self else { return }
            strongSelf.hideModalActivityIndicator()
            switch result {
            case .success(let graphQLResult):
                /*
                if let error = result?.errors?.first {
                    let errorMessage = "\(self.errorMessageHeader) \(error.localizedDescription)"
                    #if !PROD
                    print("[\(type(of: self)) \(#function)] \(errorMessage)")
                    #endif
                    self.displayError(message: errorMessage)
                    return
                }
                */
                guard let token = graphQLResult.data?.continueWithFacebook.token else {
                    let message = "Wrong server response.".localized
                    let errorMessage = "\(strongSelf.errorMessageHeader) \(message)"
                    #if !PROD
                    print("[\(type(of: self)) \(#function)] 3: errorMessage: \(errorMessage)")
                    #endif
                    strongSelf.displayError(message: errorMessage)
                    return
                }
                ApolloManager.shared.setAuthorization(token: token)
                
                strongSelf.showModalActivityIndicator()
                
                ApolloManager.shared.client.fetch(query: MeQuery(), cachePolicy: .fetchIgnoringCacheData, queue: .main) { [weak self] result in
                    guard let strongSelf = self else { return }
                    strongSelf.hideModalActivityIndicator()
                    switch result {
                    case .success(let graphQLResult):
                        guard let user = graphQLResult.data?.me.fragments.userDetails else {
                            let message = "Unable to login.".localized
                            let errorMessage = "\(strongSelf.errorMessageHeader) \(message)"
                            strongSelf.displayError(message: errorMessage)
                            ApolloManager.shared.removeAuthorization()
                            return
                        }
                        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
                        appDelegate.repository.user = User(user)
                        let tabBar = TabBarController.instantiate(fromAppStoryboard: .Main)
                        appDelegate.window?.rootViewController = tabBar
                    case .failure( _):
                        /*
                        if let _ = result?.errors?.first {
                            let message = "Unable to login.".localized
                            let errorMessage = "\(self.errorMessageHeader) \(message)"
                            self.displayError(message: errorMessage)
                            return
                        }
                        */
                        let message = "Unable to login.".localized
                        let errorMessage = "\(strongSelf.errorMessageHeader) \(message)"
                        strongSelf.displayError(message: errorMessage)
                    }
                }
            case .failure(let error):
                let errorMessage = "\(strongSelf.errorMessageHeader) \(error.localizedDescription)"
                #if !PROD
                print("[\(type(of: self)) \(#function)] \(errorMessage)")
                #endif
                strongSelf.displayError(message: errorMessage)
                return
            }
            
        }
    }

    internal func setupViewsOnLoad()
    {
        self.title = "Login".localized
        self.view.backgroundColor = .background

        self.inputViewCollection.enumerated()
            .forEach {
                guard $0.element != inputViewCollection.last else { return }
                $0.element.nextInput = inputViewCollection[$0.offset + 1]
        }
        
        self.iconImageViewCollection.forEach { $0.imageColor = .lightGray }
        
        // emailTextInput
        DesignableTextInput.setupAppearance(forTextInput: self.emailTextInput)
        self.emailTextInput.title = "Email".localized
        self.emailTextInput.delegate = self
        self.emailTextInput.validator = self
        self.emailTextInput.keyboardType = .emailAddress
        self.emailTextInput.validationRules = [
            ValidationRule(rule: .emptyString, message: "Please enter your email address!".localized),
            ValidationRule(rule: .email, message: "Please enter correct email address!")
        ]
        
        // passwordTextInput
        DesignableTextInput.setupAppearance(forTextInput: self.passwordTextInput)
        self.passwordTextInput.title = "Password".localized
        self.passwordTextInput.delegate = self
        self.passwordTextInput.validator = self
        self.passwordTextInput.textField.returnKeyType = .done
        self.passwordTextInput.textField.isSecureTextEntry = true
        self.passwordTextInput.isSeparatorHidden = true
        self.passwordTextInput.validationRules = [
            ValidationRule(rule: .emptyString, message: "Please enter your password!"),
            ValidationRule(rule: .minimumInput(length: 8), message: "Please enter correct password!")
        ]
        
        #if !PROD
        /*
        let email = "pronin.alx@gmail.com"
        let password = "dsq8k40l"
        self.emailTextInput.value = email
        self.passwordTextInput.value = password
        */
        #endif
    }
}

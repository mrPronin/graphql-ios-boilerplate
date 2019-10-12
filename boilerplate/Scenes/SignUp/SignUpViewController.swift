//
//  SignUpViewController.swift
//  boilerplate
//
//  Created by Aleksandr Pronin on 20.04.19.
//  Copyright © 2019 Aleksandr Pronin. All rights reserved.
//

import UIKit
import ReusableDataInput
import iOSReusableExtensions
import GoogleSignIn
import CryptoSwift
import FBSDKLoginKit
import FBSDKCoreKit

class SignUpViewController: BaseViewController
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
    @IBAction func registerAction(_ sender: Any)
    {
        self.doSignUpWithEmail()
    }
    
    @IBAction func registerWithGoogleAction(_ sender: Any)
    {
        self.showModalActivityIndicator()
        
        GIDSignIn.sharedInstance().signIn()
    }
    
    @IBAction func registerWithFacebookAction(_ sender: Any)
    {
        let loginManager = LoginManager()
        loginManager.logIn(permissions: ["public_profile"], from: self) { (loginResult, error) in
            #if !PROD
            if
                let safeLoginResult: LoginManagerLoginResult = loginResult,
                let accessToken = safeLoginResult.token?.tokenString,
                let userId = safeLoginResult.token?.userID
            {
                print("[\(type(of: self)) \(#function)] token: \(accessToken) userId: \(userId)")
            }
            #endif
            guard let accessToken = loginResult?.token?.tokenString else {
                // TODO: show error
                return
            }
            self.doSignUpWithFacebook(token: accessToken)
            
            #if !PROD
            Profile.loadCurrentProfile(completion: { (profile, error) in
                guard let profile = profile else { return }
                
                if let firstName = profile.firstName {
                    print("[\(type(of: self)) \(#function)] firstName: \(firstName)")
                }
                
                if let middleName = profile.middleName {
                    print("[\(type(of: self)) \(#function)] middleName: \(middleName)")
                }
                
                if let lastName = profile.lastName {
                    print("[\(type(of: self)) \(#function)] lastName: \(lastName)")
                }
                
                if let name = profile.name {
                    print("[\(type(of: self)) \(#function)] name: \(name)")
                }
                
                if let imageURL = profile.imageURL(forMode: .square, size: CGSize(width: 200, height: 200)) {
                    print("[\(type(of: self)) \(#function)] imageURL: \(imageURL)")
                }
            })
            #endif
        }
    }
    
    // MARK: - Display logic
    private func displayError(message: String?, input: InputView)
    {
        guard let safeMessage = message else {
            input.errorMessage = nil
            input.state = .normal
            return
        }
        input.errorMessage = safeMessage
        input.state = .error
    }
    
    // MARK: - Private
    @IBOutlet weak internal var firstNameTextInput: DesignableTextInput!
    @IBOutlet weak internal var lastNameTextInput: DesignableTextInput!
    @IBOutlet weak internal var emailTextInput: DesignableTextInput!
    @IBOutlet weak internal var passwordTextInput: DesignableTextInput!
    @IBOutlet internal var iconImageViewCollection: [UIImageView]!
    
    private let errorMessageHeader = "Error while attempting to to create new user.".localized
}

// MARK: - TextInputDelegate
extension SignUpViewController: TextInputDelegate
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
extension SignUpViewController: InputViewValidator
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
extension SignUpViewController: InputViewValidatable
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
extension SignUpViewController: GIDSignInDelegate
{
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!)
    {
        self.hideModalActivityIndicator()
        /*
        #if !PROD
        print("[\(type(of: self)) \(#function)]")
        #endif

        if let error = error {
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
        
        
        let activityData = ActivityData()
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData, nil)
        
        let input = AuthInput(accessToken: idToken, refreshToken: refreshToken)
        let continueWithGoogle = ContinueWithGoogleMutation(data: input)
        ApolloManager.shared.client.perform(mutation: continueWithGoogle) { result, error in
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
            if let error = error {
                let errorMessage = "\(self.errorMessageHeader) \(error.localizedDescription)"
                #if !PROD
                print("[\(type(of: self)) \(#function)] \(errorMessage)")
                #endif
                self.displayError(message: errorMessage)
                return
            }
            if let error = result?.errors?.first {
                let errorMessage = "\(self.errorMessageHeader) \(error.localizedDescription)"
                #if !PROD
                print("[\(type(of: self)) \(#function)] \(errorMessage)")
                #endif
                self.displayError(message: errorMessage)
                return
            }
            
            guard let token = result?.data?.continueWithGoogle.token else {
                let message = "Wrong server response.".localized
                let errorMessage = "\(self.errorMessageHeader) \(message)"
                #if !PROD
                print("[\(type(of: self)) \(#function)] 3: errorMessage: \(errorMessage)")
                #endif
                self.displayError(message: errorMessage)
                return
            }
            ApolloManager.shared.setAuthorization(token: token)
            
            let activityData = ActivityData()
            NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData, nil)

            ApolloManager.shared.client.fetch(query: MeQuery(), cachePolicy: .fetchIgnoringCacheData, queue: .main)
            { result, error in
                NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
                if let _ = error {
                    let message = "Unable to register.".localized
                    let errorMessage = "\(self.errorMessageHeader) \(message)"
                    self.displayError(message: errorMessage)
                    return
                }
                if let _ = result?.errors?.first {
                    let message = "Unable to register.".localized
                    let errorMessage = "\(self.errorMessageHeader) \(message)"
                    self.displayError(message: errorMessage)
                    return
                }
                guard let user = result?.data?.me.fragments.userDetails else {
                    let message = "Unable to register.".localized
                    let errorMessage = "\(self.errorMessageHeader) \(message)"
                    self.displayError(message: errorMessage)
                    ApolloManager.shared.removeAuthorization()
                    return
                }
                if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                    appDelegate.user = user
                    let tabBar = TabBarController.instantiate(fromAppStoryboard: .Main)
                    appDelegate.window?.rootViewController = tabBar
                }
            }
        }
        
        */
        
        
        // Perform any operations on signed in user here.
        /*
         let userId = user.userID                  // For client-side use only!
         let idToken = user.authentication.idToken // Safe to send to the server
         let fullName = user.profile.name
         let givenName = user.profile.givenName
         let familyName = user.profile.familyName
         let email = user.profile.email
         NSString *idToken = user.authentication.idToken;
         */
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!)
    {
        #if !PROD
        print("[\(type(of: self)) \(#function)]")
        #endif
    }
}

// MARK: - Private
extension SignUpViewController
{
    internal func doSignUpWithEmail()
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
        
        guard let firstName = self.firstNameTextInput.value?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) else { return }
        let lastName = self.lastNameTextInput.value?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        let input = CreateUserInput(name: firstName, email: email, password: password, lastName: lastName)
        let createUser = CreateUserMutation(data: input)
        
        self.showModalActivityIndicator()
        
        ApolloManager.shared.client.perform(mutation: createUser) { [weak self] result in
            guard let strongSelf = self else { return }
            strongSelf.hideModalActivityIndicator()
            switch result {
            case .success(let graphQLResult):
                guard let token = graphQLResult.data?.createUser.token, !token.isEmpty, let user = graphQLResult.data?.createUser.user.fragments.userDetails else {
                    let message = "Wrong server response.".localized
                    let errorMessage = "\(strongSelf.errorMessageHeader) \(message)"
                    #if !PROD
                    print("[\(type(of: self)) \(#function)] 3: errorMessage: \(errorMessage)")
                    #endif
                    strongSelf.displayError(message: errorMessage)
                    return
                }
                ApolloManager.shared.setAuthorization(token: token)
                appDelegate.repository.user = User(user)
                ApolloManager.shared.client.fetch(query: MeQuery(), cachePolicy: .fetchIgnoringCacheData, queue: .main) { [weak self] result in
                    guard let strongSelf = self else { return }
                    switch result {
                    case .success(let graphQLResult):
                        guard let user = graphQLResult.data?.me.fragments.userDetails else {
                            let message = "Unable to sign up.".localized
                            let errorMessage = "\(strongSelf.errorMessageHeader) \(message)"
                            strongSelf.displayError(message: errorMessage)
                            ApolloManager.shared.removeAuthorization()
                            return
                        }
                        appDelegate.repository.user = User(user)
                        let tabBar = TabBarController.instantiate(fromAppStoryboard: .Main)
                        appDelegate.window?.rootViewController = tabBar
                    case .failure( _):
                        let message = "Unable to sign up.".localized
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
                print("[\(type(of: self)) \(#function)] error: \(error)")
                #endif
                strongSelf.displayError(message: errorMessage)
                return
            }
        }
    }
    
    internal func doSignUpWithFacebook(token: String)
    {
        /*
        let activityData = ActivityData()
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData, nil)
        
        let input = AuthInput(accessToken: token, refreshToken: "")
        let continueWithFacebook = ContinueWithFacebookMutation(data: input)
        ApolloManager.shared.client.perform(mutation: continueWithFacebook) { result, error in
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
            if let error = error {
                let errorMessage = "\(self.errorMessageHeader) \(error.localizedDescription)"
                #if !PROD
                print("[\(type(of: self)) \(#function)] \(errorMessage)")
                #endif
                self.displayError(message: errorMessage)
                return
            }
            if let error = result?.errors?.first {
                let errorMessage = "\(self.errorMessageHeader) \(error.localizedDescription)"
                #if !PROD
                print("[\(type(of: self)) \(#function)] \(errorMessage)")
                #endif
                self.displayError(message: errorMessage)
                return
            }
            
            guard let token = result?.data?.continueWithFacebook.token else {
                let message = "Wrong server response.".localized
                let errorMessage = "\(self.errorMessageHeader) \(message)"
                #if !PROD
                print("[\(type(of: self)) \(#function)] 3: errorMessage: \(errorMessage)")
                #endif
                self.displayError(message: errorMessage)
                return
            }
            ApolloManager.shared.setAuthorization(token: token)
            
            let activityData = ActivityData()
            NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData, nil)
            
            ApolloManager.shared.client.fetch(query: MeQuery(), cachePolicy: .fetchIgnoringCacheData, queue: .main)
            { result, error in
                NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
                if let _ = error {
                    let message = "Unable to register.".localized
                    let errorMessage = "\(self.errorMessageHeader) \(message)"
                    self.displayError(message: errorMessage)
                    return
                }
                if let _ = result?.errors?.first {
                    let message = "Unable to register.".localized
                    let errorMessage = "\(self.errorMessageHeader) \(message)"
                    self.displayError(message: errorMessage)
                    return
                }
                guard let user = result?.data?.me.fragments.userDetails else {
                    let message = "Unable to register.".localized
                    let errorMessage = "\(self.errorMessageHeader) \(message)"
                    self.displayError(message: errorMessage)
                    ApolloManager.shared.removeAuthorization()
                    return
                }
                if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                    appDelegate.user = user
                    let tabBar = TabBarController.instantiate(fromAppStoryboard: .Main)
                    appDelegate.window?.rootViewController = tabBar
                }
            }
        }
        */
    }
    
    internal func setupViewsOnLoad()
    {
        self.title = "Signup".localized
        self.view.backgroundColor = .background

        self.inputViewCollection.enumerated()
            .forEach {
                guard $0.element != inputViewCollection.last else { return }
                $0.element.nextInput = inputViewCollection[$0.offset + 1]
        }
        
        self.iconImageViewCollection.forEach { $0.imageColor = .lightGray }
        
        // firstNameTextInput
        DesignableTextInput.setupAppearance(forTextInput: self.firstNameTextInput)
        self.firstNameTextInput.title = "First name".localized
        self.firstNameTextInput.delegate = self
        self.firstNameTextInput.validator = self
        /*
         self.firstNameTextInput.validationRules = [
         ValidationRule(rule: .emptyString, message: "Please enter your first name!".localized)
         ]
         */
        
        // lastNameTextInput
        DesignableTextInput.setupAppearance(forTextInput: self.lastNameTextInput)
        self.lastNameTextInput.title = "Last name".localized
        self.lastNameTextInput.delegate = self
        self.lastNameTextInput.validator = self
        /*
         self.lastNameTextInput.validationRules = [
         ValidationRule(rule: .emptyString, message: "Please enter your last name!".localized)
         ]
         */
        
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
        
//        GIDSignIn.sharedInstance().uiDelegate = self
        
        
        #if !PROD
        /*
         let userNum = 3
         let userName = "ios_user_\(userNum)"
         let lastName = "Test"
         let email = "\(userName)@example.com"
         let password = "12345678"
         
         
         self.firstNameTextInput.value = userName
         self.lastNameTextInput.value = lastName
         self.emailTextInput.value = email
         self.passwordTextInput.value = password
         */
        /*
        let userName = "Alexandr"
        let lastName = "Pronin"
        let email = "pronin.alx@gmail.com"
        let password = "dsq8k40l"
        
        
        self.firstNameTextInput.value = userName
        self.lastNameTextInput.value = lastName
        self.emailTextInput.value = email
        self.passwordTextInput.value = password
        */
        #endif
    }
}

//
//  LandingViewController.swift
//  boilerplate
//
//  Created by Aleksandr Pronin on 20.04.19.
//  Copyright © 2019 Aleksandr Pronin. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class LandingViewController: BaseViewController
{
    // MARK: - Public API
    public var autologin: Bool = true
    
    // MARK: - View Lifecycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.setupViewsOnLoad()
        self.doAutoLogin()
    }

    // MARK: - Actions
    
    // MARK: - Display logic
    // MARK: - Private
}

// MARK: - Private
extension LandingViewController
{
    internal func doAutoLogin()
    {
        guard self.autologin else { return }
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        guard let token = UserDefaults.standard.string(forKey: .keyAuthorizationToken) else { return }
        
        #if !PROD
        print("[\(type(of: self)) \(#function)] stored token: \(token)")
        #endif
        
        ApolloManager.shared.setAuthorization(token: token)
        
        let activityData = ActivityData()
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData, nil)
        
        ApolloManager.shared.client.fetch(query: MeQuery(), cachePolicy: .fetchIgnoringCacheData, queue: .main) { result in
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
            switch result {
            case .success(let graphQLResult):
                guard let user = graphQLResult.data?.me.fragments.userDetails else {
                    /*print("[\(type(of: self)) \(#function)] Wrong user id!")*/
                    ApolloManager.shared.removeAuthorization()
                    return
                }
                appDelegate.repository.user = User(user)
            case .failure(let error):
                /*
                if let message = error.message, message == "jwt malformed" {
                    ApolloManager.shared.removeAuthorization()
                }
                */
                #if !PROD
                print("[\(type(of: self)) \(#function)] errorMessage: \(error)")
                #endif
                return
            }
            
            
            /*print("[\(type(of: self)) \(#function)] id: \(id)")*/
//            appDelegate.user = user
            
            let tabBar = TabBarController.instantiate(fromAppStoryboard: .Main)
            appDelegate.window?.rootViewController = tabBar
        }
    }
    
    internal func setupViewsOnLoad()
    {
        self.view.backgroundColor = .background
        self.navigationController?.navigationBar.barStyle = .black
    }
}

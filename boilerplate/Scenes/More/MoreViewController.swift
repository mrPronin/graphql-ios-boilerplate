//
//  MoreViewController.swift
//  boilerplate
//
//  Created by Aleksandr Pronin on 20.04.19.
//  Copyright © 2019 Aleksandr Pronin. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class MoreViewController: BaseViewController
{
    // MARK: - Public API
    
    // MARK: - View Lifecycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.setupViewsOnLoad()
    }
    
    // MARK: - Actions
    @IBAction func logoutAction(_ sender: Any)
    {
        self.logoutIfNeeded()
    }
    
    @IBAction func deleteAccount(_ sender: Any)
    {
        self.deleteIfNeeded()
    }
    
    // MARK: - Display logic
    // MARK: - Private
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var updatedAtLabel: UILabel!
    @IBOutlet weak var pictureStaticLabel: UILabel!
    @IBOutlet weak var pictureLabel: UILabel!
    @IBOutlet weak var signupTypeLabel: UILabel!
    
    @IBOutlet var labelCollection: [UILabel]!
    
}

// MARK: - Private
extension MoreViewController
{
    internal func deleteIfNeeded()
    {
        let alert = UIAlertController(title: "Delete".localized, message: "Are you sure you want to delete user?".localized, preferredStyle: .alert)
        let actionYes = UIAlertAction(title: "Yes".localized, style: .default) { [weak self] (action) in
            guard let strongSelf = self else { return }
            strongSelf.doDelete()
        }
        let actionNo = UIAlertAction(title: "No".localized, style: .cancel, handler: nil)
        alert.addAction(actionYes)
        alert.addAction(actionNo)
        self.present(alert, animated: true, completion: nil)
    }
    
    internal func doDelete()
    {
        /*
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let activityData = ActivityData()
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData, nil)
        
        ApolloManager.shared.client.perform(mutation: DeleteUserMutation())
        { [unowned self] result, error in
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
            if let _ = error {
                /*print("[\(type(of: self)) \(#function)] 01. error: \(error)")*/
                return
            }
            if let _ = result?.errors?.first {
                /*print("[\(type(of: self)) \(#function)] 02. error: \(error)")*/
                return
            }
            
            guard let user = result?.data?.deleteUser.fragments.userDetails else {
                return
            }
            ApolloManager.shared.removeAuthorization()
            
            let usernameString: String
            if let name = user.name {
                usernameString = " '\(name)'"
            } else if let email = user.email {
                usernameString = " '\(email)'"
            } else {
                usernameString = ""
            }
            
            let alert = UIAlertController(title: "Deleted".localized, message: "User\(usernameString) successfully deleted!".localized, preferredStyle: .alert)
            let actionYes = UIAlertAction(title: "Yes".localized, style: .default) { (action) in
                let vc = LandingViewController.instantiate(fromAppStoryboard: .Main)
                vc.autologin = false
                let nc = UINavigationController(rootViewController: vc)
                appDelegate.window?.rootViewController = nc
            }
            alert.addAction(actionYes)
            self.present(alert, animated: true, completion: nil)
        }
        */
    }
    
    internal func logoutIfNeeded()
    {
        let alert = UIAlertController(title: "Logout".localized, message: "Are you sure you want to log out?".localized, preferredStyle: .alert)
        let actionYes = UIAlertAction(title: "Yes".localized, style: .default) { [weak self] (action) in
            guard let strongSelf = self else { return }
            strongSelf.doLogout()
        }
        let actionNo = UIAlertAction(title: "No".localized, style: .cancel, handler: nil)
        alert.addAction(actionYes)
        alert.addAction(actionNo)
        self.present(alert, animated: true, completion: nil)
    }
    
    internal func doLogout()
    {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        ApolloManager.shared.removeAuthorization()
        let vc = LandingViewController.instantiate(fromAppStoryboard: .Main)
        vc.autologin = false
        let nc = UINavigationController(rootViewController: vc)
        appDelegate.window?.rootViewController = nc
    }
    
    internal func setupViewsOnLoad()
    {
        self.title = "More".localized
        
        self.labelCollection.forEach { $0.text = nil }
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate, let user = appDelegate.repository.user else { return }
        
        self.idLabel.text = user.id
        self.nameLabel.text = user.name
        self.lastNameLabel.text = user.lastName
        self.emailLabel.text = user.email
//        self.createdAtLabel.text = user.createdAt
//        self.updatedAtLabel.text = user.updatedAt
        self.pictureLabel.text = user.picture
        self.signupTypeLabel.text = user.signupType.rawValue
    }
}

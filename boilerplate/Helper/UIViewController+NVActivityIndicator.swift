//
//  UIViewController+NVActivityIndicator.swift
//  boilerplate
//
//  Created by Oleksandr Pronin on 10.10.19.
//  Copyright © 2019 Goodthoughts.club. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

@objc public extension UIViewController
{
    @objc func showModalActivityIndicator()
    {
        let activityData = ActivityData()
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData, nil)
    }
    
    @objc func hideModalActivityIndicator()
    {
        NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
    }
}

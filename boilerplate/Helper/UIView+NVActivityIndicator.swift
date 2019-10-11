//
//  UIView+NVActivityIndicator.swift
//  boilerplate
//
//  Created by Oleksandr Pronin on 10.10.19.
//  Copyright © 2019 Goodthoughts.club. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

public extension UIView
{
    func showModalActivityIndicator()
    {
        let activityData = ActivityData(type: .ballScale)
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData, nil)
    }
    
    func hideModalActivityIndicator()
    {
        NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
    }
    
    func showActivityIndicator()
    {
        let sideLength: CGFloat = 60
        let indicatorFrame = CGRect(x: 0, y: 0, width: sideLength, height: sideLength)
        let indicatorView = NVActivityIndicatorView(frame: indicatorFrame, color: .brand)
        indicatorView.alpha = 0.5
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(indicatorView)
        self.bringSubviewToFront(indicatorView)
        
        var constraints: [NSLayoutConstraint] = []
        
        // height
        constraints.append(indicatorView.heightAnchor.constraint(equalToConstant: sideLength))
        // width
        constraints.append(indicatorView.widthAnchor.constraint(equalToConstant: sideLength))
        // center X
        constraints.append(indicatorView.centerXAnchor.constraint(equalTo: self.centerXAnchor))
        // center Y
        constraints.append(indicatorView.centerYAnchor.constraint(equalTo: self.centerYAnchor))
        
        constraints.forEach { $0.isActive = true }
        
        indicatorView.startAnimating()
    }
    
    func hideActivityIndicator()
    {
        self.subviews
            .filter { $0 is NVActivityIndicatorView }
            .compactMap { $0 as? NVActivityIndicatorView }
            .forEachPerform { $0.stopAnimating() }
            .forEach { $0.removeFromSuperview() }
    }
}

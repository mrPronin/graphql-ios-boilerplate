//
//  AppDelegate+appearance.swift
//  boilerplate
//
//  Created by Oleksandr Pronin on 26.09.19.
//  Copyright © 2019 Goodthoughts.club. All rights reserved.
//

import UIKit

extension AppDelegate
{
    public func setupAppearance()
    {
        UINavigationBar.appearance().isTranslucent = false
        
        let fontSize: FontSize
        switch UIDevice.current.type {
        case .iPhoneX, .iPhoneXR, .iPhoneXMax, .iPhonePlus:
            fontSize = .h5
            break
        case .iPhone4OrLess, .iPhone5:
            fontSize = .h6
            break
        default:
            fontSize = .h6
            break
        }

        UINavigationBar.appearance().titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.brand(font: .medium, withSize: fontSize),
            NSAttributedString.Key.foregroundColor: UIColor.textWhite
        ]
        
        UINavigationBar.appearance().tintColor = UIColor.brand
        UINavigationBar.appearance().barTintColor = UIColor.background
        
        // Tab bar
//        UITabBar.appearance().barTintColor = .white
//        UITabBar.appearance().unselectedItemTintColor = .tabBarUnselectedItem
//        UITabBar.appearance().tintColor = .tabBarSelectedItem
    }
}

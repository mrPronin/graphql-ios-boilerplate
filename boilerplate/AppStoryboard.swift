//
//  AppStoryboard.swift
//  boilerplate
//
//  Created by Oleksandr Pronin on 27.04.19.
//  Copyright © 2019 Aleksandr Pronin. All rights reserved.
//

import UIKit

@objc public enum AppStoryboard: Int
{
    case Main
}

public enum _AppStoryboard: String
{
    case Main

    static fileprivate func valueFromPublic(value: AppStoryboard) -> _AppStoryboard
    {
        switch value {
            case AppStoryboard.Main: return .Main
        }
    }
    
    fileprivate var instance : UIStoryboard {
        return UIStoryboard(name: self.rawValue, bundle: Bundle.main)
    }
    
    fileprivate func viewController<T : UIViewController>(viewControllerClass : T.Type, function : String = #function, line : Int = #line, file : String = #file) -> T
    {
        let storyboardID = (viewControllerClass as UIViewController.Type).storyboardID
        let storyboard = self.instance
        guard let scene = storyboard.instantiateViewController(withIdentifier: storyboardID) as? T else {
            fatalError("ViewController with identifier \(storyboardID), not found in \(self.rawValue) Storyboard.\nFile : \(file) \nLine Number : \(line) \nFunction : \(function)")
        }
        return scene
    }
}

@objc public extension UIViewController
{
    // Not using static as it wont be possible to override to provide custom storyboardID then
    @nonobjc fileprivate class var storyboardID : String {
        
        return "\(self)"
    }
    
    @objc static func instantiate(fromAppStoryboard appStoryboard: AppStoryboard) -> Self
    {
        let internalValue = _AppStoryboard.valueFromPublic(value: appStoryboard)
        return internalValue.viewController(viewControllerClass: self)
    }
}

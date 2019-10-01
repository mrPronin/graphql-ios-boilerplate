//
//  InputView+Appearance.swift
//  boilerplate
//
//  Created by Aleksandr Pronin on 22.04.19.
//  Copyright © 2019 Aleksandr Pronin. All rights reserved.
//

import UIKit
import ReusableDataInput

public extension InputView
{
    class func setupAppearance(forInputView inputView: InputView)
    {
        let primaryColor = UIColor.input
        let backgroundColor = UIColor.backgroundLight
        
        inputView.normalColor = primaryColor
        inputView.normalImageColor = primaryColor
        inputView.normalBackgroundColor = backgroundColor
        inputView.normalBorder = 0
        
        inputView.activeColor = primaryColor
        inputView.activeImageColor = primaryColor
        inputView.activeBackgroundColor = backgroundColor
        inputView.activeBorder = 0
        
        inputView.errorColor = UIColor.red
        inputView.errorBackgroundColor = backgroundColor
        inputView.errorMsgBackground = backgroundColor
        inputView.errorMsgColor = UIColor.red
        inputView.errorImage = nil
        
        inputView.infoColor = primaryColor
        inputView.infoBackgroundColor = backgroundColor
        inputView.infoMsgBackground = backgroundColor
        inputView.infoMsgColor = primaryColor
        
        let fontSize: FontSize
        if UIDevice.current.type == .iPhone4OrLess || UIDevice.current.type == .iPhone5 {
            fontSize = .h5
        } else {
            fontSize = .h4
        }
        
        inputView.normalTextColor = .textDark
        inputView.font = UIFont.brand(font: .medium, withSize: fontSize)
        inputView.placeholderFont = UIFont.brand(font: .medium, withSize: fontSize)
        
        inputView.titleColor = .secondary
        inputView.titleFont = UIFont.brand(font: .medium, withSize: .h8)
        inputView.cornerRadius = 0
        inputView.messageFont = UIFont.brand(font: .regular, withSize: .h7)
        
        inputView.separatorColor = .divider
        inputView.separatorHeight = 1
        inputView.isSeparatorHidden = false
    }
}

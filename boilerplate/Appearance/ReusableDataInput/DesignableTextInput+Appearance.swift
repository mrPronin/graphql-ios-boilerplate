//
//  DesignableTextInput+Appearance.swift
//  boilerplate
//
//  Created by Aleksandr Pronin on 22.04.19.
//  Copyright © 2019 Aleksandr Pronin. All rights reserved.
//

import UIKit
import ReusableDataInput

public extension DesignableTextInput
{
    class func setupAppearance(forTextInput textInput: DesignableTextInput)
    {
        DesignableTextInput.setupAppearance(forInputView: textInput)
        
        textInput.keyboardType = .default
        textInput.textField.autocorrectionType = .no
        textInput.textField.spellCheckingType = .no
        textInput.textField.autocapitalizationType = .none
        textInput.textField.returnKeyType = .next
    }
}

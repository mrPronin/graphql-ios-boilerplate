//
//  DesignableMaskedTextInput+Appearance.swift
//  boilerplate
//
//  Created by Aleksandr Pronin on 22.04.19.
//  Copyright © 2019 Aleksandr Pronin. All rights reserved.
//

import UIKit
import ReusableDataInput

public extension DesignableMaskedTextInput
{
    class func setupAppearance(forTextInput textInput: DesignableMaskedTextInput)
    {
        DesignableTextInput.setupAppearance(forInputView: textInput)
    }
}

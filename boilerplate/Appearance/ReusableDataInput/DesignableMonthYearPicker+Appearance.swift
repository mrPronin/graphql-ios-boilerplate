//
//  DesignableMonthYearPicker+Appearance.swift
//  boilerplate
//
//  Created by Aleksandr Pronin on 22.04.19.
//  Copyright © 2019 Aleksandr Pronin. All rights reserved.
//

import UIKit
import ReusableDataInput

public extension DesignableMonthYearPicker
{
    class func setupAppearance(forPicker inputView: DesignableMonthYearPicker)
    {
        DesignableTextInput.setupAppearance(forInputView: inputView)
        
        inputView.toolbarBackgroundColor = .background
        inputView.pickerColor = .primary
        inputView.pickerTextColor = .primary
        
        inputView.pickerFont = UIFont.brand(font: .regular, withSize: .h4)
        inputView.cancelButton.title = "Cancel".localized
        inputView.doneButton.title = "Done".localized
    }
}

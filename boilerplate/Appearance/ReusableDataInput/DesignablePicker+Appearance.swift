//
//  DesignablePicker+Appearance.swift
//  boilerplate
//
//  Created by Aleksandr Pronin on 22.04.19.
//  Copyright © 2019 Aleksandr Pronin. All rights reserved.
//

import UIKit
import ReusableDataInput

public extension DesignablePicker
{
    class func setupAppearance(forPicker picker: DesignablePicker)
    {
        DesignablePicker.setupAppearance(forInputView: picker)
        
        picker.toolbarBackgroundColor = .background
        picker.pickerColor = .primary
        picker.pickerTextColor = .primary
        
        picker.pickerFont = UIFont.brand(font: .regular, withSize: .h4)
        picker.cancelButton.title = "Cancel".localized
        picker.doneButton.title = "Done".localized
        
        let pickerArrow = UIImage(named: "ic_pickerArrow")
        picker.normalImage = pickerArrow
        picker.activeImage = pickerArrow
    }
}

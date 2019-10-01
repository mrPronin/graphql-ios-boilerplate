//
//  DesignableDatePicker+Appearance.swift
//  boilerplate
//
//  Created by Aleksandr Pronin on 22.04.19.
//  Copyright © 2019 Aleksandr Pronin. All rights reserved.
//

import UIKit
import ReusableDataInput

public extension DesignableDatePicker
{
    class func setupAppearance(forDatePicker picker: DesignableDatePicker)
    {
        DesignableDatePicker.setupAppearance(forInputView: picker)
        
        picker.toolbarBackgroundColor = .background
        picker.pickerColor = .primary
        
        picker.cancelButton.title = "Cancel".localized
        picker.doneButton.title = "Done".localized

        let calendarImage = UIImage(named: "ic_calendar")
        picker.normalImage = calendarImage
        picker.activeImage = calendarImage
    }
}

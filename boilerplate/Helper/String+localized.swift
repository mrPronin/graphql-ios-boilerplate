//
//  String+localized.swift
//  boilerplate
//
//  Created by Aleksandr Pronin on 22.04.19.
//  Copyright © 2019 Aleksandr Pronin. All rights reserved.
//

import Foundation

extension String
{
    public var localized: String {
        // TODO: provide localisation feature
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
//        return self
    }
}

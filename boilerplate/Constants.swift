//
//  Constants.swift
//  boilerplate
//
//  Created by Oleksandr Pronin on 25.04.19.
//  Copyright © 2019 Aleksandr Pronin. All rights reserved.
//

import Foundation

struct Constants
{
    static let toastDuration: TimeInterval = 9
    
    #if PROD
    
    static let baseURL = "http://localhost:4001"
    static let googleClientID = "81886991308-ons41ruvdg06b3kj0449i6fpg457oi49.apps.googleusercontent.com"

    #elseif DEV
    
    static let baseURL = "http://localhost:4001"
    static let googleClientID = "1062702088696-skscbia3mi4u6a3entta6nfr82sbf16u.apps.googleusercontent.com"

    #elseif TEST
    
    static let baseURL = "http://localhost:4001"
    static let googleClientID = "81886991308-ons41ruvdg06b3kj0449i6fpg457oi49.apps.googleusercontent.com"

    #endif
}

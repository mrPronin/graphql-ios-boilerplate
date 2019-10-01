//
//  User.swift
//  boilerplate
//
//  Created by Oleksandr Pronin on 26.09.19.
//  Copyright © 2019 Goodthoughts.club. All rights reserved.
//

import Foundation

public protocol UserProtocol
{
    var id: String { get set }
    var name: String? { get set }
    var email: String? { get set }
    var lastName: String? { get set }
    var picture: String? { get set }
    var signupType: AuthProviderType { get set }
}

public struct User: UserProtocol, Equatable
{
    public var id: String
    public var name: String?
    public var email: String?
    public var lastName: String?
    public var picture: String?
    public var signupType: AuthProviderType
}

public extension User
{
    init(_ userDetails: UserDetails) {
        self.id = userDetails.id
        self.name = userDetails.name
        self.email = userDetails.email
        self.lastName = userDetails.lastName
        self.picture = userDetails.picture
        self.signupType = userDetails.signupType
    }
    
    /*
    var updateUserInput: UpdateUserInput {
        return UpdateUserInput(
            name: self.name,
            email: self.email,
            lastName: self.lastName,
            picture: self.picture
        )
    }
    */
}

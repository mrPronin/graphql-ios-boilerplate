//
//  UserRepository.swift
//  boilerplate
//
//  Created by Oleksandr Pronin on 26.09.19.
//  Copyright © 2019 Goodthoughts.club. All rights reserved.
//

import Foundation

public protocol UserRepositoryProtocol
{
    var user: UserProtocol? { get set }
}

public class UserRepository: UserRepositoryProtocol
{
    public var user: UserProtocol?
}

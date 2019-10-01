//
//  ApolloManager.swift
//  boilerplate
//
//  Created by Aleksandr Pronin on 21.04.19.
//  Copyright © 2019 Aleksandr Pronin. All rights reserved.
//

import UIKit
import Apollo

public class ApolloManager
{
    public static let shared = ApolloManager()
    public private(set) lazy var client: ApolloClient = {
        let client = ApolloClient(networkTransport: self.networkTransport)
        client.cacheKeyForObject = { $0["id"] }
        return  client
    }()
//    static var isAuthorized: Bool = false
    
    func setAuthorization(token: String)
    {
        UserDefaults.standard.set(token, forKey: .keyAuthorizationToken)
    }
    
    func removeAuthorization()
    {
        UserDefaults.standard.removeObject(forKey: .keyAuthorizationToken)
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.repository.user = nil
        }
    }
    
    // MARK: - Private
    private lazy var networkTransport = HTTPNetworkTransport(url: URL(string: Constants.baseURL)!, delegate: self)
}

// MARK: - HTTPNetworkTransportPreflightDelegate
extension ApolloManager: HTTPNetworkTransportPreflightDelegate
{
    public func networkTransport(_ networkTransport: HTTPNetworkTransport, shouldSend request: URLRequest) -> Bool
    {
        return true
    }
    
    public func networkTransport(_ networkTransport: HTTPNetworkTransport, willSend request: inout URLRequest)
    {
        guard let token = UserDefaults.standard.string(forKey: .keyAuthorizationToken) else { return }
        var headers = request.allHTTPHeaderFields ?? [String: String]()
        headers["Authorization"] = "Bearer \(token)"
        request.allHTTPHeaderFields = headers
    }
}

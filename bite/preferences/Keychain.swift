//
//  Keychain.swift
//  bite
//
//  Created by Jan Doornbos on 31-07-16.
//  Copyright © 2016 Move4Mobile. All rights reserved.
//

import UIKit
import KeychainSwift

class Keychain {
    
    static let ApiAccessToken = "ApiAccessToken"
    static let ApiRefreshToken = "ApiRefreshToken"
    
    class func saveAccessToken(accessToken: String) {
        KeychainSwift().set(accessToken, forKey: ApiAccessToken)
    }
    
    class func getAccessToken() -> String? {
        return KeychainSwift().get(ApiAccessToken)
    }
    
    class func saveRefreshToken(refreshToken: String) {
        KeychainSwift().set(refreshToken, forKey: ApiRefreshToken)
    }
    
    class func getRefreshToken() -> String? {
        return KeychainSwift().get(ApiRefreshToken)
    }
    
    class func removeCredentials() {
        KeychainSwift().delete(ApiRefreshToken)
        KeychainSwift().delete(ApiAccessToken)
    }
    
}

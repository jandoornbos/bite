//
//  OAuthManager.swift
//  bite
//
//  Created by Jan Doornbos on 31-07-16.
//  Copyright © 2016 Move4Mobile. All rights reserved.
//

import UIKit

import UIKit
import Alamofire
import AlamofireObjectMapper

class OAuthManager {
    
    static let baseUrl = Config.baseUrl
    
    class func isTokenExpired() -> Bool {
        if Keychain.getAccessToken() == nil {
            return true
        }
        
        let currentTime = Int(NSDate().timeIntervalSince1970)
        let expireTime = Preferences.getIntFromPreference(.ApiTokenExpiresIn)
        let tokenTime = Preferences.getIntFromPreference(.ApiTokenLastRefresh)
        
        if currentTime - tokenTime >= expireTime {
            return true
        } else {
            return false
        }
    }
    
    class func getAccessToken(result: (token: String) -> ()) {
        if OAuthManager.isTokenExpired() {
            if Keychain.getAccessToken() == nil {
                result(token: "")
            } else {
                refreshAccessToken({ (token) in
                    result(token: token)
                })
            }
        } else {
            if let token = Keychain.getAccessToken() {
                result(token: token)
            } else {
                // Logout
            }
        }
    }
    
    class func getRequestHeaders(result: (headers: [ String : String ]) -> ()) {
        self.getAccessToken { (token) in
            let headers = [
                "Authorization" : "Bearer " + token,
                "Accept" : "application/json"
            ]
            result(headers: headers)
        }
    }
    
    class func refreshAccessToken(result: (token: String) -> ()) {
        guard let refreshToken = Keychain.getRefreshToken() else {
            // Logout
            return
        }
        
        let body = [
            "grant_type" : "refresh_token",
            "refresh_token" : refreshToken,
        ]
        
        Alamofire.request(.POST, self.baseUrl + "/oauth/token", parameters: body, encoding: .JSON, headers: nil).responseObject {
            (sResponse: Response<LoginResponse, NSError>) in
            
            if sResponse.response?.statusCode == 200 {
                if let response = sResponse.result.value {
                    if let token = response.accessToken, refreshToken = response.refreshToken, expires = response.expiresIn {
                        Keychain.saveAccessToken(token)
                        Keychain.saveRefreshToken(refreshToken)
                        Preferences.saveIntForPreference(expires, pref: .ApiTokenExpiresIn)
                        Preferences.saveIntForPreference(Int(NSDate().timeIntervalSince1970), pref: .ApiTokenLastRefresh)
                        result(token: token)
                    } else {
                        // Logout
                    }
                } else {
                    // Logout
                }
            } else {
                // Logout
            }
        }
    }
    
}

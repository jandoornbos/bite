//
//  APIManager.swift
//  bite
//
//  Created by Jan Doornbos on 31-07-16.
//  Copyright © 2016 Move4Mobile. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import AlamofireObjectMapper

enum LoginStatus {
    case Success
    case InvalidCredentials
    case Failed
}

struct APIBlock<T> {
    typealias CompletionObject = (success: Bool, response: T?, error: NSError?) -> ()
    typealias CompletionArray = (success: Bool, response: [T]?, error: NSError?) -> ()
}

class APIManager {
    
    static let baseUrl = Config.baseUrl
    
    static let authApi = AuthorisationAPIManager()
    
    class func login(username: String, password: String, result: (status: LoginStatus) -> ()) {
        let parameters = [
            "grant_type" : "password",
            "username" : username,
            "password" : password,
        ]
        
        let headers = [
            "Authorization" : "Basic Yml0ZTpiaXRl",
            "Accept" : "application/json"
        ]
        
        Alamofire.request(.POST, self.baseUrl + "/oauth/token", parameters: parameters, encoding: .JSON, headers: headers).responseObject {
            (response: Response<LoginResponse, NSError>) in
            
            if response.response?.statusCode == 200 {
                if let response = response.result.value {
                    if let token = response.accessToken, refreshToken = response.refreshToken, expires = response.expiresIn {
                        Keychain.saveAccessToken(token)
                        Keychain.saveRefreshToken(refreshToken)
                        Preferences.saveIntForPreference(expires, pref: .ApiTokenExpiresIn)
                        Preferences.saveIntForPreference(Int(NSDate().timeIntervalSince1970), pref: .ApiTokenLastRefresh)
                        result(status: .Success)
                    } else {
                        result(status: .Failed)
                    }
                } else {
                    result(status: .Failed)
                }
            } else if response.response?.statusCode == 400 {
                result(status: .InvalidCredentials)
            } else {
                result(status: .Failed)
            }
        }
    }
    
    class func getStores(withResult result: APIBlock<Store>.CompletionArray) {
        self.authApi.request(.GET, url: self.baseUrl + "/stores", parameters: nil, encoding: .URL, success: { json in
            let mapper = Mapper<Store>().mapArray(json)
            result(success: true, response: mapper, error: nil)
        }) { urlResponse, response, error in
            result(success: false, response: nil, error: error)
        }
    }

}

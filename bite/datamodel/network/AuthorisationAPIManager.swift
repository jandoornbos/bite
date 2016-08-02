//
//  APIManager.swift
//  bite
//
//  Created by Jan Doornbos on 29-07-16.
//  Copyright © 2016 Move4Mobile. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper

typealias APIManagerSuccessBlock = (AnyObject?) -> ()
typealias APIManagerFailureBlock = (NSHTTPURLResponse?, AnyObject?, NSError) -> ()

class AuthorisationAPIManager: Manager {
    
    static let baseUrl = Config.baseUrl
    
    typealias CachedTask = (NSHTTPURLResponse?, AnyObject?, NSError?) -> Void
    
    private var cachedTasks = Array<CachedTask>()
    private var isRefreshing = false
    
    func request(method: Alamofire.Method,
                        url: URLStringConvertible,
                        parameters: [String : AnyObject]?,
                        encoding: ParameterEncoding,
                        success: APIManagerSuccessBlock?,
                        failure: APIManagerFailureBlock?) -> Request? {
        let cachedTask: CachedTask = { [weak self] URLResponse, data, error in
            guard let strongSelf = self else { return }
            
            if let error = error {
                failure?(URLResponse, data, error)
            } else {
                strongSelf.request(method, url: url, parameters: parameters, encoding: encoding, success: success, failure: failure)
            }
        }
        
        if self.isRefreshing {
            self.cachedTasks.append(cachedTask)
            return nil
        }
        
        var auth: String = ""
        if let token = Keychain.getAccessToken() {
            auth = "Bearer " + token
        }
        
        let headers = [
            "Authorization" : auth,
            "Accept" : "application/json"
        ]
        
        let request = self.request(method, url, parameters: parameters, encoding: encoding, headers: headers)
        request.responseJSON { [weak self] (response: Response<AnyObject, NSError>) in
            guard let strongSelf = self else { return }
            
            if let response = response.response where response.statusCode == 401 {
                strongSelf.cachedTasks.append(cachedTask)
                strongSelf.refreshTokens()
                return
            }
            
            if let error = response.result.error {
                failure?(response.response, response.result.value, error)
            } else {
                success?(response.result.value)
            }
        }
        
        return request
    }
    
    func refreshTokens() {
        self.isRefreshing = true
        OAuthManager.refreshAccessToken { (token) in
            let cachedTaskCopy = self.cachedTasks
            self.cachedTasks.removeAll()
            _ = cachedTaskCopy.map { $0(nil, nil, nil) }
            
            self.isRefreshing = false
        }
    }
    
}

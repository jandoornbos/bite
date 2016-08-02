//
//  DataModel.swift
//  bite
//
//  Created by Jan Doornbos on 07-07-16.
//  Copyright © 2016 Move4Mobile. All rights reserved.
//

import UIKit

struct DataBlock<T> {
    typealias CompletionObject = (success: Bool, result: T?, error: NSError?) -> ()
    typealias CompletionArray = (success: Bool, result: [T]?, error: NSError?) -> ()
}

class DataModel {
    
    static let sharedInstance = DataModel()
    
    func isLoggedIn() -> Bool {
        return Keychain.getAccessToken() != nil
    }
    
    func login(username: String, password: String, result: (status: LoginStatus) -> ()) {
        APIManager.login(username, password: password) { (status) in
            result(status: status)
        }
    }
    
    func getStores(withResult result: DataBlock<Store>.CompletionArray) {
        APIManager.getStores { (success, response, error) in
            result(success: success, result: response, error: error)
        }
    }

}

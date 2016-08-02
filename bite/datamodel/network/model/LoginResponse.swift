//
//  LoginResponse.swift
//  bite
//
//  Created by Jan Doornbos on 29-07-16.
//  Copyright © 2016 Move4Mobile. All rights reserved.
//

import UIKit
import ObjectMapper

class LoginResponse: Mappable {

    var accessToken: String?
    var tokenType: String?
    var refreshToken: String?
    var expiresIn: Int?
    var scope: String?
    
    required init?(_ map: Map) {}
    
    func mapping(map: Map) {
        accessToken <- map["access_token"]
        tokenType <- map["token_type"]
        refreshToken <- map["refresh_token"]
        expiresIn <- map["expires_in"]
        scope <- map["scope"]
    }
    
}

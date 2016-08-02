//
//  Store.swift
//  bite
//
//  Created by Jan Doornbos on 31-07-16.
//  Copyright © 2016 Move4Mobile. All rights reserved.
//

import UIKit
import ObjectMapper

class Store: Mappable {

    var id: Int?
    var name: String?
    var description: String?
    
    required init?(_ map: Map) {}
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        description <- map["description"]
    }
    
}

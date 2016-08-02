//
//  NSData+String.swift
//  bite
//
//  Created by Jan Doornbos on 31-07-16.
//  Copyright © 2016 Move4Mobile. All rights reserved.
//

import UIKit

extension NSData {
    
    func toString() -> String? {
        return String(data: self, encoding: NSUTF8StringEncoding)
    }
    
}
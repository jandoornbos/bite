//
//  Style.swift
//  bite
//
//  Created by Jan Doornbos on 08-07-16.
//  Copyright © 2016 Move4Mobile. All rights reserved.
//

import UIKit

class Style {
    
    class func setStyle() {
        UINavigationBar.appearance().barTintColor = Color.gray()
        UINavigationBar.appearance().translucent = false
        UINavigationBar.appearance().tintColor = Color.white()
        let titleDict = [
            NSForegroundColorAttributeName : Color.white()
        ]
        UINavigationBar.appearance().titleTextAttributes = titleDict
    }

}

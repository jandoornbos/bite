//
//  Preferences.swift
//  bite
//
//  Created by Jan Doornbos on 31-07-16.
//  Copyright © 2016 Move4Mobile. All rights reserved.
//

import UIKit

enum Preference: String {
    case ApiTokenExpiresIn = "ApiTokenExpiresIn"
    case ApiTokenLastRefresh = "ApiTokenLastRefresh"
}

class Preferences {
    
    class func getStringFromPreference(pref: Preference) -> String? {
        return NSUserDefaults.standardUserDefaults().objectForKey(pref.rawValue) as? String
    }
    
    class func saveStringForPreference(string: String, pref: Preference) {
        NSUserDefaults.standardUserDefaults().setObject(string, forKey: pref.rawValue)
    }
    
    class func getIntFromPreference(pref: Preference) -> Int {
        return NSUserDefaults.standardUserDefaults().integerForKey(pref.rawValue)
    }
    
    class func saveIntForPreference(int: Int, pref: Preference) {
        NSUserDefaults.standardUserDefaults().setInteger(int, forKey: pref.rawValue)
    }
    
    class func getBoolFromPreference(pref: Preference) -> Bool {
        return NSUserDefaults.standardUserDefaults().boolForKey(pref.rawValue)
    }
    
    class func saveBoolForPreference(bool: Bool, pref: Preference) {
        NSUserDefaults.standardUserDefaults().setBool(bool, forKey: pref.rawValue)
    }
    
    class func removePreference(pref: Preference) {
        NSUserDefaults.standardUserDefaults().removeObjectForKey(pref.rawValue)
    }
    
}

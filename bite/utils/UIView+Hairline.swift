//
//  UIView+Hairline.swift
//  bite
//
//  Created by Jan Doornbos on 12-07-16.
//  Copyright © 2016 Move4Mobile. All rights reserved.
//

import UIKit

extension UIView {

    func makeHairline() {
        for constraint in self.constraints {
            if constraint.firstAttribute == .Height {
                constraint.constant = 1 / UIScreen.mainScreen().scale
            }
        }
    }
    
}

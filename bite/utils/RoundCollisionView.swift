//
//  RoundCollisionView.swift
//  bite
//
//  Created by Jan Doornbos on 13-07-16.
//  Copyright © 2016 Move4Mobile. All rights reserved.
//

import UIKit

class RoundCollisionView: UIView {

    override var collisionBoundsType: UIDynamicItemCollisionBoundsType {
        return .Ellipse
    }

}

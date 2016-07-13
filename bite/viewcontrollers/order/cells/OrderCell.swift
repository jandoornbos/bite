//
//  OrderCell.swift
//  bite
//
//  Created by Jan Doornbos on 12-07-16.
//  Copyright © 2016 Move4Mobile. All rights reserved.
//

import UIKit

class OrderCell: UITableViewCell {
    
    static let reuseIdentifier: String = "orderCell"

    @IBOutlet weak var productTitleLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var seperator: UIView!
    @IBOutlet weak var singlePriceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.seperator.makeHairline()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

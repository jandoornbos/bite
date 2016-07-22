//
//  MenuCell.swift
//  bite
//
//  Created by Jan Doornbos on 22-07-16.
//  Copyright © 2016 Move4Mobile. All rights reserved.
//

import UIKit

class MenuCell: UITableViewCell {
    
    static let reuseIdentifier: String = "menuCell"

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var activeView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.activeView.hidden = !selected
    }

}

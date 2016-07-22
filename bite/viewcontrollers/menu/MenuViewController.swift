//
//  MenuViewController.swift
//  bite
//
//  Created by Jan Doornbos on 08-07-16.
//  Copyright © 2016 Move4Mobile. All rights reserved.
//

import UIKit

enum MenuItem: Int {
    case Order
    case Profile
    case History
}

class MenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: Interface Builder Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - View
    
    func setupView() {
        self.tableView.selectRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), animated: false, scrollPosition: .None)
        self.tableView.contentInset = UIEdgeInsetsMake(20.0, 0, 0, 0)
    }
    
    // MARK: - UITableView DataSource & UITableView Delegate
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(MenuCell.reuseIdentifier) as! MenuCell
        switch indexPath.row {
        case MenuItem.Order.rawValue:
            cell.titleLabel.text = "Bestel"
            cell.iconImageView.image = UIImage(named: "menu_order")
        case MenuItem.Profile.rawValue:
            cell.titleLabel.text = "Profiel"
            cell.iconImageView.image = UIImage(named: "menu_profile")
        case MenuItem.History.rawValue:
            cell.titleLabel.text = "History"
            cell.iconImageView.image = UIImage(named: "menu_history")
        default:
            break
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.revealViewController().revealToggleAnimated(true)
    }

}

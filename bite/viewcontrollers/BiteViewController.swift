//
//  BiteViewController.swift
//  bite
//
//  Created by Jan Doornbos on 14-07-16.
//  Copyright © 2016 Move4Mobile. All rights reserved.
//

import UIKit
import SWRevealViewController

class BiteViewController: UIViewController {

    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        let barButton = UIBarButtonItem(image: UIImage(named: "hamburger_icon"), style: .Plain, target: self.revealViewController(), action: #selector(BiteRevealViewController.revealToggle(_:)))
        self.navigationItem.leftBarButtonItem = barButton
        
        let shoppingButton = UIBarButtonItem(image: UIImage(named: "shopping_cart"), style: .Plain, target: self.revealViewController(), action: #selector(BiteRevealViewController.rightRevealToggle(_:)))
        self.navigationItem.rightBarButtonItem = shoppingButton
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

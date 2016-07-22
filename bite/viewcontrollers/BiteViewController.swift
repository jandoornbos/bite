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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

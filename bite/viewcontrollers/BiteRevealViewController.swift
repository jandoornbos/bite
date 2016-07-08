//
//  BiteRevealViewController.swift
//  bite
//
//  Created by Jan Doornbos on 08-07-16.
//  Copyright © 2016 Move4Mobile. All rights reserved.
//

import UIKit
import SWRevealViewController

class BiteRevealViewController: SWRevealViewController {
    
    static let storyboardIdentifier: String = "biteRevealViewController"

    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupRevealViewController()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - SWRevealViewController
    
    func setupRevealViewController() {
        self.rearViewRevealWidth = 120.0
    }

}

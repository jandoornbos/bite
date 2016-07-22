//
//  ProductViewController.swift
//  bite
//
//  Created by Jan Doornbos on 08-07-16.
//  Copyright © 2016 Move4Mobile. All rights reserved.
//

import UIKit
import SWRevealViewController

class ProductViewController: BiteViewController, UITableViewDataSource, UITableViewDelegate, ProductCellDelegate {

    // MARK: Interface Builder Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var basketHitPoint: UIView!
    
    // MARK: Properties
    var productInBasket: Bool = false
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideBasket(false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - View
    
    func hideBasket(animated: Bool) {
        if animated {
            UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.8, options: [], animations: { 
                self.basketHitPoint.transform = CGAffineTransformMakeTranslation(150, 0)
            }, completion: nil)
        } else {
            self.basketHitPoint.transform = CGAffineTransformMakeTranslation(150, 0)
        }
    }
    
    func showBasket() {
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.8, options: [], animations: { 
            self.basketHitPoint.transform = CGAffineTransformIdentity
        }, completion: nil)
    }
    
    // MARK: - UITableView DataSource & UITableView Delegate
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 15
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(ProductCell.reuseIdentifier) as! ProductCell
        cell.delegate = self
        cell.bringSubviewToFront(cell.productImageView)
        return cell
    }
    
    // MARK: - ProductCell Delegate
    
    func productCellStartedAnimation(sender: ProductCell) {
        self.tableView.scrollEnabled = false
        self.tableView.bringSubviewToFront(sender)
        sender.layer.zPosition = 99
    }
    
    func productCellStartDragging(sender: ProductCell) {
        self.showBasket()
    }
    
    func getSuperview() -> UIView {
        return self.view
    }
    
    func productCellImageLocation(location: CGPoint, sender: ProductCell) {
        if CGRectContainsPoint(self.basketHitPoint.frame, location) {
            self.productInBasket = true
            self.basketHitPoint.backgroundColor = UIColor.greenColor()
        } else {
            self.productInBasket = false
            self.basketHitPoint.backgroundColor = Color.yellow()
        }
    }
    
    func productCellInBasket() -> Bool {
        return self.productInBasket
    }
    
    func productCellEndedAnimation(sender: ProductCell) {
        self.basketHitPoint.backgroundColor = Color.yellow()
        self.hideBasket(true)
        self.tableView.scrollEnabled = true
        self.productInBasket = false
    }

}

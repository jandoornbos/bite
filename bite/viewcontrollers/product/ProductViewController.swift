//
//  ProductViewController.swift
//  bite
//
//  Created by Jan Doornbos on 08-07-16.
//  Copyright © 2016 Move4Mobile. All rights reserved.
//

import UIKit
import SWRevealViewController

class ProductViewController: BiteViewController, UITableViewDataSource, UITableViewDelegate, ProductCellDelegate, UIDynamicAnimatorDelegate {

    // MARK: Interface Builder Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var basketHitPoint: UIView!
    
    // MARK: Properties
    var productInBasket: Bool = false
    var movingImageView: UIImageView?
    
    var animator: UIDynamicAnimator!
    var attachmentBehaviour: UIAttachmentBehavior!
    
    var startPoint: CGPoint!
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideBasket(false)
        self.addAnimator()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - View
    
    func addAnimator() {
        self.animator = UIDynamicAnimator(referenceView: self.view)
        self.animator.delegate = self
    }
    
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
    
    func addAttachmentBehaviour(point: CGPoint, startPoint: CGPoint) {
        self.startPoint = startPoint
        guard let movingImageView = self.movingImageView else { return }
        let offset = UIOffsetMake(point.x - movingImageView.bounds.size.width / 2.0, point.y - movingImageView.bounds.size.height / 2.0)
        let anchor = self.movingImageView?.center
        self.attachmentBehaviour = UIAttachmentBehavior(item: movingImageView, offsetFromCenter: offset, attachedToAnchor: anchor!)
        self.animator.addBehavior(self.attachmentBehaviour)
        self.attachmentBehaviour.anchorPoint = startPoint
        self.attachmentBehaviour.action = {
            let transform = self.movingImageView!.transform
            self.movingImageView?.transform = CGAffineTransformScale(transform, 1.4, 1.4)
        }
    }
    
    // MARK: - UITableView DataSource & UITableView Delegate
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(ProductCell.reuseIdentifier) as! ProductCell
        cell.delegate = self
        return cell
    }
    
    // MARK: - ProductCell Delegate
    
    func productCellPanGestureBegan(imageView: UIImageView, pointInView: CGPoint, startPoint: CGPoint, sender: ProductCell) {
        self.tableView.scrollEnabled = false
        self.tableView.userInteractionEnabled = false
        self.movingImageView = UIImageView(image: sender.productImageView.image)
        self.movingImageView?.frame = sender.productImageView.frame
        self.movingImageView?.contentMode = sender.productImageView.contentMode
        self.movingImageView?.center = startPoint
        self.view.addSubview(self.movingImageView!)
        self.showBasket()
        self.addAttachmentBehaviour(pointInView, startPoint: startPoint)
        UIView.animateWithDuration(0.2) {
            self.movingImageView?.transform = CGAffineTransformMakeScale(1.4, 1.4)
        }
    }
    
    func productCellGetSuperview() -> UIView {
        return self.view
    }

    func productCellImageLocationChanged(point: CGPoint, sender: ProductCell) {
        self.attachmentBehaviour.anchorPoint = point
        if CGRectContainsPoint(self.basketHitPoint.frame, point) {
            self.productInBasket = true
            self.basketHitPoint.backgroundColor = UIColor.greenColor()
        } else {
            self.productInBasket = false
            self.basketHitPoint.backgroundColor = Color.yellow()
        }
    }
    
    func productCellPanGestureEnded(sender: ProductCell) {
        self.animator.removeAllBehaviors()
        if !self.productInBasket {
            let snap = UISnapBehavior(item: self.movingImageView!, snapToPoint: self.startPoint)
            self.animator.addBehavior(snap)
            NSTimer.scheduledTimerWithTimeInterval(0.8, target: self, selector: #selector(self.removeMovingImage), userInfo: nil, repeats: false)
        } else {
            self.removeMovingImage()
        }
        self.basketHitPoint.backgroundColor = Color.yellow()
        self.hideBasket(true)
        self.productInBasket = false
    }
    
    func removeMovingImage() {
        self.movingImageView?.removeFromSuperview()
        self.movingImageView = nil
        self.animator.removeAllBehaviors()
        self.tableView.scrollEnabled = true
        self.tableView.userInteractionEnabled = true
    }

}

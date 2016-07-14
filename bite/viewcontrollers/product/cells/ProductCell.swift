//
//  ProductCell.swift
//  bite
//
//  Created by Jan Doornbos on 14-07-16.
//  Copyright © 2016 Move4Mobile. All rights reserved.
//

import UIKit

protocol ProductCellDelegate {
    func productCellStartedAnimation(sender: ProductCell)
    func getSuperview() -> UIView
    func productCellImageLocation(location: CGPoint, sender: ProductCell)
    func productCellInBasket() -> Bool
    func productCellEndedAnimation(sender: ProductCell)
    func productCellStartDragging(sender: ProductCell)
}

class ProductCell: UITableViewCell {
    
    static let reuseIdentifier: String = "productCell"

    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    
    var delegate: ProductCellDelegate? {
        didSet {
            self.animator = UIDynamicAnimator(referenceView: self.delegate!.getSuperview())
        }
    }
    var timer: NSTimer?
    var isDragging: Bool = false
    var draggingAllowed: Bool = false
    var startCenter: CGPoint!
    var productCenter: CGPoint!
    
    var animator: UIDynamicAnimator!
    var attachmentBehaviour: UIAttachmentBehavior!
    
    var panGesture: UIPanGestureRecognizer!
    
    var pointInView: CGPoint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(self.longpress(_:)))
        gesture.minimumPressDuration = 0.1
        gesture.delegate = self
        self.productImageView.addGestureRecognizer(gesture)
        self.panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.handlePan(_:)))
        self.panGesture.delegate = self
        self.productImageView.addGestureRecognizer(self.panGesture)
        self.productCenter = self.productImageView.center
    }
    
    override func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func beginShrinkAnimation() {
        self.delegate?.productCellStartedAnimation(self)
        UIView.animateWithDuration(1.5, animations: {
            self.productImageView.transform = CGAffineTransformMakeScale(0.5, 0.5)
        })
    }
    
    func cancelShrinkAnimation() {
        self.draggingAllowed = false
        self.delegate?.productCellEndedAnimation(self)
        UIView.animateWithDuration(0.3, delay: 0, options: [ .BeginFromCurrentState ], animations: { 
            self.productImageView.transform = CGAffineTransformIdentity
        }, completion: nil)
    }
    
    func beginDragAndDrop() {
        self.delegate?.productCellStartDragging(self)
        UIView.animateWithDuration(0.3, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.9, options: [ .BeginFromCurrentState ], animations: {
            self.productImageView.transform = CGAffineTransformMakeScale(1.6, 1.6)
        }, completion: { finished in
            UIView.animateWithDuration(0.2, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.0, options: [ .BeginFromCurrentState ], animations: {
                self.productImageView.transform = CGAffineTransformMakeScale(1.4, 1.4)
                }, completion: { finished2 in
                    self.addAttachmentBehaviour()
                    self.draggingAllowed = true
            })
        })
    }
    
    func longpress(sender: UILongPressGestureRecognizer) {
        if sender.state == .Began {
            self.timer = NSTimer.scheduledTimerWithTimeInterval(1.5, target: self, selector: #selector(self.beginDragAndDrop), userInfo: nil, repeats: false)
            self.beginShrinkAnimation()
            self.pointInView = sender.locationInView(sender.view)
        }
        if sender.state == .Ended {
            self.timer?.invalidate()
            self.timer = nil
            self.cancelShrinkAnimation()
        }
        if sender.state == .Changed {
            let location = sender.locationInView(self)
            if !self.draggingAllowed {
                if !CGRectContainsPoint(self.productImageView.frame, location) {
                    self.timer?.invalidate()
                    self.timer = nil
                    self.cancelShrinkAnimation()
                }
            }
        }
    }
    
    func handlePan(sender: UIPanGestureRecognizer) {
        if sender.state == .Began {
            let buttonCenter = CGPointMake(self.productImageView.bounds.origin.x + self.productImageView.bounds.size.width/2,
                                               self.productImageView.bounds.origin.y + self.productImageView.bounds.size.height/2);
            let p = self.productImageView.convertPoint(buttonCenter, toView: self.delegate!.getSuperview())
            self.startCenter = p
            self.pointInView = sender.locationInView(sender.view)
        }
        if sender.state == .Changed {
            if self.draggingAllowed {
                let anchor = sender.locationInView(self.delegate!.getSuperview())
                self.delegate?.productCellImageLocation(anchor, sender: self)
                self.attachmentBehaviour.anchorPoint = anchor
            }
        }
        if sender.state == .Ended {
            self.draggingAllowed = false
            self.animator.removeAllBehaviors()
            if !self.delegate!.productCellInBasket() {
                let snap = UISnapBehavior(item: sender.view!, snapToPoint: self.startCenter)
                self.animator.addBehavior(snap)
            } else {
                self.animateBack()
            }
            self.delegate?.productCellEndedAnimation(self)
        }
    }
    
    func addAttachmentBehaviour() {
        let pointWithinView = self.pointInView
        let offset = UIOffsetMake(pointWithinView.x - productImageView.bounds.size.width / 2.0, pointWithinView.y - productImageView.bounds.size.height / 2.0)
        let anchor = self.panGesture.locationInView(self.delegate!.getSuperview())
        self.attachmentBehaviour = UIAttachmentBehavior(item: productImageView, offsetFromCenter: offset, attachedToAnchor: anchor)
        self.attachmentBehaviour.action = {
            if self.draggingAllowed {
                let transform = self.productImageView.transform
                self.productImageView.transform = CGAffineTransformScale(transform, 1.4, 1.4)
            }
        }
        self.animator.addBehavior(self.attachmentBehaviour)
    }
    
    func animateBack() {
        self.productImageView.alpha = 0
        self.productImageView.center = self.productCenter
        UIView.animateWithDuration(0.5, delay: 0.5, options: [], animations: { 
            self.productImageView.alpha = 1
        }, completion: nil)
    }

}

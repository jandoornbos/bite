//
//  ProductCell.swift
//  bite
//
//  Created by Jan Doornbos on 14-07-16.
//  Copyright © 2016 Move4Mobile. All rights reserved.
//

import UIKit

protocol ProductCellDelegate {
    func productCellPanGestureBegan(imageView: UIImageView, pointInView: CGPoint, startPoint: CGPoint, sender: ProductCell)
    func productCellGetSuperview() -> UIView
    func productCellImageLocationChanged(point: CGPoint, sender: ProductCell)
    func productCellPanGestureEnded(sender: ProductCell)
}

class ProductCell: UITableViewCell {
    
    static let reuseIdentifier: String = "productCell"

    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    
    var delegate: ProductCellDelegate?
    var timer: NSTimer?
    var isDragging: Bool = false
    var draggingAllowed: Bool = false
    var startCenter: CGPoint!
    var productCenter: CGPoint!
    
    var panGesture: UIPanGestureRecognizer!
    
    var pointInView: CGPoint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.handlePan(_:)))
        self.panGesture.delegate = self
        self.productImageView.addGestureRecognizer(self.panGesture)
        self.productCenter = self.productImageView.center
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func handlePan(sender: UIPanGestureRecognizer) {
        if sender.state == .Began {
            if let view = sender.view as? UIImageView {
                let pointInView = sender.locationInView(sender.view)
                let startPoint = self.delegate!.productCellGetSuperview().convertPoint(self.productImageView.center, fromView: self)
                self.delegate?.productCellPanGestureBegan(view, pointInView: pointInView, startPoint: startPoint, sender: self)
            }
        } else if sender.state == .Changed {
            let anchor = sender.locationInView(self.delegate!.productCellGetSuperview())
            self.delegate?.productCellImageLocationChanged(anchor, sender: self)
            self.productImageView.alpha = 0
        } else if sender.state == .Ended {
            self.delegate?.productCellPanGestureEnded(self)
            NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: #selector(self.putImageBack), userInfo: nil, repeats: false)
        }
    }
    
    func putImageBack() {
        UIView.animateWithDuration(0.3, animations: {
            self.productImageView.alpha = 1.0
        })
    }

}

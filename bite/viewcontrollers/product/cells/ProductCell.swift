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
    
    func productCellAddButtonPressed(imageView: UIImageView, startPoint: CGPoint, sender: ProductCell)
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
    
    var longPressGesture: UILongPressGestureRecognizer!
    
    var pointInView: CGPoint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.handlePan(_:)))
        self.longPressGesture.delegate = self
        self.longPressGesture.minimumPressDuration = 0.0
        self.productImageView.addGestureRecognizer(self.longPressGesture)
        self.productCenter = self.productImageView.center
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func handlePan(sender: UILongPressGestureRecognizer) {
        switch sender.state {
        case .Began:
            if let view = sender.view as? UIImageView {
                let pointInView = sender.locationInView(sender.view)
                let startPoint = self.delegate!.productCellGetSuperview().convertPoint(self.productImageView.center, fromView: self)
                self.delegate?.productCellPanGestureBegan(view, pointInView: pointInView, startPoint: startPoint, sender: self)
            }
        case .Changed:
            let anchor = sender.locationInView(self.delegate!.productCellGetSuperview())
            self.delegate?.productCellImageLocationChanged(anchor, sender: self)
            self.productImageView.alpha = 0
        case .Ended, .Failed, .Cancelled:
            self.delegate?.productCellPanGestureEnded(self)
            NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: #selector(self.putImageBack), userInfo: nil, repeats: false)
        default:
            break
        }
    }
    
    func putImageBack() {
        UIView.animateWithDuration(0.3, animations: {
            self.productImageView.alpha = 1.0
        })
    }
    
    // MARK: - Interface Builder Outlets

    @IBAction func addButtonPressed(sender: UIButton) {
        let startPoint = self.delegate!.productCellGetSuperview().convertPoint(self.productImageView.center, fromView: self)
        self.delegate?.productCellAddButtonPressed(self.productImageView, startPoint: startPoint, sender: self)
    }
    
}

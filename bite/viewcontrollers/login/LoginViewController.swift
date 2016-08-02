//
//  LoginViewController.swift
//  bite
//
//  Created by Jan Doornbos on 07-07-16.
//  Copyright © 2016 Move4Mobile. All rights reserved.
//

import UIKit
import CoreMotion

class LoginViewController: UIViewController {
    
    static let storyboardIdentifier: String = "loginViewController"

    // MARK: Interface Builder Outlets
    @IBOutlet weak var redCircle: UIView!
    @IBOutlet weak var burgerImageView: UIImageView!
    @IBOutlet weak var shakeImageView: UIImageView!
    @IBOutlet weak var biteLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    // MARK: Properties
    var animator: UIDynamicAnimator!
    var motionManager: CMMotionManager!
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Interface Builder Actions
    
    @IBAction func loginButtonPressed(sender: UIButton) {
        let username = self.usernameTextField.text
        let password = self.passwordTextField.text
        if let username = username, password = password {
            DataModel.sharedInstance.login(username, password: password, result: { (status) in
                if status == .Success {
                    self.openRevealController()
                }
            })
        } else {
            // Invalid credentials
        }
    }
    
    // MARK: - Navigation
    
    func openRevealController() {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewControllerWithIdentifier(BiteRevealViewController.storyboardIdentifier)
        let delegate = (UIApplication.sharedApplication().delegate) as! AppDelegate
        delegate.switchRootViewController(vc, animated: true, completion: nil)
    }
    
    // MARK: - Easter Eggs
    
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
        if motion == .MotionShake {
            self.startMotion()
        }
    }
    
    func startMotion() {
        let views: [UIView] = [ self.burgerImageView, self.shakeImageView ]
        self.animator = UIDynamicAnimator(referenceView: self.redCircle)
        let gravity = UIGravityBehavior(items: views)
        let collision = UICollisionBehavior(items: views)
        collision.translatesReferenceBoundsIntoBoundary = true
        collision.collisionMode = .Everything
        let bumperPath = UIBezierPath(ovalInRect: self.redCircle.bounds)
        collision.addBoundaryWithIdentifier("bumper", forPath: bumperPath)
        let elasticy = UIDynamicItemBehavior(items: views)
        elasticy.elasticity = 0.5
        self.animator.addBehavior(elasticy)
        self.animator.addBehavior(gravity)
        self.animator.addBehavior(collision)
        self.motionManager = CMMotionManager()
        self.motionManager.startDeviceMotionUpdatesToQueue(NSOperationQueue.mainQueue()) { (motion, error) in
            if let motionGravity = motion {
                dispatch_async(dispatch_get_main_queue(), { 
                    gravity.gravityDirection = CGVectorMake(CGFloat(motionGravity.gravity.x), -CGFloat(motionGravity.gravity.y))
                })
            }
        }
    }

}

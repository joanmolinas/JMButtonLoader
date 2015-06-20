//
//  JMButtonLoader.swift
//  JMButtonLoader
//
//  Created by Joan Molinas on 17/6/15.
//  Copyright © 2015 Joan. All rights reserved.
//

import UIKit

protocol ButtonLoaderDelegate {
    func buttonTapped()
}

@IBDesignable
class JMButtonLoader: UIButton {

    //MARK: Constants
    internal let borderLayer = CAShapeLayer()
    
    //MARK: Variables
    internal var buttonTitle : String!
    var delegate : ButtonLoaderDelegate?
    
    //MARK: Inspectables
    @IBInspectable var lineColor : UIColor = UIColor.clearColor() {
        didSet {
            borderLayer.strokeColor = lineColor.CGColor
            setNeedsLayout()
        }
    }
    @IBInspectable var startWithBorder : Bool = false {
        didSet {
            if(self.startWithBorder) {
                borderLayer.opacity = 1
                setNeedsLayout()
            }
        }
    }
    @IBInspectable var borderWidth : CGFloat = 1 {
        didSet {
            borderLayer.lineWidth = borderWidth
            setNeedsLayout()
        }
    }
    
    internal var animating = false {
        didSet {
            updateAnimation()
        }
    }
    
    @IBInspectable var textLoading : String = "Loading..."{
        didSet {
            if(animating) {
                setTitle(textLoading, forState: UIControlState.Selected)
            }
        }
    }
    
    //MARK: Animations
    internal let strokeEndAnimation: CAAnimation = {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = 0.9
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        
        let group = CAAnimationGroup()
        group.duration = 1.2
        group.repeatCount = MAXFLOAT
        group.animations = [animation]
        
        return group
        }()
    
    internal let strokeStartAnimation: CAAnimation = {
        let animation = CABasicAnimation(keyPath: "strokeStart")
        animation.beginTime = 0.3
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = 0.9
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        
        let group = CAAnimationGroup()
        group.duration = 1.2
        group.repeatCount = MAXFLOAT
        group.animations = [animation]
        
        return group
        }()
    
    //MARK: Inits()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
  
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    

    override func layoutSubviews() {
        super.layoutSubviews()
        borderLayer.position = CGPointMake(0, 0)
        borderLayer.path = UIBezierPath(rect: bounds).CGPath
        
    }
    
    //External functions
    func setup() {
        borderLayer.lineWidth = borderWidth
        borderLayer.fillColor = nil
        borderLayer.strokeColor = lineColor.CGColor
        borderLayer.opacity = 0
        layer.addSublayer(borderLayer)
        
        buttonTitle = titleLabel?.text
        
        addTarget(self, action: "jmButtonLoader:", forControlEvents: UIControlEvents.TouchUpInside)
    }

    func updateAnimation() {
        if animating {
            borderLayer.addAnimation(strokeEndAnimation, forKey: "strokeEnd")
            borderLayer.addAnimation(strokeStartAnimation, forKey: "strokeStart")
        } else {
            borderLayer.removeAnimationForKey("strokeEnd")
            borderLayer.removeAnimationForKey("strokeStart")
        }
    }
    
    internal func jmButtonLoader(sender : UIButton) {
        if !animating {
            sender.setTitle(textLoading, forState: UIControlState.Normal)
            animating = true
            enabled = false
            delegate?.buttonTapped()
            borderLayer.opacity = 1
        }
    }
    
    func stopButton() {
        if animating {
            if(!startWithBorder) {borderLayer.opacity = 0}
            setTitle(buttonTitle, forState: UIControlState.Normal)
            animating = false
            enabled = true
            
            
        }
    }
    

}

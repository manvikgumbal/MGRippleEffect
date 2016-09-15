//
//  MGRippleEffect.swift
//  MGRippleEffect
//
//  Created by Manvik on 14/09/16.
//  Copyright © 2016 Mindspower. All rights reserved.
//

import UIKit

@objc protocol MGRippleEffectDelegate {
   optional func didClickedOnView(tag: Int)
}

@IBDesignable class MGRippleEffect: UIView {
    
    //MARK: Variables
    var animating: Bool = false
    weak var delegate: MGRippleEffectDelegate?
    
    //MARK: IBDesignables
    @IBInspectable var circles:Int = 4
    @IBInspectable var borderColor:UIColor = UIColor.blackColor()
    @IBInspectable var fillColor: UIColor = UIColor.blackColor()
    @IBInspectable var circleRadius: Double = 10.0
    @IBInspectable var innerImage: UIImage? = nil
    @IBInspectable var imageSize: CGSize = CGSizeMake(20, 20)
    @IBInspectable var imageRadius: CGFloat = 0.0
    
    
    //MARK: Draw Rect
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        //Create Cricles to show ripple effect
        layer.sublayers = []
        let offsetDelta = (Double(CGRectGetHeight(self.layer.bounds)/2) - circleRadius) / Double(circles)
        var currentOffset:CGFloat = 0
        var currentAlpha = 1.0
        for _ in 1..<circles{
            currentAlpha /= 1.5
        }
        for _ in 0..<circles {
            
            let sublayer = CAShapeLayer()
            sublayer.frame = CGRectInset(self.layer.bounds, currentOffset, currentOffset)
            let circle = UIBezierPath(ovalInRect: CGRectInset(sublayer.bounds, 1.5, 1.5))
            sublayer.path = circle.CGPath
            sublayer.strokeColor = borderColor.CGColor
            sublayer.lineWidth = 2.0
            sublayer.fillColor = fillColor.CGColor
            sublayer.opacity = Float(currentAlpha)
            layer.addSublayer(sublayer)
            currentOffset += CGFloat(offsetDelta)
            currentAlpha *= 1.5
        }
        
        //Add Image in center if needed
        if let image = innerImage {
            let imageView = UIImageView(frame: CGRectMake((self.bounds.width - imageSize.width) / 2.0, (self.bounds.height - imageSize.height) / 2.0, imageSize.width, imageSize.height))
            imageView.image = image
            imageView.layer.cornerRadius = imageRadius
            imageView.layer.masksToBounds = true
            self.addSubview(imageView)
        }
        
        
        //Add Gesture Recognizer to view
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapGEstureHandler(_:)))
        self.userInteractionEnabled = true
        self.addGestureRecognizer(tapGesture)
    }

    
    //MARK: Start Animation
    func startAnimation() {
        var largestLayerWidth = CGFloat()
        animating = true
        if layer.sublayers != nil {
            for (index,sublayer) in (layer.sublayers as [CALayer]!).enumerate() {
                if let sublayer = sublayer as? CAShapeLayer {
                    if(index==0) {
                        largestLayerWidth = sublayer.frame.width
                    }
                    //Animation to scale the view
                    let animation = CABasicAnimation(keyPath: "transform.scale")
                    animation.fromValue = NSNumber(float:1)
                    animation.toValue = NSNumber(float: 1*Float(largestLayerWidth/sublayer.frame.width))
                    animation.duration = 1.0
                    animation.repeatCount = Float(Int.max)
                    animation.autoreverses = true
                    sublayer.addAnimation(animation, forKey: "animForLayer\(index)")
                    
                    //Animation to change opacity
                    let fadeAnimation = CABasicAnimation(keyPath: "opacity")
                    fadeAnimation.fromValue = 0.0
                    fadeAnimation.toValue = 0.6
                    fadeAnimation.duration = 1
                    fadeAnimation.repeatCount = Float(Int.max)
                    fadeAnimation.autoreverses = true
                    sublayer.addAnimation(fadeAnimation, forKey: "FadeAnimationForLayer\(index)")
                }
            }
        }
    }
    
    //MARK: Stop Animation
    func stopAnimation() {
        animating = false
        if layer.sublayers != nil {
            for (_,sublayer) in (layer.sublayers as [CALayer]!).enumerate() {
                sublayer.removeAllAnimations()
            }
        }
    }
    
    //MARK: Handle ap Gesture
    func tapGEstureHandler(gesture: UITapGestureRecognizer) {
        delegate?.didClickedOnView!(self.tag)
    }
}

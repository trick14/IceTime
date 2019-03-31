//
//  UIView+.swift
//  IceTime
//
//  Created by Ryan Han on 3/30/19.
//  Copyright © 2019 Ryan Han. All rights reserved.
//

import UIKit

extension UIView {
    // frame
    open var minX: CGFloat { return frame.minX }
    open var minY: CGFloat { return frame.minY }
    open var maxX: CGFloat { return frame.maxX }
    open var maxY: CGFloat { return frame.maxY }
    open var boundsW: CGFloat { return bounds.width }
    open var boundsH: CGFloat { return bounds.height }

    open var frameW: CGFloat {
        get {
            return frame.width
        }
        set {
            self.frame = CGRect(x: frame.origin.x,
                                y: frame.origin.y,
                                width: newValue,
                                height: frame.size.height)
        }
    }
    
    open var frameH: CGFloat {
        get {
            return frame.height
        }
        set {
            self.frame = CGRect(x: frame.origin.x,
                                y: frame.origin.y,
                                width: frame.size.width,
                                height: newValue)
        }
    }
    
    open var frameY: CGFloat {
        get {
            return frame.origin.y
        }
        set {
            frame = CGRect(x: frame.origin.x,
                           y: newValue,
                           width: frame.size.width,
                           height: frame.size.height)
        }
    }
    
    open var frameX: CGFloat {
        get {
            return frame.origin.x
        }
        set {
            frame = CGRect(x: newValue,
                           y: frame.origin.y,
                           width: frame.size.width,
                           height: frame.size.height)
        }
    }
    
    open class func viewFromNib<T>() -> T where T: UIView {
        let view = Bundle.main.loadNibNamed(String(describing: self), owner: nil, options: nil)?.first! as! T
        return view
    }
    
    open func showViewBorder() {
        layer.borderColor = UIColor.red.cgColor
        layer.borderWidth = 1.0
    }
    
    open func showViewBorderWithColor(_ color: UIColor) {
        layer.borderColor = color.cgColor
        layer.borderWidth = 1.0
    }
    
    open func showSubviewsBorder() {
        for subview in subviews {
            let randomColor = UIColor(red: CGFloat(arc4random_uniform(120)) / 255.0,
                green: CGFloat(arc4random_uniform(120)) / 255.0,
                blue: CGFloat(arc4random_uniform(120)) / 255.0,
                alpha: 1)
            
            subview.layer.borderWidth = 1.0
            subview.layer.borderColor = randomColor.cgColor
        }
        
        layer.borderColor = UIColor.red.cgColor
        layer.borderWidth = 2.0
    }
    
    open func showSubviewsBorderWithIndex() {
        for subview in subviews {
            let randomColor = UIColor(red: CGFloat(arc4random_uniform(120)) / 255.0,
                                      green: CGFloat(arc4random_uniform(120)) / 255.0,
                                      blue: CGFloat(arc4random_uniform(120)) / 255.0,
                                      alpha: 1)
            
            subview.layer.borderWidth = 1.0
            subview.layer.borderColor = randomColor.cgColor
            
            let label = UILabel()
            label.textColor = randomColor
            label.font = UIFont.systemFont(ofSize: 9)
            let index = subviews.firstIndex(of: subview)!
            label.text = String(index)
            label.sizeToFit()
            subview.addSubview(label)
        }
        
        layer.borderColor = UIColor.red.cgColor
        layer.borderWidth = 2.0
    }
    
    open func isUserInteractionDisabledInViewHierarchy() -> Bool {
        var view: UIView? = self
        var index: Int = 0
        while let v = view {
            if v.isUserInteractionEnabled == false {
                print("UserInteraction is disabled in [\(index)]", v)
                return true
            }
            view = v.superview
            index += 1
        }
        
        print("all superviews are userInteraction enabled")
        return false
    }
    
    open func toImage() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(bounds.size, isOpaque, 0)
        guard let context = UIGraphicsGetCurrentContext() else {
            return UIImage()
        }
        layer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}

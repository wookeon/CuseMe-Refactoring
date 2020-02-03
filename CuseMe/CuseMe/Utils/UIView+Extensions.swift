//
//  UIView+Extensions.swift
//  CuseMe
//
//  Created by wookeon on 2020/02/03.
//  Copyright © 2020 wookeon. All rights reserved.
//

import UIKit

extension UIView {
    func cornerRadius(cornerRadii: CGFloat?) {
        if let radius = cornerRadii {
            layer.cornerRadius = radius
        } else {
            layer.cornerRadius = layer.frame.height/2
        }
    }
    
    func cornerRadius(parts: UIRectCorner, cornerRadii: CGFloat?) {
        if let radius = cornerRadii {
            let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: parts, cornerRadii: CGSize(width: radius, height: radius))
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            layer.mask = mask
        }
    }
    
    func shadows(x: Int, y: Int, color: UIColor, opacity: Float, blur: CGFloat) {
        layer.shadowColor = color.cgColor
        layer.shadowOffset = CGSize(width: x, height: y)
        layer.shadowOpacity = opacity
        layer.shadowRadius = blur/2
        layer.masksToBounds = false
    }
    
    func border(color: UIColor, width: CGFloat?) {
        layer.borderColor = color.cgColor
        
        if let width = width {
            layer.borderWidth = width
        } else {
            layer.borderWidth = 0
        }
    }
    
    func origin(x: CGFloat, y: CGFloat) {
        frame.origin.x = x
        frame.origin.y = y
    }
    
    func size(width: CGFloat, height: CGFloat) {
        frame.size.width = width
        frame.size.height = height
    }
}

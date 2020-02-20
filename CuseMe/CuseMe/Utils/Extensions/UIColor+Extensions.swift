//
//  UIColor+Extensions.swift
//  CuseMe
//
//  Created by wookeon on 2020/02/03.
//  Copyright © 2020 wookeon. All rights reserved.
//

import UIKit

extension UIColor {
    
    @nonobjc class var highlight: UIColor {
        return UIColor(red: 251/255, green: 109/255, blue: 106/255, alpha: 1.0)
    }
    
    @nonobjc class var placeholder: UIColor {
        return UIColor(red: 178/255, green: 178/255, blue: 178/255, alpha: 1.0)
    }
    
    @nonobjc class var blur: UIColor {
        return UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.8)
    }
    
    @nonobjc class var cover: UIColor {
        return UIColor(red: 242/255, green: 242/255, blue: 242/255, alpha: 1.0)
    }
    
    @nonobjc class var normal: UIColor {
        return UIColor(red: 77/255, green: 77/255, blue: 77/255, alpha: 1.0)
    }
}

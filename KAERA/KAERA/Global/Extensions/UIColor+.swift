//
//  UIColor+.swift
//  HARA
//
//  Created by 김담인 on 2022/12/27.
//

import UIKit

extension UIColor {
    
    static func hexStringToUIColor (hex:String, alpha:Double = 1.0) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            return UIColor.gray
        }

        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(alpha)
        )
    }
    
    @nonobjc class var kGray1: UIColor {
        return UIColor.hexStringToUIColor(hex:"#1E2227")
    }
    
    @nonobjc class var kGray2: UIColor {
        return UIColor.hexStringToUIColor(hex:"#30363D")
    }
    
    @nonobjc class var kGray3: UIColor {
        return UIColor.hexStringToUIColor(hex:"#444C55")
    }
    
    @nonobjc class var kGray4: UIColor {
        return UIColor.hexStringToUIColor(hex:"#9BA1AA")
    }
    
    @nonobjc class var kGray5: UIColor {
        return UIColor.hexStringToUIColor(hex:"#B6BCC6")
    }
    
    @nonobjc class var kWhite: UIColor {
        return UIColor.hexStringToUIColor(hex:"#FFFFFF")
    }
    
    @nonobjc class var kYellow1: UIColor {
        return UIColor.hexStringToUIColor(hex:"#F6CE66")
    }
    
    @nonobjc class var kYellow2: UIColor {
        return UIColor.hexStringToUIColor(hex:"#FFE5A3")
    }
    
    @nonobjc class var kRed1: UIColor {
        return UIColor.hexStringToUIColor(hex:"#FF5F5F")
    }
    
    @nonobjc class var kBlue: UIColor {
        return UIColor.hexStringToUIColor(hex:"#77A3F8")
    }
    
}

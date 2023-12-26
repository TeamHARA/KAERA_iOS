//
//  RadialGradientView.swift
//  KAERA
//
//  Created by saint on 2023/12/26.
//

import UIKit
import SnapKit

class RadialGradientView: UIView {
    var startColor = UIColor.hexStringToUIColor(hex: "#444C55", alpha: 1)
    var endColor = UIColor.hexStringToUIColor(hex: "#444C55", alpha: 0)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        clipsToBounds = true
        layer.cornerRadius = 4
    }
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.saveGState()
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let colors = [startColor.cgColor, endColor.cgColor] as CFArray
        
        let locations: [CGFloat] = [0, 1]
        
        if let gradient = CGGradient(colorsSpace: colorSpace, colors: colors, locations: locations) {
            let centerPoint = CGPoint(x: rect.minX - rect.width * 1/16, y: rect.minY + rect.height * 1/6)
            let radius = sqrt(rect.width * rect.width + rect.height * rect.height) * 1.5
            context.drawRadialGradient(gradient,
                                       startCenter: centerPoint, startRadius: 0,
                                       endCenter: centerPoint, endRadius: radius,
                                       options: CGGradientDrawingOptions())
        }
        
        context.restoreGState()
    }
}

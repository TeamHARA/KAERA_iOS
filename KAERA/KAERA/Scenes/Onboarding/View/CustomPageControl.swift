//
//  CustomPageControl.swift
//  KAERA
//
//  Created by saint on 2023/11/23.
//


import UIKit
import SnapKit

final class CustomPageControl: UIControl {
    
    private let numberOfPages: Int = 3
    
    var currentPage: Int = 0 {
        didSet {
            upadateIndicators()
        }
    }
    
    private var indicators: [UIView] = []
    
    var pageIndicatorTintColor: UIColor = .kGray3
    var currentPageIndicatorTintColor: UIColor = .kYellow1
    
    /// page가 변경될때마다 didSet함수로부터 호출
    private func upadateIndicators() {
        indicators.forEach { $0.removeFromSuperview() }
        indicators.removeAll()
    
        for i in 0..<numberOfPages {
            let view = UIView()
            /// 현재 페이지 번호와 동일 시에 색 및 스타일 변경
            view.backgroundColor = i == currentPage ? currentPageIndicatorTintColor : pageIndicatorTintColor
            view.layer.cornerRadius = i == currentPage ? 2 : frame.height / 2
            addSubview(view)
            indicators.append(view)
        }
        setNeedsLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let indicatorSize: CGSize = CGSize(width: 28, height: 8)
        let indicatorSpacing: CGFloat = 9
        let normalIndicatorSize: CGFloat = 8
        
        var xPosition: CGFloat = 0
        for (index, view) in indicators.enumerated() {
            let width = index == currentPage ? indicatorSize.width : normalIndicatorSize
            let height = index == currentPage ? indicatorSize.height : normalIndicatorSize
            view.frame = CGRect(x: xPosition, y: (frame.height - height) / 2, width: width, height: height)
            view.layer.cornerRadius = index == currentPage ? 4 : height / 2
            xPosition += width + indicatorSpacing
        }
    }
}


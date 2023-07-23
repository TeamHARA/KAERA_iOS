//
//  HomeHederView.swift
//  KAERA
//
//  Created by 김담인 on 2023/07/11.
//

import UIKit
import SnapKit
import Then

final class HomeHederView: UIView {
    
    enum HomeType {
        case digging, dug
    }
    
    private let homeLogoImgView = UIImageView().then {
        $0.image = UIImage(named: "logo")
    }
    
    private let headerBGView = UIView().then {
        $0.backgroundColor = .kGray4
        $0.makeRounded(cornerRadius: 10)
    }
    private let headerLabel = UILabel().then {
        $0.textAlignment = .center
        $0.font = .kB2R16
        $0.textColor = .kGray2
    }
    
    init(type: HomeType) {
        super.init(frame: .zero)
        if type == .digging {
            headerLabel.text = "열심히 캐내는 중 ⛏️"
        } else {
            headerLabel.text = "그동안 캐낸 보석들 ✨"
        }
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI
extension HomeHederView {
    private func setLayout() {
        self.addSubViews([homeLogoImgView, headerBGView, headerLabel])
        
        homeLogoImgView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.height.equalTo(38)
            $0.width.equalTo(136)
        }
        
        headerBGView.snp.makeConstraints {
            $0.top.equalTo(homeLogoImgView.snp.bottom).offset(12)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(26)
            $0.width.equalToSuperview()
        }
        
        headerBGView.addSubview(headerLabel)
        
        headerLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
    }
}

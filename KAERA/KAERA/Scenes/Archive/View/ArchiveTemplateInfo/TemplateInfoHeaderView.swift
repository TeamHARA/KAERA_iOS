//
//  TemplateInfoHeaderView.swift
//  KAERA
//
//  Created by saint on 2023/07/14.
//

import UIKit
import SnapKit
import Then

// MARK: - TableHeaderView
class TemplateInfoHeaderView: UIView {
    
    // MARK: - Properties
    private let bgImage = UIImageView().then {
        $0.image = UIImage(named: "frame_header")
        $0.backgroundColor = .clear
    }
    
    private let jewelImage = UIImageView().then {
        $0.image = UIImage(named: "gems")
        $0.backgroundColor = .clear
    }
    
    private let instaLabel = UILabel().then {
        $0.text = "캐라 인스타그램에서 다양한 고민 원석을 살펴보세요!"
        $0.font = .kB3B14
        $0.textColor = .white
    }
    
    private let instaBtn = UIButton().then {
        $0.backgroundColor = .kYellow1
        $0.titleLabel?.font = .kB2R16
        $0.setTitle("공유하기", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.layer.cornerRadius = 8
    }
    
    // MARK: - View Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setPressAction()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setPressAction() {
        instaBtn.press {
            let kaeraUserName = "kaera.app"
            let appURL = URL(string: "instagram://user?username=\(kaeraUserName)")!
            let webURL = URL(string: "https://www.instagram.com/\(kaeraUserName)/")!
            if UIApplication.shared.canOpenURL(appURL) {
                  UIApplication.shared.open(appURL, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.open(webURL)
            }
        }
    }
}

// MARK: - Layout
extension TemplateInfoHeaderView {
    private func setLayout() {
        self.addSubviews([bgImage, jewelImage, instaLabel, instaBtn])
        
        bgImage.snp.makeConstraints {
            $0.width.equalTo(342.adjustedW)
            $0.height.equalTo(168.adjustedW)
            $0.edges.equalToSuperview()
        }
        
        jewelImage.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.width.equalTo(146.adjustedW)
            $0.height.equalTo(94.adjustedW)
        }
        
        instaLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(90.adjustedW)
            $0.centerX.equalToSuperview()
        }
        
        instaBtn.snp.makeConstraints {
            $0.top.equalTo(instaLabel.snp.bottom).offset(13.adjustedW)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(78.adjustedW)
            $0.height.equalTo(30.adjustedW)
        }
    }
}

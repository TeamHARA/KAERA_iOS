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
    private let instaBtn = UIButton().then {
        $0.setBackgroundImage(UIImage(named: "insta_back"), for: .normal)
        $0.layer.cornerRadius = 16
        $0.backgroundColor = .clear
    }
    
    private let instaLabel = UILabel().then {
        $0.text = "캐라 인스타그램에서 다른\n고민 여정을 살펴보세요!"
        $0.numberOfLines = 2
        $0.textColor = .white
        $0.font = .kB5R14W
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
        self.addSubviews([instaBtn, instaLabel])

        instaBtn.snp.makeConstraints {
            $0.width.equalTo(342.adjustedW)
            $0.height.equalTo(113.adjustedW)
            $0.edges.equalToSuperview()
        }
        
        instaLabel.snp.makeConstraints {
            $0.leading.equalTo(instaBtn.snp.leading).offset(36.adjustedW)
            $0.bottom.equalTo(instaBtn.snp.bottom).offset(-30.adjustedH)
        }
    }
}

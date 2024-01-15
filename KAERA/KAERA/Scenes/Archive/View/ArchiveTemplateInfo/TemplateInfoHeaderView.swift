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
        self.addSubviews([instaBtn])

        instaBtn.snp.makeConstraints {
            $0.width.equalTo(342.adjustedW)
            $0.height.equalTo(113.adjustedW)
            $0.edges.equalToSuperview()
        }
    }
}

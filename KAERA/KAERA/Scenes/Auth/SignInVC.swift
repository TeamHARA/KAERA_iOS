//
//  SignInVC.swift
//  KAERA
//
//  Created by 김담인 on 2023/09/03.
//

import UIKit
import SnapKit
import Then

final class SignInVC: UIViewController {
        
    private let signInGemsImage = UIImageView().then {
        $0.image = UIImage(named: "signInGems")
    }
    
    private let kaeraLogoImage = UIImageView().then {
        $0.image = UIImage(named: "logo")
    }
    
    private let titleLabel = UILabel().then {
        $0.text = "나의 고민을 빛나는 보석으로"
        $0.font = UIFont.kB4R14
        $0.textColor = .kWhite
    }
    
    private let kakaoLoginButton = UIButton().then {
        $0.setImage(UIImage(named:"kakaoLoginButton"), for: .normal)
    }
    
    private let appleLoginButton = UIButton().then {
        $0.setImage(UIImage(named:"appleLoginButton"), for: .normal)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
}

// MARK: - UI
extension SignInVC {
    private func setUI() {
        view.backgroundColor = .kGray1
        
        view.addSubviews([signInGemsImage, kaeraLogoImage, titleLabel, appleLoginButton, kakaoLoginButton])
        
        signInGemsImage.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(168.adjustedH)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(74.adjustedH)
        }
        
        kaeraLogoImage.snp.makeConstraints {
            $0.top.equalTo(signInGemsImage.snp.bottom).offset(9)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(38.adjustedH)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(kaeraLogoImage.snp.bottom).offset(15)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(17)
        }
        
        appleLoginButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(64)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(50.adjustedH)
        }
        
        kakaoLoginButton.snp.makeConstraints {
            $0.bottom.equalTo(appleLoginButton.snp.top).offset(-22)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(50.adjustedH)
        }
    }
}

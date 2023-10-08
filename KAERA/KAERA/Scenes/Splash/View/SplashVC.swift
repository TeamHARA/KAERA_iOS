//
//  SplashVC.swift
//  KAERA
//
//  Created by 김담인 on 2023/10/08.
//

import UIKit
import SnapKit
import Then
import UserNotifications

final class SplashVC: BaseVC {
    
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

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        //TODO: 스플래시 애니메이션 적용
        self.view.backgroundColor = .kGray2
        UIView.animate(withDuration: 1.2) { [weak self] in
            self?.view.backgroundColor = .kGray1
            
        } completion: { [weak self] _ in
            self?.renewRefreshToken()
        }
    }
    
    
    private func shouldSignIn(renewal: Bool) {
        if renewal {
            let signInVC = SignInVC()
            signInVC.modalPresentationStyle = .fullScreen
            signInVC.modalTransitionStyle = .crossDissolve
            self.present(signInVC, animated: true)
        } else {
            let tabBarController = KaeraTabbarController()
            tabBarController.modalPresentationStyle = .fullScreen
            tabBarController.modalTransitionStyle = .crossDissolve
            self.present(tabBarController, animated: true)
        }
    }
    
}

// MARK: - Network
extension SplashVC {
    private func renewRefreshToken() {
        AuthAPI.shared.postRenewalRequest { [weak self] res in
            guard let res, let data = res.data else {
                /// 토큰 갱신 실패 -> 기존 토큰 삭제
                KeychainManager.delete(key: .accessToken)
                KeychainManager.delete(key: .refreshToken)
                self?.shouldSignIn(renewal: true)
                return
            }
            let renewedAccessToken = data.accessToken
            KeychainManager.save(key: .accessToken, value: renewedAccessToken)
            self?.shouldSignIn(renewal: false)
        }
        
    }
}

// MARK: - UI
extension SplashVC {
    private func setUI() {
        view.addSubviews([signInGemsImage, kaeraLogoImage, titleLabel])
        
        signInGemsImage.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(268.adjustedH)
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
    }
}

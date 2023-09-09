//
//  SignInVC.swift
//  KAERA
//
//  Created by 김담인 on 2023/09/03.
//

import UIKit
import SnapKit
import Then
import KakaoSDKUser
import AuthenticationServices

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
        setLoginButtonAction()
        setUI()
    }
    
    // MARK: - Function
    private func setLoginButtonAction() {
        kakaoLoginButton.press {
            /// 카카오톡 실행 가능한지 확인
            if UserApi.isKakaoTalkLoginAvailable() {
                /// 카카오톡 로그인 실행
                UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                    if error != nil {
                    } else {
                        print("loginWithKakaoTalk() success.")
                        //TODO: 서버에 oauthToken 전달
                        let tabBarController = KaeraTabbarController()
                        tabBarController.modalPresentationStyle = .fullScreen
                        tabBarController.modalTransitionStyle = .crossDissolve
                        self.present(tabBarController, animated: true)
                    }
                }
            } else {
                // TODO: 카카오톡 미설치 알림창 띄우기
            }
        }
        
        appleLoginButton.press {
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            let request = appleIDProvider.createRequest()
            request.requestedScopes = [.fullName, .email]
            
            let authorizationController = ASAuthorizationController(authorizationRequests: [request])
            authorizationController.delegate = self
            authorizationController.presentationContextProvider = self
            authorizationController.performRequests()
        }
    }
}

// MARK: - ASAuthorizationControllerDelegate
extension SignInVC: ASAuthorizationControllerDelegate {
    
    /// 사용자 인증 성공 시 인증 정보를 반환 받습니다.
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
            
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            if let identityToken = appleIDCredential.identityToken,
               let tokenString = String(data: identityToken, encoding: .utf8) {
               //TODO: 서버에 tokenString 전달
            }
            let tabBarController = KaeraTabbarController()
            tabBarController.modalPresentationStyle = .fullScreen
            tabBarController.modalTransitionStyle = .crossDissolve
            self.present(tabBarController, animated: true)
        default:
            break
        }
    }
    
    /// 사용자 인증 실패 시 에러 처리를 합니다.
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Apple 로그인 사용자 인증 실패")
        print("error \(error)")
    }
}

// MARK: - ASAuthorizationControllerPresentationContextProviding
extension SignInVC: ASAuthorizationControllerPresentationContextProviding {
    
    /// 애플 로그인 UI를 어디에 띄울지 가장 적합한 뷰 앵커를 반환합니다.
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
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

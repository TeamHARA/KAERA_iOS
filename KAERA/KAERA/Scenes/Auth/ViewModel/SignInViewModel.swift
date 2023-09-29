//
//  SignInViewModel.swift
//  KAERA
//
//  Created by 김담인 on 2023/09/24.
//

import Foundation
import Combine
import KakaoSDKUser
import AuthenticationServices

final class SignInViewModel: NSObject, ViewModelType {
    
    typealias Input = AnyPublisher<LoginType, Never>

    typealias Output = AnyPublisher<Bool, Never>
    
    private let output: PassthroughSubject<Bool, Never> = .init()
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    override init() {
        super.init()
    }
    
    // MARK: - Function
    func transform(input: AnyPublisher<LoginType, Never>) -> AnyPublisher<Bool, Never> {
        input
            .sink { [weak self] loginType in
                switch loginType {
                case .kakao:
                    self?.checkKakaoLogin()
                case .apple:
                    self?.checkAppleLogin()
                }
            }
            .store(in: &cancellables)
        return output.eraseToAnyPublisher()
    }
    
    private func checkKakaoLogin() {
        /// 카카오톡 실행 가능한지 확인
        if UserApi.isKakaoTalkLoginAvailable() {
            /// 카카오톡 로그인 실행
            UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                if error != nil {
                } else {
                    print("loginWithKakaoTalk() success.")
                    self.postKakaoLogin(token: oauthToken?.accessToken ?? "")
                }
            }
            
        } else {
            output.send(false)
        }
    }
    
    private func checkAppleLogin() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        ///  presentaionContext 미 지정시 최상단 UIWindow로 알아서 배치됨
//        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
}

// MARK: - Network
extension SignInViewModel {
    private func postKakaoLogin(token: String) {
        AuthAPI.shared.postKakaoLogin(token: token) { res in
            guard let res, let data = res.data else {
                self.output.send(false)
                return
            }
            
            /// user info 저장
            KeychainManager.saveUserInfo(id: "\(data.id)", userName: data.name, accessToken: data.accessToken, refreshToken: data.refreshToken)
            
            self.output.send(true)
        }
    }
    
    private func postAppleLogin(token: String) {
        print(token)
    }
}


extension SignInViewModel: ASAuthorizationControllerDelegate {
    
    /// 사용자 인증 성공 시 인증 정보를 반환 받습니다.
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
            
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            if let email = appleIDCredential.email {
                print("이메일", email)
            }
            if let fullName = appleIDCredential.fullName {
                print("풀네임", fullName)
            }
            if let identityToken = appleIDCredential.identityToken,
               let tokenString = String(data: identityToken, encoding: .utf8) {
                postAppleLogin(token: tokenString)
            }
           
        default:
            break
        }
    }
        
    /// 사용자 인증 실패 시 에러 처리를 합니다.
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Apple 로그인 사용자 인증 실패")
        print("error \(error)")
        output.send(false)
    }
}

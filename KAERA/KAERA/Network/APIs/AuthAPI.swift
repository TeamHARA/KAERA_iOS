//
//  AuthAPI.swift
//  KAERA
//
//  Created by 김담인 on 2023/09/24.
//

import Foundation
import Moya

final class AuthAPI {
    
    static let shared: AuthAPI = AuthAPI()
    private let authProvider = MoyaProvider<AuthService>(plugins: [MoyaLoggingPlugin()])
    
    private init() { }
    
    public private(set) var kakaoLoginResponse: GeneralResponse<SignInModel>?
    public private(set) var renewalResponse: GeneralResponse<RenewalTokenModel>?
    public private(set) var kakaoLogoutResponse: EmptyResponse?
    public private(set) var appleSignInResponse: GeneralResponse<SignInModel>?
    
    
    func postKakaoLogin(token: String, completion: @escaping (GeneralResponse<SignInModel>?) -> ()) {
        authProvider.request(.kakaoLogin(token: token)) { [weak self] response in
            switch response {
            case .success(let result):
                do {
                    self?.kakaoLoginResponse = try result.map(GeneralResponse<SignInModel>?.self)
                    guard let res = self?.kakaoLoginResponse else { return }
                    completion(res)
                } catch(let err) {
                    print(err.localizedDescription)
                    completion(nil)
                }
            case .failure(let err):
                print(err.localizedDescription)
                completion(nil)
            }
        }
    }
    
    func postRenewalRequest(completion: @escaping (GeneralResponse<RenewalTokenModel>?) -> ()) {
        authProvider.request(.renewelToken) { [weak self] response in
            switch response {
            case .success(let result):
                do {
                    self?.renewalResponse = try result.map(GeneralResponse<RenewalTokenModel>?.self)
                    guard let res = self?.renewalResponse else { return }
                    switch res.status {
                    case 200:
                        completion(res)
                    default:
                        completion(nil)
                    }
                } catch(let err) {
                    print(err.localizedDescription)
                    completion(nil)
                }
            case .failure(let err):
                print(err.localizedDescription)
                completion(nil)
            }
        }
    }
    
    func postKakaoLogout(completion: @escaping (Int?) -> ()) {
        authProvider.request(.kakaoLogout) { [weak self] response in
            switch response {
            case .success(let result):
                do {
                    self?.kakaoLogoutResponse = try result.map(EmptyResponse?.self)
                    guard let res = self?.kakaoLogoutResponse else { return }
                    switch res.status {
                    case 200..<300:
                        completion(res.status)
                    default:
                        completion(nil)
                    }
                } catch(let err) {
                    print(err.localizedDescription)
                    completion(nil)
                }
            case .failure(let err):
                print(err.localizedDescription)
                completion(nil)
            }
        }
    }
    
    func postAppleSignIn(body: AppleSignInRequestBody, completion: @escaping (GeneralResponse<SignInModel>?) -> ()) {
        authProvider.request(.appleLogin(body: body)) { [weak self] response in
            switch response {
            case .success(let result):
                do {
                    self?.appleSignInResponse = try result.map(GeneralResponse<SignInModel>?.self)
                    guard let res = self?.appleSignInResponse else { return }
                    completion(res)
                } catch(let err) {
                    print(err.localizedDescription)
                    completion(nil)
                }
            case .failure(let err):
                print(err.localizedDescription)
                completion(nil)
            }
        }
    }
}

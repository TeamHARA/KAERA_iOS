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
    
    func postKakaoLogin(token: String, completion: @escaping (GeneralResponse<SignInModel>?) -> ()) {
        authProvider.request(.kakaoLogin(token: token)) { [weak self] response in
            switch response {
            case .success(let result):
                do {
                    self?.kakaoLoginResponse = try result.map(GeneralResponse<SignInModel>?.self)
                    guard let data = self?.kakaoLoginResponse else { return }
                    completion(data)
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
                    guard let data = self?.renewalResponse else { return }
                    switch data.status {
                    case 200:
                        completion(data)
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
}

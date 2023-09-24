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
    
    public private(set) var kakaoLoginResponse: GeneralResponse<SigninModel>?
    
    func postKakaoLogin(token: String, completion: @escaping (GeneralResponse<SigninModel>?) -> ()) {
        authProvider.request(.kakaoLogin(token: token)) { [weak self] response in
            switch response {
            case .success(let result):
                do {
                    self?.kakaoLoginResponse = try result.map(GeneralResponse<SigninModel>?.self)
                    guard let data = self?.kakaoLoginResponse else { return }
                    completion(data)
                } catch(let err) {
                    print(err.localizedDescription)
                    completion(nil)
                }
            case .failure(let err):
                print("에러!")
                print(err.localizedDescription)
                completion(nil)
            }
        }
    }
}

//
//  AuthService.swift
//  KAERA
//
//  Created by 김담인 on 2023/09/24.
//

import Foundation
import Moya

enum AuthService {
    case kakaoLogin(token: String)
    case renewelToken
}

extension AuthService: BaseTargetType {
    
    struct SignInRequestBody: Codable {
        let accessToken: String
    }
    
    struct RenewalRequestBody: Codable {
        let accessToken: String
        let refreshToken: String
    }
    
    var path: String {
        switch self {
        case .kakaoLogin:
            return APIConstant.kakaoLogin
        case .renewelToken:
            return APIConstant.refresh
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .kakaoLogin, .renewelToken:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .kakaoLogin(let token):
            let requsetBody = SignInRequestBody(accessToken: token)
            return .requestJSONEncodable(requsetBody)
            
        case .renewelToken:
            let accessToken = KeychainManager.load(key: .accessToken) ?? ""
            let refreshToken = KeychainManager.load(key: .refreshToken) ?? ""
            let requestBody = RenewalRequestBody(accessToken: accessToken, refreshToken: refreshToken)
            return .requestJSONEncodable(requestBody)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .kakaoLogin, .renewelToken:
            return NetworkConstant.noTokenHeader
        }
    }
}

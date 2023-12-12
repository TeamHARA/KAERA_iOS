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
    case serviceLogout
    case renewelToken
    case appleLogin(body: AppleSignInRequestBody)
    case deleteAccount
}

extension AuthService: BaseTargetType {

    var path: String {
        switch self {
        case .kakaoLogin:
            return APIConstant.kakaoLogin
        case .renewelToken:
            return APIConstant.refresh
        case .serviceLogout:
            return APIConstant.logout
        case .appleLogin:
            return APIConstant.appleLogin
        case .deleteAccount:
            return APIConstant.deleteAccount
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .kakaoLogin, .renewelToken, .serviceLogout, .appleLogin:
            return .post
        case .deleteAccount:
            return .delete
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .kakaoLogin(let token):
            let fcmToken = KeychainManager.load(key: .fcmToken) ?? ""
            let requsetBody = KakaoSignInRequestBody(accessToken: token, deviceToken: fcmToken)
            return .requestJSONEncodable(requsetBody)
            
        case .renewelToken:
            let accessToken = KeychainManager.load(key: .accessToken) ?? ""
            let refreshToken = KeychainManager.load(key: .refreshToken) ?? ""
            let requestBody = RenewalRequestBody(accessToken: accessToken, refreshToken: refreshToken)
            return .requestJSONEncodable(requestBody)
            
        case .serviceLogout:
            return .requestPlain
        
		case .appleLogin(let body):
            return .requestJSONEncodable(body)
            
        case .deleteAccount:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .kakaoLogin, .renewelToken, .appleLogin:
            return NetworkConstant.noTokenHeader
        case .serviceLogout, .deleteAccount:
            return NetworkConstant.hasTokenHeader
        }
    }
    
    var validationType: ValidationType {
         return .successCodes
     }
}

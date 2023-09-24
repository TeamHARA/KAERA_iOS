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
}

extension AuthService: BaseTargetType {
    
    struct RequestBody: Codable {
        let accessToken: String
    }
    
    var path: String {
        switch self {
        case .kakaoLogin:
            return APIConstant.kakaoLogin
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .kakaoLogin:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .kakaoLogin(let token):
            
            let requsetBody = RequestBody(accessToken: token)
            return .requestJSONEncodable(requsetBody)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .kakaoLogin:
            return NetworkConstant.hasTokenHeader
        }
    }
}

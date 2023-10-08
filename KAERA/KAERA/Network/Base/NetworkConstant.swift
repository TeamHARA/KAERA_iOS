//
//  NetworkConstant.swift
//  HARA
//
//  Created by 김담인 on 2023/01/04.
//

import Foundation

struct NetworkConstant {
    
    static let noTokenHeader = ["Content-Type": "application/json"]
    
    static let hasTokenHeader = ["Content-Type": "application/json",
                                 "Authorization": NetworkConstant.bearerToken]
    
    /// 임시로 현재 고정  bearerToken 직접 사용
    static let bearerToken = {
        guard let token = Bundle.main.object(forInfoDictionaryKey: "BEARER_TOKEN") as? String else {
            fatalError("Base URL not set in plist for this environment")
        }
        return token
    }()
    
    static let accessToken = {
        guard let accessToken = KeychainManager.load(key: .accessToken) else {  fatalError("AccessToken Not in the Keychain")
        }
        return accessToken
    }()
    
}

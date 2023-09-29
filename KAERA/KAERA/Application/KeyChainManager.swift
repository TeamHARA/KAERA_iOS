//
//  KeychainManager.swift
//  KAERA
//
//  Created by 김담인 on 2023/09/24.
//

import Foundation

enum UserInfoKey: String {
    case userId
    case userName
    case acessToken
    case refreshToken
}

struct UserInfoModel {
    let userId: String?
    let userName: String?
    let accessToken: String?
    let refreshToken: String?
}

final class KeychainManager {
    
    // Keychain에 값 저장하기
    class func save(key: UserInfoKey, value: String) {
        
        guard let data = value.data(using: .utf8) else { return }
        
        let query = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key.rawValue,
        ] as [String : Any]
        
        SecItemDelete(query as CFDictionary)
        
        let addQuery = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key.rawValue,
            kSecValueData as String: data
        ] as [String : Any]
        
        
        let status = SecItemAdd(addQuery as CFDictionary, nil)
        
        if status == errSecSuccess {
            print("add \(key.rawValue) success")
        } else if status == errSecDuplicateItem {
            print("keychain already has \(key.rawValue)")
        } else {
            print("add \(key.rawValue) failed")
        }
    }
    
    // Keychain에서 값 가져오기
    class func load(key: UserInfoKey) -> Data? {
        let query = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key.rawValue,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ] as [String : Any]
        
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        if status == errSecSuccess {
            return dataTypeRef as? Data
        } else {
            return nil
        }
    }
    
    // Keychain에서 값 삭제하기
    class func delete(key: UserInfoKey) {
        let query = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key.rawValue,
        ] as [String : Any]
        
        let status = SecItemDelete(query as CFDictionary)
        if status == errSecSuccess {
            // 아이템 삭제에 성공하면 동기화 작업을 수행
            let syncStatus = SecItemUpdate(query as CFDictionary, [:] as CFDictionary)
            
            if syncStatus == errSecSuccess {
                print("아이템이 완전히 삭제되었습니다.")
            } else {
                print("동기화에 실패하였습니다.")
            }
            print("delete \(key.rawValue) success")
        } else {
            print("delete \(key.rawValue) failed")
        }
    }
    
    // 사용자 정보 및 토큰 저장
    static func saveUserInfo(id: String, userName: String, accessToken: String, refreshToken: String) {
        KeychainManager.save(key: .userId, value: id)
        KeychainManager.save(key: .userName, value: userName)
        KeychainManager.save(key: .acessToken, value: accessToken)
        KeychainManager.save(key: .refreshToken, value: refreshToken)
    }
    
    // 사용자 정보 및 토큰 로드
    static func loadUserInfo() -> UserInfoModel {
        let userIdData = KeychainManager.load(key: .userId)
        let userNameData = KeychainManager.load(key: .userName)
        let accessTokenData = KeychainManager.load(key: .acessToken)
        let refreshTokenData = KeychainManager.load(key: .refreshToken)
        
        let userId = String(data: userIdData ?? Data(), encoding: .utf8)
        let userName = String(data: userNameData ?? Data(), encoding: .utf8)
        let accessToken = String(data: accessTokenData ?? Data(), encoding: .utf8)
        let refreshToken = String(data: refreshTokenData ?? Data(), encoding: .utf8)
        
        return UserInfoModel(userId: userId, userName: userName, accessToken: accessToken, refreshToken: refreshToken)
    }
    
    static func clearAllUserInfo() {
        KeychainManager.delete(key: .userId)
        KeychainManager.delete(key: .userName)
        KeychainManager.delete(key: .acessToken)
        KeychainManager.delete(key: .refreshToken)
    }
    
}

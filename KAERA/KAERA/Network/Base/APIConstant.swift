//
//  APIConstant.swift
//  HARA
//
//  Created by 김담인 on 2023/01/04.
//


import Foundation

struct APIConstant {
    
    //MARK: - Base
    static let baseURL = {
        guard let url = Bundle.main.object(forInfoDictionaryKey: "BASE_URL") as? String else {
            fatalError("Base URL not set in plist for this environment")
        }
        return url
    }()
    
    static let worryList = "/worry/list"
    static let worry = "/worry"
    static let deadline = "/worrry/deadline"
    static let myAnswer = "/worry/myanswer"
    static let template = "/template"
    static let review = "/review"
    static let kakaoLogin = "/auth/kakao/login"
    static let refresh = "/auth/token/refresh"
    static let kakaoLogout = "/auth/kakao/logout"
}

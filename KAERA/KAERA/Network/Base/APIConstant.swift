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
    
    static let homeWorryList = "/worry/list"
    static let archiveWorryList = "/worry"
}

//
//  Environment.swift
//  KAERA
//
//  Created by 김담인 on 2023/09/09.
//

import Foundation

struct Environment {
    static let kakaoAppKey = {
        guard let appKey = Bundle.main.object(forInfoDictionaryKey: "KAKAO_APP_KEY") as? String else {
            fatalError("KAKAO APP KEY not set in plist for this Environment")
        }
        return appKey
    }()
}

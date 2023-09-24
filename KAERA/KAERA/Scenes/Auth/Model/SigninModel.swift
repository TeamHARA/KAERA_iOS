//
//  SigninModel.swift
//  KAERA
//
//  Created by 김담인 on 2023/09/24.
//

import Foundation

struct SigninModel: Codable {
    let id: Int
    let name: String
    let accessToken: String
    let refreshToken: String
}

enum LoginType {
    case kakao, apple
}

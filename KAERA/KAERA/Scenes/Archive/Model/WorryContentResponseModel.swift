//
//  WriteResponseModel.swift
//  KAERA
//
//  Created by 김담인 on 2023/12/21.
//

import Foundation

struct WorryContentResponseModel: Codable {
    let worryId: Int
    let title: String
    let templateId: Int
    let answers: [String]
    let createdAt: String
    let deadline: String
    let dDay: Int
}

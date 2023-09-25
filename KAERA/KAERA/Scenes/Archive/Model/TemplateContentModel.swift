//
//  WritingWorryModel.swift
//  KAERA
//
//  Created by saint on 2023/08/12.
//

import Foundation

/// 서버통신용 모델
struct TemplateContentModel: Codable {
    let title: String
    let guideline: String
    let questions: [String]
    let hints: [String]
}

/// 서버 post용 모델
struct WorryContentRequestDto: Codable {
    var templateId: Int
    var title: String
    var answers: [String]
    var deadline: Int
}

struct WorryContentResponseDto: Codable {
    let createdAt: String
    let deadline: String
}

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

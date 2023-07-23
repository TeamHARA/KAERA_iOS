//
//  WorryDetailModel.swift
//  KAERA
//
//  Created by 김담인 on 2023/07/23.
//

import Foundation

// MARK: - WorryDetailModel
struct WorryDetailModel: Codable {
    let title: String
    let templateId, deadline: Int
    let questions, answers: [String]
    let period, updatedAt, finalAnswer: String
    let review: Review
}

// MARK: - Review
struct Review: Codable {
    let content, updatedAt: String
}

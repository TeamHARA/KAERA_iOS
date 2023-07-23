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
    let templateId: Int
    let questions, answers: [String]
    let createdAt, period, updatedAt, deadline, finalAnswer: String
    let review: Review
}

// MARK: - Review
struct Review: Codable {
    let content, createdAt, updatedAt: String
}

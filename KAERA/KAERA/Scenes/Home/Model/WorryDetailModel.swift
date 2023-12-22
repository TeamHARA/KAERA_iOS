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
    let subtitles, answers: [String]
    let period, updatedAt, deadline: String
    let dDay: Int
    let finalAnswer: String?
    let review: Review
}

// MARK: - Review
struct Review: Codable {
    let content: String?
    let updatedAt: String?
}

struct PatchDeadlineModel: Codable {
    var worryId: Int
    var dayCount: Int
}

struct PatchWorryModel: Codable {
    var worryId: Int
    var templateId: Int
    var title: String
    var answers: [String]
}

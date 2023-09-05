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
    let review: Review?
    
    enum CodingKeys : String, CodingKey {
        case dDay = "d-day"
        case title, templateId, subtitles, answers, period, updatedAt, deadline, finalAnswer, review
    }
}



// MARK: - Review
struct Review: Codable {
    let content, updatedAt: String
}

//
//  WorryReviewMdoel.swift
//  KAERA
//
//  Created by 김담인 on 2023/11/06.
//

import Foundation

struct WorryReviewRequestBody: Codable {
    let worryId: Int
    let review: String
}

struct WorryReviewResponseModel: Codable {
    let updatedAt: String
}

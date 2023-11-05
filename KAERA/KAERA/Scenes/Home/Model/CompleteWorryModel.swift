//
//  WorryCompleteModel.swift
//  KAERA
//
//  Created by saint on 2023/10/31.
//

import Foundation

struct CompleteWorryModel: Codable {
    var worryId: Int
    var finalAnswer: String
}

struct QuoteModel: Codable {
    let quote: String
}

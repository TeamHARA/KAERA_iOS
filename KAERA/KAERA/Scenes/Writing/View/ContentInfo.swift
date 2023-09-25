//
//  ContentInfo.swift
//  KAERA
//
//  Created by saint on 2023/09/24.
//

import Foundation

class ContentInfo {
    static let shared = ContentInfo()

    var templateId: Int?
    var title: String?
    var answers: [String]?
    var deadline: Int?

    private init() { }
}

//
//  ContentInfo.swift
//  KAERA
//
//  Created by saint on 2023/09/24.
//

import Foundation

class ContentInfo {
    static let shared = ContentInfo()

    var templateId: Int = 1
    var title: String = ""
    var answers: [String] = []
    var deadline: Int = -1

    private init() { }
}

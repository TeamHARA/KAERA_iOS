//
//  WorryListModel.swift
//  KAERA
//
//  Created by 김담인 on 2023/07/13.
//

import UIKit

// 서버통신용 model(codable)
struct WorryListModel: Codable {
    let totalNum: Int
    let worry: [Worry]
}

// MARK: - Worry
struct Worry: Codable {
    let worryId: Int
    let title: String
    let period: String
    let templateId: Int
}

// View에 뿌려주기 위한 model
struct WorryListPublisherModel {
    let worryId: Int
    let templateId: Int
    let title: String
    let period: String
    let image: UIImage
}

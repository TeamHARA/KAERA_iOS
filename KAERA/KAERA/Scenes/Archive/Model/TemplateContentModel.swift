//
//  WritingWorryModel.swift
//  KAERA
//
//  Created by saint on 2023/08/12.
//

import Foundation

/// 서버통신용 모델
struct TemplateContentModel {
    let title: String
    let guideline: String
    let questions: [String]
    let hints: [String]
}

/// View에 뿌려주기 위한 model
//struct TemplateContentPublisherModel {
//    let templateId: Int
//    let templateTitle: String
//    let templateDetail: String
//    let image: UIImage
//}

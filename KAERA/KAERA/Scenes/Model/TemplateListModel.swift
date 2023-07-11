//
//  TemplateListModel.swift
//  KAERA
//
//  Created by saint on 2023/07/11.
//

import UIKit
import Foundation

/// 서버통신용 모델
struct TemplateListModel{
    let templateId: Int
    let templateTitle: String
    let templateDetail: String
    let hasUsed: Bool
}

/// View에 뿌려주기 위한 model
struct TemplateListPublisherModel{
    let templateId: Int
    let templateTitle: String
    let templateDetail: String
    let image: UIImage
}

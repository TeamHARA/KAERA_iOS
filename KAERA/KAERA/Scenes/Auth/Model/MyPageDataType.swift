//
//  MyPageDataType.swift
//  KAERA
//
//  Created by 김담인 on 2023/10/22.
//

import Foundation

enum MyPageInputType {
    case loadData
    case action(indexPath: IndexPath)
}

enum MyPageOutputType {
    case data(data: [MyPageTVCModel])
    case push(hasChanged: Bool)
    case notice
    case account
}

enum MyPageButtonType {
    case push
    case next
    case none
}

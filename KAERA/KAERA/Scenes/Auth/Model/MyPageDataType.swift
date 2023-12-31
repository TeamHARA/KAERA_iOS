//
//  MyPageDataType.swift
//  KAERA
//
//  Created by 김담인 on 2023/10/22.
//

import Foundation

enum MyPageInputType {
    case loadData
    case push
    case accountAction(type: AccountActionType)
}

enum MyPageOutputType {
    case data(data: [MyPageTVCModel])
    case push(hasChanged: Bool)
    case accountAction(type: AccountActionType)
    case networkFail
}

enum MyPageButtonType {
    case push
    case next(myPageURLs: [URL])
    case account(data: [MyPageAccountAlertInfoModel])
}

enum AccountActionType {
    case signOut, delete
}

struct MyPageAccountAlertInfoModel {
    let okTitle: String
    let title: String
    let subTitle: String
    let type: AccountActionType
}

struct MyPageURLModel {
    let manual: String
    let instagram: String
    let privacy: String
    let openSource: String
}

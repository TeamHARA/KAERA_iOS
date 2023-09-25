//
//  WriteServices.swift
//  KAERA
//
//  Created by saint on 2023/08/27.
//

import Foundation
import UIKit

import Moya

enum WriteService {
    case getTemplateList
    case getTemplateQuestion(templateId: Int)
    case postWorryContent(param: WorryContentRequestDto)
}

extension WriteService: BaseTargetType {
    
    var path: String {
        switch self {
        case .getTemplateList:
            return APIConstant.template
        case .getTemplateQuestion(let templateId):
            return APIConstant.template + "/\(templateId)"
        case .postWorryContent:
            return APIConstant.worry
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getTemplateList, .getTemplateQuestion:
            return .get
        case .postWorryContent:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .getTemplateList, .getTemplateQuestion:
            return .requestPlain
        case .postWorryContent(param: let param):
            return .requestJSONEncodable(param)
        }
    }

    var headers: [String : String]? {
        switch self {
        case .getTemplateList:
            return NetworkConstant.hasTokenHeader
        case .getTemplateQuestion:
            return NetworkConstant.hasTokenHeader
        case .postWorryContent:
            return NetworkConstant.hasTokenHeader
        }
    }
}


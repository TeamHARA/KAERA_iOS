//
//  WriteServices.swift
//  KAERA
//
//  Created by saint on 2023/08/27.
//

import Foundation
import Moya

enum WriteService {
    case getTemplateList
    case getTemplateQuestion(templateId: Int)
}

extension WriteService: BaseTargetType {
    
    var path: String {
        switch self {
        case .getTemplateList:
            return APIConstant.template
        case .getTemplateQuestion(let templateId):
            return APIConstant.template + "/\(templateId)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getTemplateList, .getTemplateQuestion:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .getTemplateList, .getTemplateQuestion:
            return .requestPlain
        }
    }

    var headers: [String : String]? {
        switch self {
        case .getTemplateList:
            return NetworkConstant.hasTokenHeader
        case .getTemplateQuestion:
            return NetworkConstant.hasTokenHeader
        }
    }
}


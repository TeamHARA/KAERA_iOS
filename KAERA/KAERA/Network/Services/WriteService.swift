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
}

extension WriteService: BaseTargetType {
    
    var path: String {
        switch self {
        case .getTemplateList:
            return APIConstant.templateList
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getTemplateList:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .getTemplateList:
            return .requestPlain
        }
    }

    var headers: [String : String]? {
        switch self {
        case .getTemplateList:
            return NetworkConstant.hasTokenHeader
        }
    }
}


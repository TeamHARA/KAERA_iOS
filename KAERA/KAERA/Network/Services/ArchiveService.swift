//
//  ArchiveService.swift
//  KAERA
//
//  Created by saint on 2023/08/26.
//

import Foundation
import Moya

enum ArchiveService{
    case archiveWorryList(templateId: Int)
}

extension ArchiveService: BaseTargetType {
    
    var path: String {
        switch self {
        case .archiveWorryList:
            return APIConstant.archiveWorryList
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .archiveWorryList:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .archiveWorryList(let templateId):
            return .requestParameters(parameters: ["templateId": "\(templateId)"], encoding: URLEncoding.default)
        }
    }

    var headers: [String : String]? {
        switch self {
        case .archiveWorryList:
            return NetworkConstant.hasTokenHeader
        }
    }
}


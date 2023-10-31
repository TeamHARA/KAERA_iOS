//
//  HomeService.swift
//  KAERA
//
//  Created by 김담인 on 2023/08/19.
//

import Foundation
import Moya

enum HomeService {
    case homeGemList(isSolved: Int)
    case worryDetail(worryId: Int)
    case deleteWorry(worryId: Int)
    case updateDeadline(param: PatchDeadlineModel)
}

extension HomeService: BaseTargetType {
    
    var path: String {
        switch self {
        case .homeGemList(let isSolved):
            return APIConstant.worryList + "/\(isSolved)"
        case .worryDetail(let worryId), .deleteWorry(let worryId):
            return APIConstant.worry + "/\(worryId)"
        case .updateDeadline:
            return APIConstant.worry + "/deadline"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .homeGemList, .worryDetail:
            return .get
        case .deleteWorry:
            return .delete
        case .updateDeadline:
            return .patch
        }
    }
    
    var task: Task {
        switch self {
        case .homeGemList, .worryDetail, .deleteWorry:
            return .requestPlain
        case .updateDeadline(let param):
            return .requestJSONEncodable(param)
        }
    }

    var headers: [String : String]? {
        switch self {
        case .homeGemList, .worryDetail, .deleteWorry, .updateDeadline:
            return NetworkConstant.hasTokenHeader
        }
    }
}

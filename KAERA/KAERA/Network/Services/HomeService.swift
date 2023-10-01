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
}

extension HomeService: BaseTargetType {
    
    var path: String {
        switch self {
        case .homeGemList(let isSolved):
            return APIConstant.worryList + "/\(isSolved)"
        case .worryDetail(let worryId), .deleteWorry(let worryId):
            return APIConstant.worry + "/\(worryId)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .homeGemList, .worryDetail:
            return .get
        case .deleteWorry:
            return .delete
        }
    }
    
    var task: Task {
        switch self {
        case .homeGemList, .worryDetail, .deleteWorry:
            return .requestPlain
        }
    }

    var headers: [String : String]? {
        switch self {
        case .homeGemList, .worryDetail, .deleteWorry:
            return NetworkConstant.hasTokenHeader
        }
    }
}

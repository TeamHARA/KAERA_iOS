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
}

extension HomeService: BaseTargetType {
    
    var path: String {
        switch self {
        case .homeGemList(let isSolved):
            return APIConstant.worryList + "/\(isSolved)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .homeGemList:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .homeGemList:
            return .requestPlain
        }
    }

    var headers: [String : String]? {
        switch self {
        case .homeGemList:
            return NetworkConstant.hasTokenHeader
        }
    }
}

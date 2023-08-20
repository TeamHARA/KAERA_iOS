//
//  HomeService.swift
//  KAERA
//
//  Created by 김담인 on 2023/08/19.
//

import Foundation
import Moya

enum HomeService {
    case homeWorryList(isSolved: Int)
}

extension HomeService: BaseTargetType {
    
    var path: String {
        switch self {
        case .homeWorryList(let isSolved):
            return APIConstant.homeWorryList + "/\(isSolved)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .homeWorryList:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .homeWorryList:
            return .requestPlain
        }
    }

    var headers: [String : String]? {
        switch self {
        case .homeWorryList:
            return NetworkConstant.hasTokenHeader
        }
    }
}

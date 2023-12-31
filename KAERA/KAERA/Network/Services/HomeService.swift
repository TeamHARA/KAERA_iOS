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
    case editWorry(param: PatchWorryModel)
    case completeWorry(param: CompleteWorryModel)
    case patchReview(body: WorryReviewRequestBody)
}

extension HomeService: BaseTargetType {
    
    var path: String {
        switch self {
        case .homeGemList(let isSolved):
            return APIConstant.worry + "/\(isSolved)/list"
            
        case .worryDetail(let worryId), .deleteWorry(let worryId):
            return APIConstant.worry + "/\(worryId)"
            
        case .updateDeadline:
            return APIConstant.deadline
            
        case .editWorry:
            return APIConstant.worry
            
        case .completeWorry:
            return APIConstant.finalAnswer
            
        case .patchReview:
            return APIConstant.review
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .homeGemList, .worryDetail:
            return .get
        case .deleteWorry:
            return .delete
        case .updateDeadline, .editWorry, .completeWorry, .patchReview:
            return .patch
        }
    }
    
    var task: Task {
        switch self {
        case .homeGemList:
            return .requestParameters(parameters: ["page" : 1, "limit" : 12], encoding: URLEncoding.queryString)
        case .worryDetail, .deleteWorry:
            return .requestPlain
        case .updateDeadline(let param):
            return .requestJSONEncodable(param)
        case .editWorry(let param):
            return .requestJSONEncodable(param)
        case .completeWorry(let param):
            return .requestJSONEncodable(param)
        case .patchReview(let body):
            return .requestJSONEncodable(body)
        }
    }

    var headers: [String : String]? {
        switch self {
        case .homeGemList, .worryDetail, .deleteWorry, .updateDeadline, .editWorry, .completeWorry, .patchReview:
            return NetworkConstant.hasTokenHeader
        }
    }
    
    var validationType: ValidationType {
         return .successCodes
     }
}

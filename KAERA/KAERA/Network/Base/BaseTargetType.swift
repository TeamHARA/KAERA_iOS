//
//  BaseTargetType.swift
//  HARA
//
//  Created by 김담인 on 2023/01/04.
//

import Foundation
import Moya

protocol BaseTargetType: TargetType { }

extension BaseTargetType {
    var baseURL: URL {
        return URL(string: APIConstant.baseURL)!
    }

}

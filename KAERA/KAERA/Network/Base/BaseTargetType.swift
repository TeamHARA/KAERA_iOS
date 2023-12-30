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
        guard let baseURL = URL(string: APIConstant.baseURL) else {
            fatalError("APIConstant.baseURL Not Configured")
        }
        return baseURL
    }
}

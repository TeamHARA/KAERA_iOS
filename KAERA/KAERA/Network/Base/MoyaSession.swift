//
//  MoyaSession.swift
//  KAERA
//
//  Created by 김담인 on 2024/01/21.
//

import Foundation
import Moya

final class MoyaSession {
    
    let session: Session = {
        let configuration = URLSessionConfiguration.af.default
        configuration.timeoutIntervalForRequest = 3
        let interceptor = AuthInterceptor.shared
        return Session(configuration: configuration, interceptor: interceptor)
    }()
    
    static let shared = MoyaSession()
    
    private init() { }
}

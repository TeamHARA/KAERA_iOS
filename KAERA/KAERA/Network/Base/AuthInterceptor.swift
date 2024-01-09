//
//  AuthInterceptor.swift
//  KAERA
//
//  Created by 김담인 on 2023/11/22.
//

import Foundation
import Alamofire
import Moya

final class AuthInterceptor: RequestInterceptor {
    
    static let shared = AuthInterceptor()
    
    private init() {}

    private let retryLimit = 5
    
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        print("retry 진입")
        if request.retryCount > retryLimit {
            print("Over retry limit")
            completion(.doNotRetryWithError(error))
            return
        }
        guard let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401, let pathComponents = request.request?.url?.pathComponents,
              !pathComponents.contains("refresh")
        else {
            dump(error)
            completion(.doNotRetryWithError(error))
            return
        }
        AuthAPI.shared.postRenewalRequest { res in
            guard let res, let data = res.data else {
                //TODO: 재갱신 실패시 Refresh Token까지 만료된 것이라 처리 필요
                completion(.doNotRetryWithError(error))
                return
            }
            let renewedAccessToken = data.accessToken
            KeychainManager.save(key: .accessToken, value: renewedAccessToken)
            completion(.retry)
        }
    }
}

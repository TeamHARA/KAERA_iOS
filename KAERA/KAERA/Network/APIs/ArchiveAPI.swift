//
//  ArchiveAPI.swift
//  KAERA
//
//  Created by saint on 2023/08/26.
//

import Foundation
import Moya

final class ArchiveAPI {
    
    static let shared: ArchiveAPI = ArchiveAPI()
    private let archiveProvider = MoyaProvider<ArchiveService>(session: MoyaSession.shared.session,plugins: [MoyaLoggingPlugin()])
    
    private init() { }
    
    public private(set) var archiveWorryListResponse: GeneralResponse<WorryListModel>?
    
    // MARK: - HomeGemList
    func getArchiveWorryList(param: Int, completion: @escaping (Result<GeneralResponse<WorryListModel>, ErrorCase>) -> Void ) {
        archiveProvider.request(.archiveWorryList(templateId: param)) { [weak self] response in
            switch response {
            case .success(let result):
                do {
                    self?.archiveWorryListResponse = try
                    result.map(GeneralResponse<WorryListModel>?.self)
                    guard let worryList = self?.archiveWorryListResponse else { return }
                    completion(.success(worryList))
                } catch(let err) {
                    print(err.localizedDescription)
                    completion(.failure(.appError))
                }
            case .failure(let err):
                if let response = err.response {
                    /// HTTP 상태 코드가 400-500 사이인 경우 appError로 처리
                    completion(.failure((400...500).contains(response.statusCode) ? .appError : .internetError))
                } else {
                    /// 응답이 없는 경우 internetError로 처리
                    completion(.failure(.internetError))
                }
            }
        }
    }
}


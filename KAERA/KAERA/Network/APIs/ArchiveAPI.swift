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
    private let archiveProvider = MoyaProvider<ArchiveService>(session: Session(interceptor: AuthInterceptor.shared),plugins: [MoyaLoggingPlugin()])
    
    private init() { }
    
    public private(set) var archiveWorryListResponse: GeneralResponse<WorryListModel>?
    
    
    // MARK: - HomeGemList
    func getArchiveWorryList(param: Int, completion: @escaping (GeneralResponse<WorryListModel>?) -> () ) {
        archiveProvider.request(.archiveWorryList(templateId: param)) { [weak self] response in
            switch response {
            case .success(let result):
                do {
                    self?.archiveWorryListResponse = try
                    result.map(GeneralResponse<WorryListModel>?.self)
                    guard let worryList = self?.archiveWorryListResponse else { return }
                    completion(worryList)
                } catch(let err) {
                    print(err.localizedDescription)
                    completion(nil)
                }
            case .failure(let err):
                print(err.localizedDescription)
                completion(nil)
            }
        }
    }
}


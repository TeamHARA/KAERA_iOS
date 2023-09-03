//
//  WriteAPI.swift
//  KAERA
//
//  Created by saint on 2023/08/27.
//


import Foundation
import Moya

final class WriteAPI {
    
    static let shared: WriteAPI = WriteAPI()
    private let archiveProvider = MoyaProvider<WriteService>(plugins: [MoyaLoggingPlugin()])
    
    private init() { }
    
    public private(set) var templateListResponse: GeneralArrayResponse<TemplateListModel>?
    
    
    // MARK: - HomeGemList
    func getTemplateList(completion: @escaping (GeneralArrayResponse<TemplateListModel>?) -> () ) {
        archiveProvider.request(.getTemplateList) { [weak self] response in
            switch response {
            case .success(let result):
                do {
                    self?.templateListResponse = try
                    result.map(GeneralArrayResponse<TemplateListModel>?.self)
                    print("성공")
                    print(result)
                    guard let templateList = self?.templateListResponse else { return }
                    print(templateList)
                    completion(templateList)
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


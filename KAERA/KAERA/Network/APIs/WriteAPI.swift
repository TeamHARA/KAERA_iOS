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
    private let writeProvider = MoyaProvider<WriteService>(plugins: [MoyaLoggingPlugin()])
    
    private init() { }
    
    public private(set) var templateListResponse: GeneralArrayResponse<TemplateListModel>?
    public private(set) var templateContentResponse: GeneralResponse<TemplateContentModel>?
    
    
    // MARK: - HomeGemList
    func getTemplateList(completion: @escaping (GeneralArrayResponse<TemplateListModel>?) -> () ) {
        writeProvider.request(.getTemplateList) { [weak self] response in
            switch response {
            case .success(let result):
                do {
                    self?.templateListResponse = try
                    result.map(GeneralArrayResponse<TemplateListModel>?.self)
                    guard let templateList = self?.templateListResponse else { return }
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
    
    func getTemplateQuestion(param: Int, completion: @escaping (GeneralResponse<TemplateContentModel>?) -> () ) {
        writeProvider.request(.getTemplateQuestion(templateId: param)) { [weak self] response in
            switch response {
            case .success(let result):
                do {
                    self?.templateContentResponse = try
                    result.map(GeneralResponse<TemplateContentModel>?.self)
                    guard let contentList = self?.templateContentResponse else { return }
                    completion(contentList)
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


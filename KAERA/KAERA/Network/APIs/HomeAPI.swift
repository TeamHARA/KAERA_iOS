//
//  HomeAPI.swift
//  KAERA
//
//  Created by 김담인 on 2023/08/19.
//

import Foundation
import Moya

final class HomeAPI {
    
    static let shared: HomeAPI = HomeAPI()
    private let homeProvider = MoyaProvider<HomeService>(plugins: [MoyaLoggingPlugin()])
    
    private init() { }
    
    public private(set) var homeWorryListResponse: GeneralArrayResponse<HomeGemListModel>?
    
   
    // MARK: - WorryAlone
    func getHomeWorryList(param: Int, completion: @escaping (GeneralArrayResponse<HomeGemListModel>?) -> () ) {
        homeProvider.request(.homeWorryList(isSolved: param)) { [weak self] response in
            switch response {
            case .success(let result):
                do {
                    self?.homeWorryListResponse = try
                    result.map(GeneralArrayResponse<HomeGemListModel>?.self)
                    print("성공")
                    print(result)
                    guard let worryList = self?.homeWorryListResponse else { return }
                    print(worryList)
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


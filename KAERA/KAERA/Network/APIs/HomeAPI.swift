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
    
    public private(set) var homeGemListResponse: GeneralArrayResponse<HomeGemListModel>?
    public private(set) var worryDetailResponse: GeneralResponse<WorryDetailModel>?
   
    // MARK: - HomeGemList
    func getHomeGemList(param: Int, completion: @escaping (GeneralArrayResponse<HomeGemListModel>?) -> () ) {
        homeProvider.request(.homeGemList(isSolved: param)) { [weak self] response in
            switch response {
            case .success(let result):
                do {
                    self?.homeGemListResponse = try
                    result.map(GeneralArrayResponse<HomeGemListModel>?.self)
                    guard let gemList = self?.homeGemListResponse else { return }
                    completion(gemList)
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
    
    // MARK: - WorryDetail
    func getWorryDetail(param: Int, completion: @escaping (GeneralResponse<WorryDetailModel>?) -> () ) {
        homeProvider.request(.worryDetail(worryId: param)) { [weak self] response in
            switch response {
            case .success(let result):
                do {
                    self?.worryDetailResponse = try result.map(GeneralResponse<WorryDetailModel>?.self)
                    guard let worryDetail = self?.worryDetailResponse else { return }
                    completion(worryDetail)
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


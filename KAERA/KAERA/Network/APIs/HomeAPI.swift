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
    public private(set) var deleteWorryResponse: EmptyResponse?
    public private(set) var updateDeadlineResponse: GeneralResponse<String>?
    public private(set) var editWorryResponse: GeneralResponse<String>?
    public private(set) var completeWorryResponse: GeneralResponse<QuoteModel>?
   
    // MARK: - HomeGemList
    func getHomeGemList(param: Int, completion: @escaping (GeneralArrayResponse<HomeGemListModel>?) -> ()) {
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
    
    // MARK: - DeleteWorry
    func deleteWorry(param: Int, completion: @escaping (EmptyResponse?) -> ()) {
        homeProvider.request(.deleteWorry(worryId: param)) { [weak self] response in
            switch response {
            case .success(let result):
                do {
                    self?.deleteWorryResponse = try result.map(EmptyResponse?.self)
                    completion(self?.deleteWorryResponse)
                } catch(let err) {
                    print(err.localizedDescription)
                }
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
    
    // MARK: - UpdateDeadline
    func updateDeadline(param: PatchDeadlineModel, completion: @escaping (GeneralResponse<String>?) -> ()) {
        homeProvider.request(.updateDeadline(param: param)) { [weak self] response in
            switch response {
            case .success(let result):
                do {
                    self?.updateDeadlineResponse = try result.map(GeneralResponse<String>?.self)
                    guard let worryDeadline = self?.updateDeadlineResponse else { return }
                    completion(worryDeadline)
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
    
    // MARK: - EditWorry
    func editWorry(param: PatchWorryModel, completion: @escaping (GeneralResponse<String>?) -> ()) {
        homeProvider.request(.editWorry(param: param)) { [weak self] response in
            switch response {
            case .success(let result):
                do {
                    self?.editWorryResponse = try result.map(GeneralResponse<String>?.self)
                    guard let worryContent = self?.editWorryResponse else { return }
                    completion(worryContent)
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
    
    // MARK: - CompleteWorry
    func completeWorry(param: CompleteWorryModel, completion: @escaping (GeneralResponse<QuoteModel>?) -> ()) {
        homeProvider.request(.completeWorry(param: param)) { [weak self] response in
            switch response {
            case .success(let result):
                do {
                    self?.completeWorryResponse = try result.map(GeneralResponse<QuoteModel>?.self)
                    
                    guard let res = self?.completeWorryResponse else { return }
                    switch res.status {
                    case 200..<300:
                        completion(res)
                    default:
                        completion(nil)
                    }
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


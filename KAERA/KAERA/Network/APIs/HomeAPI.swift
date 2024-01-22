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

    private let homeProvider = MoyaProvider<HomeService>(session: MoyaSession.shared.session, plugins: [MoyaLoggingPlugin()])
    
    private init() { }
    
    public private(set) var homeGemListResponse: GeneralArrayResponse<HomeGemListModel>?
    public private(set) var worryDetailResponse: GeneralResponse<WorryDetailModel>?
    public private(set) var deleteWorryResponse: EmptyResponse?
    public private(set) var updateDeadlineResponse: GeneralResponse<WorryDeadlineUpdateResponseModel>?
    public private(set) var editWorryResponse: GeneralResponse<EditWorryResponseModel>?
    public private(set) var completeWorryResponse: GeneralResponse<QuoteModel>?
    public private(set) var worryReviewResponse: GeneralResponse<WorryReviewResponseModel>?
   
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
    func getWorryDetail(param: Int, completion: @escaping (Result<GeneralResponse<WorryDetailModel>, ErrorCase>) -> Void) {
        homeProvider.request(.worryDetail(worryId: param)) { response in
            switch response {
            case .success(let result):
                do {
                    let worryDetailResponse = try result.map(GeneralResponse<WorryDetailModel>.self)
                    completion(.success(worryDetailResponse))
                } catch {
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
    func updateDeadline(param: PatchDeadlineModel, completion: @escaping (GeneralResponse<WorryDeadlineUpdateResponseModel>?) -> ()) {
        homeProvider.request(.updateDeadline(param: param)) { [weak self] response in
            switch response {
            case .success(let result):
                do {
                    self?.updateDeadlineResponse = try result.map(GeneralResponse<WorryDeadlineUpdateResponseModel>?.self)
                    guard let response = self?.updateDeadlineResponse else { return }
                    
                    if 200..<300 ~= response.status {
                        completion(response)
                    } else {
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
    
    // MARK: - EditWorry
    func editWorry(param: PatchWorryModel, completion: @escaping (GeneralResponse<EditWorryResponseModel>?) -> ()) {
        homeProvider.request(.editWorry(param: param)) { [weak self] response in
            switch response {
            case .success(let result):
                do {
                    self?.editWorryResponse = try result.map(GeneralResponse<EditWorryResponseModel>?.self)
                    guard let editWorryRes = self?.editWorryResponse else { return }
                    completion(editWorryRes)
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
    
    // MARK: - patchReview
    func patchReview(body: WorryReviewRequestBody, completion: @escaping (GeneralResponse<WorryReviewResponseModel>?) -> ()) {
        homeProvider.request(.patchReview(body: body)) { [weak self] response in
            switch response {
            case .success(let result):
                do {
                    self?.worryReviewResponse = try result.map(GeneralResponse<WorryReviewResponseModel>?.self)
                    guard let res = self?.worryReviewResponse else { return }
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


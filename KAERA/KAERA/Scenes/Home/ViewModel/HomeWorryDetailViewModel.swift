//
//  HomeWorryDetailViewModel.swift
//  KAERA
//
//  Created by 김담인 on 2023/07/23.
//

import Foundation
import Combine

final class HomeWorryDetailViewModel: ViewModelType {
    
    typealias Input = AnyPublisher<Int, Never>
    
    typealias Output = AnyPublisher<WorryDetailModel, Error>
    
    private let output: PassthroughSubject<WorryDetailModel, Error> = .init()
    private var cancellables = Set<AnyCancellable>()
    
    var worryDetail: WorryDetailModel?
    
    // MARK: - Function
    func transform(input: AnyPublisher<Int, Never>) -> AnyPublisher<WorryDetailModel, Error> {
        input
            .flatMap { [weak self] worryId -> AnyPublisher<WorryDetailModel, Error> in
                guard let self = self else { return Fail(error: ErrorCase.appError).eraseToAnyPublisher() }
                
                return self.getWorryDetail(worryId: worryId)
            }
            .eraseToAnyPublisher()
    }
}

// MARK: - Network
extension HomeWorryDetailViewModel {
    private func getWorryDetail(worryId: Int) -> AnyPublisher<WorryDetailModel, Error> {
        Future<WorryDetailModel, Error> { promise in
            HomeAPI.shared.getWorryDetail(param: worryId) { result in
                switch result {
                case .success(let response):
                    if let data = response.data {
                        promise(.success(data))
                    } else {
                        promise(.failure(ErrorCase.appError))
                    }
                case .failure(let errorCase):
                    promise(.failure(errorCase))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}


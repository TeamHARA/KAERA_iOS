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
    
    private var output: PassthroughSubject<WorryDetailModel, Error> = .init()
    private var cancellables = Set<AnyCancellable>()
    
    var worryDetail: WorryDetailModel?
    
    // MARK: - Function
    func transform(input: AnyPublisher<Int, Never>) -> AnyPublisher<WorryDetailModel, Error> {
        input
            .sink { [weak self] worryId in
                self?.getWorryDetail(worryId: worryId)
            }
            .store(in: &cancellables)
        return output.eraseToAnyPublisher()
    }
}

// MARK: - Network
extension HomeWorryDetailViewModel {
    private func getWorryDetail(worryId: Int) {
        HomeAPI.shared.getWorryDetail(param: worryId) { [weak self] result in
            switch result {
            case .success(let response):
                if let data = response.data {
                    self?.output.send(data)
                    self?.worryDetail = data
                } else {
                    self?.output.send(completion: .failure(ErrorCase.appError))
                    self?.resetSubscription()
                }
            case .failure(let errorCase):
                self?.output.send(completion: .failure(errorCase))
                self?.resetSubscription()
            }
        }
    }
    
    private func resetSubscription() {
        self.cancellables = []
        self.output = PassthroughSubject.init()
    }
}


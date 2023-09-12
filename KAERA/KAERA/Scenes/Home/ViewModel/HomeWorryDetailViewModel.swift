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
    
    typealias Output = AnyPublisher<WorryDetailModel, Never>
    
    private let output: PassthroughSubject<WorryDetailModel, Never> = .init()
    private var cancellables = Set<AnyCancellable>()
    
    var worryDetail: WorryDetailModel?
    
    // MARK: - Function
    func transform(input: AnyPublisher<Int, Never>) -> AnyPublisher<WorryDetailModel, Never> {
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
        HomeAPI.shared.getWorryDetail(param: worryId) { res in
            guard let res = res else { return }
            guard let data = res.data else { return }
            self.output.send(data)
            self.worryDetail = data
        }
    }
}


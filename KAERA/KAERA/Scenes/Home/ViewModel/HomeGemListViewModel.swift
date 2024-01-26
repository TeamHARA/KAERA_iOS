//
//  HomeDiggingViweModel.swift
//  KAERA
//
//  Created by 김담인 on 2023/07/12.
//

import Foundation
import Combine

final class HomeGemListViewModel: ViewModelType {
    
    typealias Input = AnyPublisher<Int, Never>
    typealias Output = AnyPublisher<[HomePublisherModel], Error>
    
    private var output: PassthroughSubject<[HomePublisherModel], Error> = .init()
    private var cancellables = Set<AnyCancellable>()
    
    func transform(input: Input) -> Output {
        input
            .sink { [weak self] isSolved in
                self?.getHomeGemList(isSolved: isSolved)
            }
            .store(in: &cancellables)
        return output.eraseToAnyPublisher()
    }
    
    
    // MARK: - Properties
    struct TemplateKey: Hashable {
        let id: Int
        let isSolved: Int
    }
    
    private var gemStoneDictionary: [TemplateKey: String] = [
        TemplateKey(id: 1, isSolved: 0): "gemstone_blue",
        TemplateKey(id: 1, isSolved: 1): "gem_blue_l",
        TemplateKey(id: 2, isSolved: 0): "gemstone_red",
        TemplateKey(id: 2, isSolved: 1): "gem_red_l",
        TemplateKey(id: 3, isSolved: 0): "gemstone_orange",
        TemplateKey(id: 3, isSolved: 1): "gem_orange_l",
        TemplateKey(id: 4, isSolved: 0): "gemstone_green",
        TemplateKey(id: 4, isSolved: 1): "gem_green_l",
        TemplateKey(id: 5, isSolved: 0): "gemstone_pink",
        TemplateKey(id: 5, isSolved: 1): "gem_pink_l",
        TemplateKey(id: 6, isSolved: 0): "gemstone_yellow",
        TemplateKey(id: 6, isSolved: 1): "gem_yellow_l",
    ]
    
}
// MARK: - Network
extension HomeGemListViewModel {
    
    private func getHomeGemList(isSolved: Int) {
        HomeAPI.shared.getHomeGemList(param: isSolved) { [weak self] result in
            switch result {
            case .success(let response):
                if let data = response.data {
                    var gemStoneList: [HomePublisherModel] = []
                    
                    data.forEach {
                        let image = self?.gemStoneDictionary[TemplateKey(id: $0.templateId, isSolved: isSolved)] ?? "gemstone_pink"
                        let publisherModel = HomePublisherModel(worryId: $0.worryId, templateId: $0.templateId, imageName: image, title: $0.title)
                        gemStoneList.append(publisherModel)
                    }
                   
                    self?.output.send(gemStoneList)
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
        cancellables = []
        output = PassthroughSubject()
    }
}

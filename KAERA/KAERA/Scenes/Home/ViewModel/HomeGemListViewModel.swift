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
    
    private let output: PassthroughSubject<[HomePublisherModel], Error> = .init()
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
    
    private var gemStoneList: [HomePublisherModel] = []

}
// MARK: - Network
extension HomeGemListViewModel {
    private func getHomeGemList(isSolved: Int) {
        HomeAPI.shared.getHomeGemList(param: isSolved) { res in
            guard let res = res, let data = res.data else {
                self.output.send(completion: .failure(NSError()))
                return
            }
            /// 뿌려줄 리스트 초기화
            self.gemStoneList = []
            
            data.forEach {
                let image = self.gemStoneDictionary[TemplateKey(id: $0.templateId, isSolved: isSolved)] ?? "gemstone_pink"
                let publisherModel = HomePublisherModel(worryId: $0.worryId, templateId: $0.templateId, imageName: image, title: $0.title)
                self.gemStoneList.append(publisherModel)
            }
            
            self.output.send(self.gemStoneList)
        }

    }
}

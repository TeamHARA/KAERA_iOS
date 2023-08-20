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
    typealias Output = AnyPublisher<[HomePublisherModel], Never>
    
    private let output: PassthroughSubject<[HomePublisherModel], Never> = .init()
    private var cancellables = Set<AnyCancellable>()
    
    func transform(input: Input) -> Output {
        input
            .sink { [weak self] isSolved in
//                self?.getGemList(isSovled: isSolved)
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
        TemplateKey(id: 1, isSolved: 0): "gemstone_pink",
        TemplateKey(id: 1, isSolved: 1): "gem_pink_l",
        TemplateKey(id: 2, isSolved: 0): "gemstone_orange",
        TemplateKey(id: 2, isSolved: 1): "gem_orange_l",
        TemplateKey(id: 3, isSolved: 0): "gemstone_blue",
        TemplateKey(id: 3, isSolved: 1): "gem_blue_l",
        TemplateKey(id: 4, isSolved: 0): "gemstone_green",
        TemplateKey(id: 4, isSolved: 1): "gem_green_l",
        TemplateKey(id: 5, isSolved: 0): "gemstone_yellow",
        TemplateKey(id: 5, isSolved: 1): "gem_yellow_l",
        TemplateKey(id: 6, isSolved: 0): "gemstone_red",
        TemplateKey(id: 6, isSolved: 1): "gem_red_l",
    ]
    
    private var gemStoneList: [HomePublisherModel] = []
    /// 서버에서 받아올 데이터 모델 배열
    private var gemStoneListDummy: [HomeGemListModel] = [
        HomeGemListModel(worryId: 1, templateId: 1, title: "고민중1"),
        HomeGemListModel(worryId: 2, templateId: 2, title: "고민중2"),
        HomeGemListModel(worryId: 3, templateId: 3, title: "고민중3"),
        HomeGemListModel(worryId: 4, templateId: 4, title: "고민중4"),
        HomeGemListModel(worryId: 5, templateId: 5, title: "고민중5"),
        HomeGemListModel(worryId: 6, templateId: 6, title: "고민중6"),
        HomeGemListModel(worryId: 7, templateId: 1, title: "고민중7"),
        HomeGemListModel(worryId: 8, templateId: 2, title: "고민중8"),
        HomeGemListModel(worryId: 9, templateId: 3, title: "고민중9"),
        HomeGemListModel(worryId: 10, templateId: 4, title: "고민중10"),
        HomeGemListModel(worryId: 11, templateId: 5, title: "고민중11"),
        HomeGemListModel(worryId: 12, templateId: 6, title: "고민중12"),
    ]
    private var gemListDummy: [HomeGemListModel] = [
        HomeGemListModel(worryId: 1, templateId: 1, title: "고민완료1"),
        HomeGemListModel(worryId: 2, templateId: 2, title: "고민완료2"),
        HomeGemListModel(worryId: 3, templateId: 3, title: "고민완료3"),
        HomeGemListModel(worryId: 4, templateId: 4, title: "고민완료4"),
        HomeGemListModel(worryId: 5, templateId: 5, title: "고민완료5"),
        HomeGemListModel(worryId: 6, templateId: 6, title: "고민완료6"),
        HomeGemListModel(worryId: 7, templateId: 1, title: "고민완료7"),
        HomeGemListModel(worryId: 8, templateId: 2, title: "고민완료8"),
        HomeGemListModel(worryId: 9, templateId: 3, title: "고민완료9"),
        HomeGemListModel(worryId: 10, templateId: 4, title: "고민완료10"),
        HomeGemListModel(worryId: 11, templateId: 5, title: "고민완료11"),
        HomeGemListModel(worryId: 12, templateId: 6, title: "고민완료12"),
    ]
    
    // MARK: - Function
    private func getGemList(isSovled: Int) {
        /// 서버 통신을 통해 getStoneList를 업데이트
        /// 여기서는 더미로 업데이트
        ///  서버 연결시 if 문 필요 없이 gemStoneList만 사용
        if isSovled > 0 {
            gemStoneList = []
            gemListDummy.forEach {
                let image = gemStoneDictionary[TemplateKey(id: $0.templateId, isSolved: isSovled)] ?? "gemstone_pink"
                let data = HomePublisherModel(worryId: $0.worryId, templateId: $0.templateId, imageName: image, title: $0.title)
                gemStoneList.append(data)
            }
            self.output.send(gemStoneList)
        } else {
            gemStoneList = []
            gemStoneListDummy.forEach {
                let image = gemStoneDictionary[TemplateKey(id: $0.templateId, isSolved: isSovled)] ?? "gem_pink_l"
                let data = HomePublisherModel(worryId: $0.worryId, templateId: $0.templateId, imageName: image, title: $0.title)
                gemStoneList.append(data)
            }
            self.output.send(gemStoneList)
        }
        
        
    }
}
// MARK: - Network
extension HomeGemListViewModel {
    private func getHomeGemList(isSolved: Int) {
        HomeAPI.shared.getHomeWorryList(param: isSolved) { res in
            guard let res = res, let data = res.data else { return }
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

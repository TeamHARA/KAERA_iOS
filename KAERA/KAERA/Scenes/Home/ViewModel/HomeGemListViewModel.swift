//
//  HomeDiggingViweModel.swift
//  KAERA
//
//  Created by 김담인 on 2023/07/12.
//

import Foundation
import Combine

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}

class HomeGemListViewModel: ViewModelType {
    struct Input {
        let isSolved: AnyPublisher<Bool, Never>
    }
    struct Output {
        let dataList: AnyPublisher<[HomeGemListModel], Never>
    }
    
    private let output: PassthroughSubject<[HomeGemListModel], Never> = .init()
    private var cancellables = Set<AnyCancellable>()
    
    func transform(input: Input) -> Output {
        input.isSolved
            .sink { [weak self] isSolved in
                self?.getGemList(isSovled: isSolved)
            }
            .store(in: &cancellables)
        return Output(dataList: output.eraseToAnyPublisher())
    }
    
    
    // MARK: - Properties
    private var gemStoneList: [HomeGemListModel] = []
    private var gemList: [HomeGemListModel] = []
    /// 서버에서 받아올 데이터 모델 배열
    private var gemStoneListDummy: [HomeGemListModel] = [
        HomeGemListModel(worryId: 1, templateId: 1, title: "고민중1"),
        HomeGemListModel(worryId: 2, templateId: 2, title: "고민중2"),
        HomeGemListModel(worryId: 3, templateId: 3, title: "고민중3"),
        HomeGemListModel(worryId: 4, templateId: 4, title: "고민중4"),
        HomeGemListModel(worryId: 5, templateId: 5, title: "고민중5"),
        HomeGemListModel(worryId: 6, templateId: 6, title: "고민중6"),
        HomeGemListModel(worryId: 7, templateId: 7, title: "고민중7"),
        HomeGemListModel(worryId: 8, templateId: 8, title: "고민중8"),
        HomeGemListModel(worryId: 9, templateId: 9, title: "고민중9"),
        HomeGemListModel(worryId: 10, templateId: 10, title: "고민중10"),
        HomeGemListModel(worryId: 11, templateId: 11, title: "고민중11"),
        HomeGemListModel(worryId: 12, templateId: 12, title: "고민중12"),
    ]
    private var gemListDummy: [HomeGemListModel] = [
        HomeGemListModel(worryId: 1, templateId: 1, title: "고민완료1"),
        HomeGemListModel(worryId: 2, templateId: 2, title: "고민완료2"),
        HomeGemListModel(worryId: 3, templateId: 3, title: "고민완료3"),
        HomeGemListModel(worryId: 4, templateId: 4, title: "고민완료4"),
        HomeGemListModel(worryId: 5, templateId: 5, title: "고민완료5"),
        HomeGemListModel(worryId: 6, templateId: 6, title: "고민완료6"),
        HomeGemListModel(worryId: 7, templateId: 7, title: "고민완료7"),
        HomeGemListModel(worryId: 8, templateId: 8, title: "고민완료8"),
        HomeGemListModel(worryId: 9, templateId: 9, title: "고민완료9"),
        HomeGemListModel(worryId: 10, templateId: 10, title: "고민완료10"),
        HomeGemListModel(worryId: 11, templateId: 11, title: "고민완료11"),
        HomeGemListModel(worryId: 12, templateId: 12, title: "고민완료12"),
    ]
    
    // MARK: - Function
    private func getGemList(isSovled: Bool) {
        /// 서버 통신을 통해 getStoneList를 업데이트
        /// 여기서는 더미로 업데이트
        if isSovled {
            gemList = gemListDummy
            self.output.send(gemList)
        } else {
            gemStoneList = gemStoneListDummy
            self.output.send(gemStoneList)
        }
        
        
    }
}

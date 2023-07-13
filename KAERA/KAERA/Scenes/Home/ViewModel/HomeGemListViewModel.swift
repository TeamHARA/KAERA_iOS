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
    /// CurrentValueSubject는 초기값을 가지는데 구조상 VC의 ViewWillApear에서 처음에 데이터 전달이 이루어지므로
    /// 초기값으로 인해 데이터 전달이 결국 2번이 이루어지기 때문에 초기값을 가지지 않는 PassthroughSubject사용함
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
    ]
    private var gemListDummy: [HomeGemListModel] = [
        HomeGemListModel(worryId: 1, templateId: 1, title: "고민완료1"),
        HomeGemListModel(worryId: 2, templateId: 2, title: "고민완료2"),
        HomeGemListModel(worryId: 3, templateId: 3, title: "고민완료3"),
        HomeGemListModel(worryId: 4, templateId: 4, title: "고민완료4"),
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

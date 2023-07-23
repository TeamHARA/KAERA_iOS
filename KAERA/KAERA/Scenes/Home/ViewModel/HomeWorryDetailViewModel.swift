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
    private var worryId = 1
    
    func transform(input: AnyPublisher<Int, Never>) -> AnyPublisher<WorryDetailModel, Never> {
        input
            .sink { [weak self] worryId in
                self?.getWorryDetail(worryId: worryId)
            }
            .store(in: &cancellables)
        
        return output.eraseToAnyPublisher()
    }
    
    // MARK: - Function
    private func getWorryDetail(worryId: Int) {
        /// 서버 통신으로 worryId 값 주고 데이터 받아옴
        let result = WorryDetailModel(title: "고민 제목", templateId: 1, deadline: 1, questions: ["지금 나의 고민1", "지금 나의 고민2", "지금 나의 고민3", "지금 나의 고민4"], answers: ["걱정하고 있는 걸 사실대로 써봅시다.걱정하고 있는 걸 사실대로 써봅시다.걱정하고 있는 걸 사실대로 써봅시다.걱정하고 있는 걸 사실대로 써봅시다.", "걱정하고 있는 걸 사실대로 써봅시다.걱정하고 있는 걸 사실대로 써봅시다.걱정하고 있는 걸 사실대로 써봅시다.걱정하고 있는 걸 사실대로 써봅시다.", "걱정하고 있는 걸 사실대로 써봅시다.걱정하고 있는 걸 사실대로 써봅시다.걱정하고 있는 걸 사실대로 써봅시다.걱정하고 있는 걸 사실대로 써봅시다.", "걱정하고 있는 걸 사실대로 써봅시다.걱정하고 있는 걸 사실대로 써봅시다.걱정하고 있는 걸 사실대로 써봅시다.걱정하고 있는 걸 사실대로 써봅시다."], period: "2023.07.23 ~ 2023.07.24", updatedAt: "작성일 2023.07.23", finalAnswer: "마지막 대답", review: Review(content: "리뷰", updatedAt: "2023.09.23"))
        
        output.send(result)
    }
    
}



//
//  WritingWorryViewModel.swift
//  KAERA
//
//  Created by saint on 2023/08/12.
//

import UIKit
import Combine

// Worry Modal용
class TemplateContentViewModel: ViewModelType {
    
    typealias Input = AnyPublisher<Int, Never>
    typealias Output = AnyPublisher<TemplateContentModel, Never>
    
    private var cancellables = Set<AnyCancellable>()
    private let output = PassthroughSubject<TemplateContentModel, Never> ()
    
    func transform(input: Input) -> AnyPublisher<TemplateContentModel, Never> {
        input.sink{[weak self] templateId in
            self?.getTemplateContents(templateId)
        }
        .store(in: &cancellables)
        
        return output.eraseToAnyPublisher()
    }
}

extension TemplateContentViewModel {
    private func getTemplateContents(_ templateId: Int) {
        /// 서버 통신으로 template Id request 후에 데이터 가져오기
        WriteAPI.shared.getTemplateQuestion(param: templateId) { result in
            guard let result = result, let data = result.data else { return }
            self.output.send(data)
        }
    }
}

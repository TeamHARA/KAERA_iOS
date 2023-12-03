//
//  TemplateViewModel.swift
//  KAERA
//
//  Created by saint on 2023/07/11.
//

import UIKit
import Combine

// template Modal용
class TemplateViewModel: ViewModelType {
    
    struct customKey: Hashable {
        let index: Int
        let hasUsed: Bool
    }
    
    /// 딕셔너리는 hashable 프로토콜을 따라야 하므로, 1대1 매칭을 위해 커스텀 구조체 사용
    let idToImgTuple: [customKey: String] = [
        customKey(index: 1, hasUsed: true): "gem_blue_s_on",
        customKey(index: 1, hasUsed: false): "gem_blue_s_off",
        customKey(index: 2, hasUsed: true): "gem_red_s_on",
        customKey(index: 2, hasUsed: false): "gem_red_s_off",
        customKey(index: 3, hasUsed: true): "gem_orange_s_on",
        customKey(index: 3, hasUsed: false): "gem_orange_s_off",
        customKey(index: 4, hasUsed: true): "gem_green_s_on",
        customKey(index: 4, hasUsed: false): "gem_green_s_off",
        customKey(index: 5, hasUsed: true): "gem_pink_s_on",
        customKey(index: 5, hasUsed: false): "gem_pink_s_off",
        customKey(index: 6, hasUsed: true): "gem_yellow_s_on",
        customKey(index: 6, hasUsed: false): "gem_yellow_s_off"
    ]
  
    // templateinfo
    private var templateInfoList: [TemplateInfoPublisherModel] = []
    
    /// 고민작성뷰와 고민보관함뷰의 modalVC에서 사용
    var templateUpdateList: [TemplateInfoPublisherModel] = []
        
    typealias Input = AnyPublisher<Void, Never>
    typealias Output = AnyPublisher<[TemplateInfoPublisherModel], Error>
    
    private let output = PassthroughSubject<[TemplateInfoPublisherModel], Error> ()
    
    private var cancellables = Set<AnyCancellable>()
    
    /// 고민보관함뷰의 고민 작성지 뷰에서 사용
    func transform(input: Input) -> AnyPublisher<[TemplateInfoPublisherModel], Error> {
        input.sink{[weak self] _ in
            self?.convertTemplateInfo()
        }
        .store(in: &cancellables)
        return output.eraseToAnyPublisher()
    }
    
    /// 고민작성뷰와 고민보관함뷰의 modalVC에서 사용
    func transformModal(input: Input) -> AnyPublisher<[TemplateInfoPublisherModel], Error> {
        input.sink{[weak self] _ in
            self?.convertIdtoImg()
        }
        .store(in: &cancellables)
        return output.eraseToAnyPublisher()
    }
}

// MARK: - Functions
extension TemplateViewModel {
    private func convertIdtoImg() {
        WriteAPI.shared.getTemplateList { result in
            guard let result = result, let data = result.data else {
                self.output.send(completion: .failure(NSError()))
                return
            }

            self.templateUpdateList = data.compactMap {
                guard let imgName = self.idToImgTuple[customKey(index: $0.templateId, hasUsed: $0.hasUsed)] else { return nil }
                return TemplateInfoPublisherModel(templateId: $0.templateId, templateTitle: $0.title, info: $0.info, templateDetail: $0.shortInfo, image: UIImage(named: imgName) ?? UIImage())
            }
            self.output.send(self.templateUpdateList)
        }
    }

    private func convertTemplateInfo() {
        WriteAPI.shared.getTemplateList { result in
            guard let result = result, let data = result.data else {
                self.output.send(completion: .failure(NSError()))
                return
            }

            self.templateInfoList = data.compactMap {
                guard let imgName = self.idToImgTuple[customKey(index: $0.templateId, hasUsed: true)] else { return nil }
                return TemplateInfoPublisherModel(templateId: $0.templateId, templateTitle: $0.title, info: $0.info, templateDetail: $0.shortInfo, image: UIImage(named: imgName) ?? UIImage())
            }

            self.output.send(self.templateInfoList)
        }
    }
}


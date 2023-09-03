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
    
    var templateUpdateList: [TemplateListPublisherModel] = []
    
    var templateListDummy = [
           TemplateListModel(templateId: 0, title: "모든 보석 보기", shortInfo: "그동안 캐낸 모든 보석을 볼 수 있어요", info: "어떤 질문도 던지지 않아요. 캐라 도화지에서 머릿 속 얽혀있는 고민 실타래들을 마음껏 풀어내세요!", hasUsed: true),
           TemplateListModel(templateId: 1, title: "Free Flow", shortInfo: "빈 공간을 자유롭게 채우기", info: "내가 할 수 있는 선택지를 나열해보세요. 각각 어떤 장점과 단점을 가지고 있나요? 당신의 가능성을 펼쳐 비교해 더 나은 선택을 할 수 있도록 도와줄게요.", hasUsed: true)
       ]
    
    lazy var templateListPublisher = CurrentValueSubject<[TemplateListPublisherModel], Never>(templateUpdateList)
    
    // templateinfo
    private var templateInfoList: [TemplateInfoPublisherModel] = []
    private var cancellables = Set<AnyCancellable>()
    
    typealias Input = AnyPublisher<Void, Never>
    typealias Output = AnyPublisher<[TemplateInfoPublisherModel], Never>
    
    private let output = PassthroughSubject<[TemplateInfoPublisherModel], Never> ()

    func transform(input: Input) -> AnyPublisher<[TemplateInfoPublisherModel], Never> {
        input.sink{[weak self] _ in
            self?.convertTemplateInfo()
        }
        .store(in: &cancellables)
        return output.eraseToAnyPublisher()
    }
    
    init() {
        templateUpdateList = []
        convertIdtoImg()
    }
}

// MARK: - Functions
extension TemplateViewModel {
    private func convertIdtoImg() {
        WriteAPI.shared.getTemplateList { result in
            guard let result = result, let data = result.data else { return }

            data.forEach {
                guard let imgName = self.idToImgTuple[customKey(index: $0.templateId, hasUsed: $0.hasUsed)] else { return }
                self.templateUpdateList.append(TemplateListPublisherModel(templateId: $0.templateId, templateTitle: $0.title, templateDetail: $0.shortInfo, image: UIImage(named: imgName) ?? UIImage() ))
            }
        }
    }
    private func convertTemplateInfo() {
        templateInfoList = []
        templateListDummy.forEach {
            guard let imgName = idToImgTuple[customKey(index: $0.templateId, hasUsed: true)] else { return }
            self.templateInfoList.append(TemplateInfoPublisherModel(templateId: $0.templateId, templateTitle: $0.title, info: $0.info, image: UIImage(named: imgName) ?? UIImage() ))
        }
        self.output.send(templateInfoList)
    }
}


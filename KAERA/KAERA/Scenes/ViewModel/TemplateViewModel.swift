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
        customKey(index: 0, hasUsed: true): "gem_pink_s_on",
        customKey(index: 0, hasUsed: false): "gem_pink_s_off",
        customKey(index: 1, hasUsed: true): "gem_pink_s_on",
        customKey(index: 1, hasUsed: false): "gem_pink_s_off",
        customKey(index: 2, hasUsed: true): "gem_orange_s_on",
        customKey(index: 2, hasUsed: false): "gem_orange_s_off",
        customKey(index: 3, hasUsed: true): "gem_blue_s_on",
        customKey(index: 3, hasUsed: false): "gem_blue_s_off",
        customKey(index: 4, hasUsed: true): "gem_green_s_on",
        customKey(index: 4, hasUsed: false): "gem_green_s_off",
        customKey(index: 5, hasUsed: true): "gem_yellow_s_on",
        customKey(index: 5, hasUsed: false): "gem_yellow_s_off"
    ]
    
    var templateListDummy = [
        TemplateListModel(templateId: 0, templateTitle: "모든 보석 보기", templateDetail: "그동안 캐낸 모든 보석을 볼 수 있어요", info: "어떤 질문도 던지지 않아요. 캐라 도화지에서 머릿 속 얽혀있는 고민 실타래들을 마음껏 풀어내세요!", hasUsed: true),
        TemplateListModel(templateId: 1, templateTitle: "Free Flow", templateDetail: "빈 공간을 자유롭게 채우기", info: "내가 할 수 있는 선택지를 나열해보세요. 각각 어떤 장점과 단점을 가지고 있나요? 당신의 가능성을 펼쳐 비교해 더 나은 선택을 할 수 있도록 도와줄게요.", hasUsed: true),
        TemplateListModel(templateId: 2, templateTitle: "장단점 생각하기", templateDetail: "할까? 말까? 최고의 선택을 돕는 해결사", info: "문제의 근본적인 이유를 찾아주는 3why 기법이에요. 왜?, 그래서 왜?, 그리고 왜? 숨어있는 원인을 캐내 문제를 해결할 수 있어요.", hasUsed: true),
        TemplateListModel(templateId: 3, templateTitle: "다섯번의 왜?", templateDetail: "5why 기법을 활용한 물음표 곱씹기", info: "집중해야할 단 한가지 목표를 정해보세요. 삶의 우선순위를 설계하고, 지금 집중해야 할 일은 무엇인지 찾아낼 수 있어요.", hasUsed: true),
        TemplateListModel(templateId: 4, templateTitle: "자기관리론", templateDetail: "데일카네기가 제시한 걱정 극복 글쓰기", info: "집중해야할 단 한가지 목표를 정해보세요. 삶의 우선순위를 설계하고, 지금 집중해야 할 일은 무엇인지 찾아낼 수 있어요.", hasUsed: false),
        TemplateListModel(templateId: 5, templateTitle: "단 하나의 목표", templateDetail: "One thing, 우선순위 정하기", info: "집중해야할 단 한가지 목표를 정해보세요. 삶의 우선순위를 설계하고, 지금 집중해야 할 일은 무엇인지 찾아낼 수 있어요.", hasUsed: false),
        TemplateListModel(templateId: 6, templateTitle: "땡스투 새겨보기", templateDetail: "긍정적인 힘을 만드는 감사 일기", info: "집중해야할 단 한가지 목표를 정해보세요. 삶의 우선순위를 설계하고, 지금 집중해야 할 일은 무엇인지 찾아낼 수 있어요.", hasUsed: false),
        TemplateListModel(templateId: 7, templateTitle: "10-10-10", templateDetail: "수지 웰치의 좋은 결정을 내리는 간단한 방법", info: "집중해야할 단 한가지 목표를 정해보세요. 삶의 우선순위를 설계하고, 지금 집중해야 할 일은 무엇인지 찾아낼 수 있어요.", hasUsed: false),
        TemplateListModel(templateId: 8, templateTitle: "실행력 키우기", templateDetail: "move! move! 일단 움직여, 실행론", info: "집중해야할 단 한가지 목표를 정해보세요. 삶의 우선순위를 설계하고, 지금 집중해야 할 일은 무엇인지 찾아낼 수 있어요.", hasUsed: false)
    ]
    
    var templateUpdateList: [TemplateListPublisherModel] = []
    
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
        templateListDummy.forEach {
            guard let imgName = idToImgTuple[customKey(index: $0.templateId, hasUsed: $0.hasUsed)] else { return }
            templateUpdateList.append(TemplateListPublisherModel(templateId: $0.templateId, templateTitle: $0.templateTitle, templateDetail: $0.templateDetail, image: UIImage(named: imgName) ?? UIImage() ))
        }
    }
    private func convertTemplateInfo() {
        templateInfoList = []
        templateListDummy.forEach {
            guard let imgName = idToImgTuple[customKey(index: $0.templateId, hasUsed: true)] else { return }
            self.templateInfoList.append(TemplateInfoPublisherModel(templateId: $0.templateId, templateTitle: $0.templateTitle, info: $0.info, image: UIImage(named: imgName) ?? UIImage() ))
        }
        self.output.send(templateInfoList)
    }
}


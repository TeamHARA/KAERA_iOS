//
//  TemplateViewModel.swift
//  KAERA
//
//  Created by saint on 2023/07/11.
//

import UIKit
import Combine

class TemplateViewModel {
    
    var IdtoImgTrueDict: [Int: String] = [0: "gem_pink_s_on", 1: "gem_pink_s_on", 2: "gem_orange_s_on", 3: "gem_blue_s_on", 4: "gem_green_s_on", 5: "gem_yellow_s_on", 6: "gem_red_s_on"]
    
    var IdtoImgFalseDict: [Int: String] = [0: "gem_pink_s_off", 1: "gem_pink_s_off", 2: "gem_orange_s_off", 3: "gem_blue_s_off", 4: "gem_green_s_off", 5: "gem_yellow_s_off", 6: "gem_red_s_off"]
    
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
        TemplateListModel(templateId: 0, templateTitle: "모든 보석 보기", templateDetail: "그동안 캐낸 모든 보석을 볼 수 있어요", hasUsed: true),
        TemplateListModel(templateId: 1, templateTitle: "Free Flow", templateDetail: "빈 공간을 자유롭게 채우기", hasUsed: true),
        TemplateListModel(templateId: 2, templateTitle: "장단점 생각하기", templateDetail: "할까? 말까? 최고의 선택을 돕는 해결사", hasUsed: true),
        TemplateListModel(templateId: 3, templateTitle: "다섯번의 왜?", templateDetail: "5why 기법을 활용한 물음표 곱씹기", hasUsed: true),
        TemplateListModel(templateId: 4, templateTitle: "자기관리론", templateDetail: "데일카네기가 제시한 걱정 극복 글쓰기", hasUsed: false),
        TemplateListModel(templateId: 5, templateTitle: "단 하나의 목표", templateDetail: "One thing, 우선순위 정하기", hasUsed: false),
        TemplateListModel(templateId: 6, templateTitle: "땡스투 새겨보기", templateDetail: "긍정적인 힘을 만드는 감사 일기", hasUsed: false),
        TemplateListModel(templateId: 7, templateTitle: "10-10-10", templateDetail: "수지 웰치의 좋은 결정을 내리는 간단한 방법", hasUsed: false),
        TemplateListModel(templateId: 8, templateTitle: "실행력 키우기", templateDetail: "move! move! 일단 움직여, 실행론", hasUsed: false)
    ]
    
    var templateUpdateList: [TemplateListPublisherModel] = []
    
    lazy var templateListPublisher = CurrentValueSubject<[TemplateListPublisherModel], Never>(templateUpdateList)
    
    init() {
        templateUpdateList = []
        convertIdtoImg()
    }
}

// MARK: - Functions
extension TemplateViewModel {
    private func convertIdtoImg() {
        templateListDummy.forEach {
            if $0.hasUsed == true {
                guard let imgName = idToImgTuple[customKey(index: $0.templateId, hasUsed: true)] else { return }
                templateUpdateList.append(TemplateListPublisherModel(templateId: $0.templateId, templateTitle: $0.templateTitle, templateDetail: $0.templateDetail, image: UIImage(named: imgName) ?? UIImage() ))
            }
            else {
                guard let imgName = idToImgTuple[customKey(index: $0.templateId, hasUsed: false)] else { return }
                templateUpdateList.append(TemplateListPublisherModel(templateId: $0.templateId, templateTitle: $0.templateTitle, templateDetail: $0.templateDetail, image: UIImage(named: imgName) ?? UIImage() ))
            }
            
        }
    }
}

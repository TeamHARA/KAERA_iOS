//
//  WritingWorryViewModel.swift
//  KAERA
//
//  Created by saint on 2023/08/12.
//

import UIKit
import Combine

// template Modal용
class TemplateContentViewModel: ViewModelType {
    
    private var cancellables = Set<AnyCancellable>()
    
    private var templateContent = TemplateContentModel(title: "", guideline: "", questions: [], hints: [])
    
    typealias Input = AnyPublisher<Int, Never>
    typealias Output = AnyPublisher<TemplateContentModel, Never>
    
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
        templateContent = TemplateContentModel(title: "", guideline: "", questions: [], hints: [])
        let templateContentDummy = [TemplateContentModel(title: "Free Flow", guideline: "A or B? 결정이 어렵다면, 장단점을 비교해 최선을 찾아봐요.", questions: [
            "고민의 선택지를 나열해보세요.",
            "선택지들의 장점을 생각해보세요.",
            "선택지들의 단점을 생각해보세요.",
            "장점과 단점을 비교해 최선의 방법을 찾아보세요."
          ], hints: [
            "예) 휴학하고 스펙 쌓기 vs 학교 생활하기",
            "예) 휴학: 시간을 여유롭게 활용할 수 있다\n     학교: 칼졸업 가능!",
            "예) 휴학: 비효율적인 시간 관리가 우려된다\n     학교: 취업 준비의 여유가 없다",
            "예) 휴학 기간 동안 참여할 대외활동 리스트를 세워두자"
          ]), TemplateContentModel(title: "장단점 생각하기", guideline: "A or B? 결정이 어렵다면, 장단점을 비교해 최선을 찾아봐요.", questions: [
            "고민의 선택지를 나열해보세요.",
            "선택지들의 장점을 생각해보세요.",
            "선택지들의 단점을 생각해보세요.",
            "장점과 단점을 비교해 최선의 방법을 찾아보세요."
          ], hints: [
            "예) 휴학하고 스펙 쌓기 vs 학교 생활하기",
            "예) 휴학: 시간을 여유롭게 활용할 수 있다\n     학교: 칼졸업 가능!",
            "예) 휴학: 비효율적인 시간 관리가 우려된다\n     학교: 취업 준비의 여유가 없다",
            "예) 휴학 기간 동안 참여할 대외활동 리스트를 세워두자"
          ]), TemplateContentModel(title: "세번의 왜?", guideline: "A or B? 결정이 어렵다면, 장단점을 비교해 최선을 찾아봐요.", questions: [
            "고민의 선택지를 나열해보세요.",
            "선택지들의 장점을 생각해보세요.",
            "선택지들의 단점을 생각해보세요.",
            "장점과 단점을 비교해 최선의 방법을 찾아보세요."
          ], hints: [
            "예) 휴학하고 스펙 쌓기 vs 학교 생활하기",
            "예) 휴학: 시간을 여유롭게 활용할 수 있다\n     학교: 칼졸업 가능!",
            "예) 휴학: 비효율적인 시간 관리가 우려된다\n     학교: 취업 준비의 여유가 없다",
            "예) 휴학 기간 동안 참여할 대외활동 리스트를 세워두자"
          ]), TemplateContentModel(title: "단 하나의 목표", guideline: "A or B? 결정이 어렵다면, 장단점을 비교해 최선을 찾아봐요.", questions: [
            "고민의 선택지를 나열해보세요.",
            "선택지들의 장점을 생각해보세요.",
            "선택지들의 단점을 생각해보세요.",
            "장점과 단점을 비교해 최선의 방법을 찾아보세요."
          ], hints: [
            "예) 휴학하고 스펙 쌓기 vs 학교 생활하기",
            "예) 휴학: 시간을 여유롭게 활용할 수 있다\n     학교: 칼졸업 가능!",
            "예) 휴학: 비효율적인 시간 관리가 우려된다\n     학교: 취업 준비의 여유가 없다",
            "예) 휴학 기간 동안 참여할 대외활동 리스트를 세워두자"
          ]), TemplateContentModel(title: "땡스투 새겨보기", guideline: "A or B? 결정이 어렵다면, 장단점을 비교해 최선을 찾아봐요.", questions: [
            "고민의 선택지를 나열해보세요.",
            "선택지들의 장점을 생각해보세요.",
            "선택지들의 단점을 생각해보세요.",
            "장점과 단점을 비교해 최선의 방법을 찾아보세요."
          ], hints: [
            "예) 휴학하고 스펙 쌓기 vs 학교 생활하기",
            "예) 휴학: 시간을 여유롭게 활용할 수 있다\n     학교: 칼졸업 가능!",
            "예) 휴학: 비효율적인 시간 관리가 우려된다\n     학교: 취업 준비의 여유가 없다",
            "예) 휴학 기간 동안 참여할 대외활동 리스트를 세워두자"
          ])]
        templateContent = templateContentDummy[templateId]
        output.send(templateContent)
    }
}

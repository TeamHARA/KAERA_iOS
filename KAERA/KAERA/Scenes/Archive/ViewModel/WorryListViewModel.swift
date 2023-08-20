//
//  ArchiveViewModel.swift
//  KAERA
//
//  Created by 김담인 on 2023/07/13.
//

import UIKit
import Combine

// 뷰 모델로써 데이터의 상태를 가지고 있음
class WorryListViewModel {
    
    // MARK: - Properties
    private var IdtoImgDict: [Int: String] = [1: "gem_pink_m", 2: "gem_orange_m", 3: "gem_blue_m", 4: "gem_green_m", 5: "gem_yellow_m", 6: "gem_red_m"]
    
    /// 서버에서 받아올 더미
    var worryListDummy = [
        WorryListModel(templateId: 1, templateTitle: "할 일", title: "해라 릴리즈", period: "23.02.01~23.02.02"),
        WorryListModel(templateId: 2, templateTitle: "학업", title: "이번 학기 학점", period: "23.02.02~23.02.04"),
        WorryListModel(templateId: 3, templateTitle: "일상", title: "집에 갈까 말까", period: "23.02.03~23.02.06"),
        WorryListModel(templateId: 2, templateTitle: "학업", title: "수업 드랍할까 말까?", period: "23.02.04~23.02.08"),
        WorryListModel(templateId: 4, templateTitle: "진로", title: "머 해먹고 살지,,?", period: "23.02.05~23.04.10"),
        WorryListModel(templateId: 3, templateTitle: "일상", title: "저녁 뭐먹을까?", period: "23.03.03~23.04.06"),
        WorryListModel(templateId: 1, templateTitle: "할 일", title: "컴시이실 공부하기", period: "23.03.31~23.04.20"),
        WorryListModel(templateId: 1, templateTitle: "할 일", title: "컴시이실 공부하기", period: "23.04.02~23.04.30"),
        WorryListModel(templateId: 5, templateTitle: "단 하나의 목표", title: "캐라 릴리즈", period: "23.06.30-~23.07.20"),
        WorryListModel(templateId: 6, templateTitle: "땡스투 새겨보기", title: "회사 인턴", period: "23.07.17-~23.07.30")
    ]
    
    var worryUpdateList: [WorryListPublisherModel] = []
    
    lazy var worryListPublisher = CurrentValueSubject<[WorryListPublisherModel], Never>(worryUpdateList)
    
    init() {
        worryUpdateList = []
        convertIdtoImg()
    }
    
    // MARK: - Functions
    private func convertIdtoImg() {
        worryListDummy.forEach {
            guard let imgName = IdtoImgDict[$0.templateId] else { return }
            worryUpdateList.append(WorryListPublisherModel(templateId: $0.templateId, templateTitle: $0.templateTitle, title: $0.title, period: $0.period, image: UIImage(named: imgName) ?? UIImage() ))
        }
    }
}

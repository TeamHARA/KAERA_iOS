//
//  ArchiveViewModel.swift
//  KAERA
//
//  Created by 김담인 on 2023/07/13.
//

import UIKit
import Combine

// 뷰 모델로써 데이터의 상태를 가지고 있음
final class WorryListViewModel: ViewModelType {
    
    // MARK: - Properties
    private var IdtoImgDict: [Int: String] = [1: "gem_blue_m", 2: "gem_red_m", 3: "gem_orange_m", 4: "gem_green_m", 5: "gem_pink_m", 6: "gem_yellow_m"]
    
    typealias Input = AnyPublisher<Int, Never>
    typealias Output = AnyPublisher<[WorryListPublisherModel], Error>
    
    func transform(input: AnyPublisher<Int, Never>) -> AnyPublisher<[WorryListPublisherModel], Error> {
        input
            .flatMap { templateId in
                self.getNetworkResponse(templateId: templateId)
            }
            .eraseToAnyPublisher()
    }
    
    // MARK: - Functions
    private func convertIdtoWorryList(_ data: [Worry]) -> [WorryListPublisherModel] {
        var worryList: [WorryListPublisherModel] = []
        data.forEach {
            guard let imgName = IdtoImgDict[$0.templateId] else { return }
            worryList.append(WorryListPublisherModel(worryId: $0.worryId, templateId: $0.templateId, title: $0.title, period: $0.period, image: UIImage(named: imgName) ?? UIImage() ))
        }
        return worryList
    }
    
    private func getNetworkResponse(templateId: Int) -> AnyPublisher<[WorryListPublisherModel], Error> {
        Future<[WorryListPublisherModel], Error> { promise in
            ArchiveAPI.shared.getArchiveWorryList(param: templateId) { result in
                switch result {
                case .success(let response):
                    if let data = response.data {
                        let worryList = self.convertIdtoWorryList(data.worry)
                        promise(.success(worryList))
                    } else {
                        promise(.failure(ErrorCase.appError))
                    }
                case .failure(let errorCase):
                    promise(.failure(errorCase))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}

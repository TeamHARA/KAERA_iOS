//
//  ArchiveViewModel.swift
//  KAERA
//
//  Created by 김담인 on 2023/07/13.
//

import UIKit
import Combine

// 뷰 모델로써 데이터의 상태를 가지고 있음
class WorryListViewModel: ViewModelType {
    
    // MARK: - Properties
    private var IdtoImgDict: [Int: String] = [1: "gem_blue_m", 2: "gem_red_m", 3: "gem_orange_m", 4: "gem_green_m", 5: "gem_pink_m", 6: "gem_yellow_m"]
    
    private var worryUpdateList: [WorryListPublisherModel] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    typealias Input = AnyPublisher<Int, Never>
    typealias Output = AnyPublisher<[WorryListPublisherModel], Error>
    
    private let output = PassthroughSubject<[WorryListPublisherModel], Error> ()
    
    func transform(input: Input) -> AnyPublisher<[WorryListPublisherModel], Error> {
        input.sink{[weak self] templateId in
            self?.getNetworkResponse(templateId)
        }
        .store(in: &cancellables)
        
        return output.eraseToAnyPublisher()
    }
    
    // MARK: - Functions
    private func convertIdtoWorryList(_ data: [Worry]) {
        worryUpdateList = []
        data.forEach {
            guard let imgName = IdtoImgDict[$0.templateId] else { return }
            worryUpdateList.append(WorryListPublisherModel(worryId: $0.worryId, templateId: $0.templateId, title: $0.title, period: $0.period, image: UIImage(named: imgName) ?? UIImage() ))
        }
        self.output.send(worryUpdateList)
    }
    
    private func getNetworkResponse(_ templateId: Int) {
        ArchiveAPI.shared.getArchiveWorryList(param: templateId) { result in
            guard let result = result, let data = result.data else {
                self.output.send(completion: .failure(NSError()))
                return
            }
            self.convertIdtoWorryList(data.worry)
        }
    }
}

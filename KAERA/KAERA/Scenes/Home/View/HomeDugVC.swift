//
//  DugVC.swift
//  KAERA
//
//  Created by 김담인 on 2023/07/11.
//

import UIKit
import Combine
import SnapKit

class HomeDugVC: BaseVC {
    
    // MARK: - Properties
    private let gemListViewModel = HomeGemListViewModel()
    private var cancellables = Set<AnyCancellable>()
    private let input = PassthroughSubject<Bool, Never>.init()
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .kGray1
        dataBind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("send in Dug")
        input.send(true)
    }
    
    private func dataBind() {
        let output = gemListViewModel.transform(
            input: HomeGemListViewModel
                .Input(isSolved: input.eraseToAnyPublisher())
        )
        output.dataList.receive(on: DispatchQueue.main)
            .sink { [weak self] list in
                self?.updateUI(gemList: list)
            }.store(in: &cancellables)
    }
    
    private func updateUI(gemList: [HomeGemListModel]) {
        print("Dug 업데이트 UI")
        print(gemList)
    }
}

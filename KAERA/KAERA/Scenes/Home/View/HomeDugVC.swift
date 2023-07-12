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
    let homeHeaderView = HomeHederView(type: .dug)
    private let gemListViewModel = HomeGemListViewModel()
    private var cancellables = Set<AnyCancellable>()
    private let input = PassthroughSubject<Bool, Never>.init()
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .kGray1
        setLayout()
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

// MARK: - UI
extension HomeDugVC {
    private func setLayout() {
        self.navigationController?.isNavigationBarHidden = true
        self.view.addSubviews([homeHeaderView])
        homeHeaderView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(58)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(76)
            $0.width.equalTo(178)
        }
    }
}

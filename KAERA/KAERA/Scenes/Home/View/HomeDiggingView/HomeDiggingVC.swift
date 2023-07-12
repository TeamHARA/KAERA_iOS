//
//  HomeVC.swift
//  KAERA
//
//  Created by saint on 2023/07/09.
//

import UIKit
import Combine
import SnapKit
import Then

class HomeDiggingVC: BaseVC {
    
    // MARK: - Properties
    private let homeHeaderView = HomeHederView(type: .digging)
    private let gemListViewModel = HomeGemListViewModel()
    private var cancellables = Set<AnyCancellable>()
    private let input = PassthroughSubject<Bool, Never>.init()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .kGray1
        setLayout()
        dataBind()
    }
    override func viewWillAppear(_ animated: Bool) {
        print("send in DiggingView")
        input.send(false)
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
        print("Digging 업데이트 UI")
        print(gemList)
    }
}

// MARK: - UI
extension HomeDiggingVC {
    private func setLayout() {
        self.view.addSubviews([homeHeaderView])
        
        homeHeaderView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(58)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(76)
            $0.width.equalTo(162)
        }
    }
}


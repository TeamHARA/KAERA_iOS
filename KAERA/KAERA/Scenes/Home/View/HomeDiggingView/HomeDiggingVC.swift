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
    private let gemListViewModel = HomeGemListViewModel()
    private var cancellables = Set<AnyCancellable>()
    private let input = PassthroughSubject<Bool, Never>.init()
    
    /// 뷰에 들어갈 데이터가 초기화된 12개의 커스텀 뷰배열을 만들고
    /// 서버에서 받은 데이터 만큼만 해당 뷰 배열에 업데이트하고
    /// 로직은 그대로 12개를 위치에 뷰 업데이트 ( 겉으로는 안보이지만 빈뷰가 있는 구조)
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .kGray1
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

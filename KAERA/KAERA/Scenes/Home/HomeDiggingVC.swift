//
//  HomeVC.swift
//  KAERA
//
//  Created by saint on 2023/07/09.
//

import UIKit
import SnapKit

class HomeDiggingVC: BaseVC {
    
    // MARK: - Properties
    let homeHeaderView = HomeHederView(type: .digging)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .kGray1
        setLayout()
    }
}

// MARK: - UI
extension HomeDiggingVC {
    private func setLayout() {
        self.view.addSubview(homeHeaderView)
        homeHeaderView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(58)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(76)
            $0.width.equalTo(162)
        }
    }
}


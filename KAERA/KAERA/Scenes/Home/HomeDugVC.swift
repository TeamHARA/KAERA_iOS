//
//  DugVC.swift
//  KAERA
//
//  Created by 김담인 on 2023/07/11.
//

import UIKit
import SnapKit

class HomeDugVC: BaseVC {
    
    // MARK: - Properties
    let homeHeaderView = HomeHederView(type: .dug)

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .kGray1
        self.navigationController?.isNavigationBarHidden = true
        setLayout()
    }
}

// MARK: - UI
extension HomeDugVC {
    private func setLayout() {
        self.view.addSubview(homeHeaderView)
        homeHeaderView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(58)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(76)
            $0.width.equalTo(178)
        }
    }
}

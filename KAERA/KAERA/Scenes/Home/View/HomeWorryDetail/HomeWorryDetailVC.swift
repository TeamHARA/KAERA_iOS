//
//  HomeWorryDetailVC.swift
//  KAERA
//
//  Created by 김담인 on 2023/07/21.
//

import UIKit
import SnapKit

final class HomeWorryDetailVC: UIViewController {
    
    // MARK: - Properties
    private let navigationBarView = CustomNavigationBarView(leftType: .close, rightType: .edit, title: "고민캐기")
    private var deadLineDays = 1
    
    // MARK: - Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .kGray1
        setLayout()
        setNaviButtonAction()
        /// 서버에서 넘어오는 데드라인 값을 넣어 실행
        navigationBarView.setTitleText(text: "고민캐기 D-\(deadLineDays)")
    }
    
    // MARK: - Function
    private func setNaviButtonAction() {
        navigationBarView.setLeftButtonAction {
            self.dismiss(animated: true, completion: nil)
        }
        
        navigationBarView.setRightButtonAction {
            /// edit 창 띄우기
        }
    }
    
}

// MARK: - UI
extension HomeWorryDetailVC {
    private func setLayout() {
        self.view.addSubviews([navigationBarView])
        
        navigationBarView.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(16)
            $0.top.equalToSuperview().inset(70)
            $0.height.equalTo(24)
        }
    }
}

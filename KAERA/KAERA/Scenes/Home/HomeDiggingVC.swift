//
//  HomeVC.swift
//  KAERA
//
//  Created by saint on 2023/07/09.
//

import UIKit
import SnapKit

class HomeDiggingVC: BaseVC {
    
    let homeHeaderView = HomeHederView(type: .digging)
    let dugVC = HomeDugVC()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .kGray1
        setLayout()
        setSwipeGesture()
    }
    
    private func setSwipeGesture() {
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture(_:)))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        self.view.addGestureRecognizer(swipeLeft)
    }
    
    // 한 손가락 스와이프 제스쳐를 행했을 때 실행할 액션 메서드
    @objc func respondToSwipeGesture(_ gesture: UISwipeGestureRecognizer) {
        if (gesture.direction == .left) {
            self.navigationController?.pushViewController(dugVC, animated: true)
        }
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


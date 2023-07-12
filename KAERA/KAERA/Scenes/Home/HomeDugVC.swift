//
//  DugVC.swift
//  KAERA
//
//  Created by 김담인 on 2023/07/11.
//

import UIKit
import SnapKit

class HomeDugVC: BaseVC {
    
    let homeHeaderView = HomeHederView(type: .dug)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .kGray1
        self.navigationController?.isNavigationBarHidden = true
        setLayout()
        setSwipeGesture()
    }

    private func setSwipeGesture() {
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture(_:)))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipeRight)
    }
    
    // 한 손가락 스와이프 제스쳐를 행했을 때 실행할 액션 메서드
    @objc func respondToSwipeGesture(_ gesture: UISwipeGestureRecognizer) {
        if (gesture.direction == .right) {
            self.navigationController?.popToRootViewController(animated: true)
        }
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

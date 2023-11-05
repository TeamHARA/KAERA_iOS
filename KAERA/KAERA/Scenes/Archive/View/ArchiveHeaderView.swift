//
//  ArchiveHeaderView.swift
//  KAERA
//
//  Created by saint on 2023/07/13.
//

import UIKit
import SnapKit
import Then

final class ArchiveHeaderView: UIView {
    
    // MARK: - Properties
    private let navigationBarView = CustomNavigationBarView(leftType: .info, rightType: .myPage, title: "보석고민함")
    
    private let numLabel = UILabel().then {
        $0.text = "총 n개"
        $0.textColor = .white
        $0.font = .kB4R14
    }
    
    private let sortBtn = UIButton().then {
        $0.backgroundColor = .kGray2
        $0.layer.cornerRadius = 10
        $0.titleLabel?.font = .kB4R14
        $0.setTitle("모든 보석 보기", for: .normal)
        $0.setTitleColor(.kYellow2, for: .normal)
    }
    
    private let toggleBtn = UIImageView().then {
        $0.image = UIImage(named: "icn_toggle_down")
        $0.contentMode = .scaleToFill
        $0.backgroundColor = .clear
    }
    
    // MARK: - View Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLeftButtonPressAction(completion: @escaping () -> ()) {
        navigationBarView.setLeftButtonAction {
            completion()
        }
    }
    
    func setRightButtonPressAction(completion: @escaping () -> ()) {
        navigationBarView.setRightButtonAction {
            completion()
        }
    }
    
    func setSortButtonPressAction(completion: @escaping () -> ()) {
        sortBtn.press {
            completion()
        }
    }
    
    func setSortButtonTitle(title: String) {
        sortBtn.setTitle(title, for: .normal)
    }
    
    func setNumLabelText(text: String) {
        numLabel.text = text
    }
}

// MARK: - Layout
extension ArchiveHeaderView{
    private func setLayout() {
        self.backgroundColor = .clear
        self.addSubViews([navigationBarView, sortBtn, numLabel, toggleBtn])

        navigationBarView.snp.makeConstraints {
            $0.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(16)
            $0.top.equalTo(self.safeAreaLayoutGuide).inset(20)
            $0.height.equalTo(24.adjustedH)
        }
        
        sortBtn.snp.makeConstraints {
            $0.top.equalTo(navigationBarView.snp.bottom).offset(25)
            $0.leading.equalToSuperview().offset(16.adjustedW)
            $0.trailing.equalToSuperview().offset(-16.adjustedW)
            $0.height.equalTo(32.adjustedW)
        }
        
        numLabel.snp.makeConstraints {
            $0.top.equalTo(sortBtn.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(16.adjustedW)
        }
        
        toggleBtn.snp.makeConstraints {
            $0.trailing.equalTo(sortBtn.snp.trailing).offset(-16.adjustedW)
            $0.centerY.equalTo(sortBtn.snp.centerY)
            $0.width.equalTo(24.adjustedW)
            $0.height.equalTo(24.adjustedW)
        }
    }
}

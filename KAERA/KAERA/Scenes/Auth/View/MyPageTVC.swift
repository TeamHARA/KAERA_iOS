//
//  MyPageTVC.swift
//  KAERA
//
//  Created by 김담인 on 2023/10/17.
//

import UIKit
import SnapKit
import SafariServices

final class MyPageTVC: UITableViewCell {
    
    // MARK: - Components
    private let titleButton: UIButton = {
        let btn = UIButton()
        btn.titleLabel?.font = .kB2R16
        btn.setTitleColor(.kWhite, for: .normal)
        return btn
    }()
    
    private let cellButton = UIButton()
    
    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateCellContent(titleText: String, buttonType: MyPageButtonType) {
        self.titleButton.setTitle(titleText, for: .normal)
        if titleText == "계정탈퇴" {
            titleButton.setTitleColor(.kGray4, for: .normal)
        }else {
            titleButton.setTitleColor(.kWhite, for: .normal)
        }
        
        switch buttonType {
        case .push:
            self.cellButton.setImage(UIImage(named:"icn_btn_off"), for: .normal)
            self.cellButton.setImage(UIImage(named:"icn_btn_on"), for: .selected)
            self.cellButton.isSelected = PushSettingInfo.shared.isPushOn
        case .next:
            self.cellButton.setImage(UIImage(named:"icn_next"), for: .normal)
        case .account:
            self.cellButton.setImage(UIImage(named:""), for: .normal)
        }
    }
    
    func setPushButtonAction() {
        cellButton.press { [weak self] in
            self?.goToSetting()
        }
    }
    /// 설정 페이지 열기
    private func goToSetting() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    func setNextButtonAction(completion: @escaping () -> ()) {
        cellButton.press { 
            completion()
        }
    }
    
    func setAccountButtonAction(completion: @escaping () -> ()) {
        titleButton.press {
            completion()
        }
    }
    
    func clearButtonState() {
        self.cellButton.isSelected = false
        self.titleButton.isSelected = false
        self.cellButton.removeTarget(nil, action: nil, for: .allTouchEvents)
        self.titleButton.removeTarget(nil, action: nil, for: .allTouchEvents)
    }
}

// MARK: - UI
extension MyPageTVC {
    private func setLayout() {
        self.backgroundColor = .clear
        contentView.addSubviews([titleButton, cellButton])
        
        titleButton.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(17)
            $0.centerY.equalToSuperview()
        }
        
        cellButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(15)
            $0.centerY.equalToSuperview()
        }
    }
}

//
//  MyPageTVC.swift
//  KAERA
//
//  Created by 김담인 on 2023/10/17.
//

import UIKit
import SnapKit

final class MyPageTVC: UITableViewCell {
    
    // MARK: - Components
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .kB2R16
        label.textColor = .kWhite
        return label
    }()
    
   let cellButton = UIButton()
    

    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
            
    func configureCell(labelText: String, buttonType: MyPageButtonType ) {
        self.cellButton.isSelected = false
        self.titleLabel.text = labelText
        if labelText == "계정탈퇴" {
            titleLabel.textColor = .kGray4
        }else {
            titleLabel.textColor = .kWhite
        }
        
        switch buttonType {
        case .push:
            setPushButton()
        case .next:
            setNextButton()
        case .none:
            setNoneButton()
        }
    }
    
    private func setPushButton() {
        self.cellButton.setImage(UIImage(named:"icn_btn_off"), for: .normal)
        self.cellButton.setImage(UIImage(named:"icn_btn_on"), for: .selected)
        self.cellButton.isSelected = PushSettingInfo.shared.isPushOn
        
        cellButton.press {
            self.goToSetting()
        }
    }
    /// 설정 페이지 열기
    private func goToSetting() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
   
    private func setNextButton() {
        self.cellButton.setImage(UIImage(named:"icn_next"), for: .normal)
    }
    
    private func setNoneButton() {
        self.cellButton.setImage(UIImage(named:""), for: .normal)

    }
    
    func removeButtonTarget() {
        self.cellButton.removeTarget(nil, action: nil, for: .allTouchEvents)
    }


}

// MARK: - UI
extension MyPageTVC {
    private func setLayout() {
        self.backgroundColor = .clear
        contentView.addSubviews([titleLabel, cellButton])
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(17)
            $0.centerY.equalToSuperview()
        }
        
        cellButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(15)
            $0.centerY.equalToSuperview()
        }
    }
}

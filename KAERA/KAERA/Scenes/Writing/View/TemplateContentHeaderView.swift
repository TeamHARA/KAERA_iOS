//
//  TemplateContentHeaderView.swift
//  KAERA
//
//  Created by saint on 2023/08/13.
//

import UIKit
import SnapKit
import Then

final class TemplateContentHeaderView: UITableViewHeaderFooterView {
    
    // MARK: - Properties
    private let worryTitleTextField = UITextField().then{
        $0.layer.cornerRadius = 8
        $0.backgroundColor = .clear
        $0.textColor = .kGray4
        $0.font = .kB2R16
        $0.addLeftPadding(16)
        
        // Placeholder 색상 설정
        let placeholderText = "고민에 이름을 붙여주세요"
        let placeholderColor = UIColor.kGray4
        $0.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: [NSAttributedString.Key.foregroundColor: placeholderColor])
    }
    
    private let dividingLine = UIView().then {
        $0.backgroundColor = .kGray3
    }
    
    // MARK: - Initialization
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Function
    private func setLayout() {
        self.contentView.addSubviews([worryTitleTextField, dividingLine])
        
        worryTitleTextField.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.width.equalTo(200.adjustedW)
            $0.height.equalTo(73.adjustedW)
        }

        dividingLine.snp.makeConstraints {
            $0.top.equalTo(worryTitleTextField.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1.adjustedW)
        }
    }
    
}






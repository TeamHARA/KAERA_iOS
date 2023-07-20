//
//  GemStoneEmptyView.swift
//  KAERA
//
//  Created by 김담인 on 2023/07/20.
//

import UIKit
import SnapKit
import Then

final class GemStoneEmptyView: UIView {
    
    // MARK: - Properties
    private let noTemplateImageView = UIImageView().then {
        $0.image = UIImage(named: "gem_no_template")
    }
    
    private let mainTitleLabel = UILabel().then {
        $0.font = .kH3B18
        $0.textColor = .kWhite
    }
    
    private let subTitleLabel = UILabel().then {
        $0.font = .kB5R14W
        $0.textColor = .kGray4
        $0.numberOfLines = 0
    }
    
    // MARK: - Initialization
    init(mainTitle: String, subTitle: String) {
        super.init(frame: .zero)
        setLayout()
        setLabelText(mainTitle: mainTitle, subTtitle: subTitle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Function
    private func setLabelText(mainTitle: String, subTtitle: String) {
        mainTitleLabel.text = mainTitle
        subTitleLabel.text = subTtitle
        subTitleLabel.addLabelSpacing(kernValue: -0.5, lineSpacing: 15)
    }
    
    func setEmptyImage(name: String) {
        noTemplateImageView.image = UIImage(named: name)
    }
    
    private func setLayout() {
        self.addSubviews([noTemplateImageView, mainTitleLabel, subTitleLabel])
        
        noTemplateImageView.snp.makeConstraints {
            $0.top.centerX.equalToSuperview()
        }
        
        mainTitleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(noTemplateImageView.snp.bottom).offset(24)
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(mainTitleLabel.snp.bottom).offset(14)
        }
    }
    
    
}

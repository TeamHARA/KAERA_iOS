//
//  ArchiveHeaderView.swift
//  KAERA
//
//  Created by saint on 2023/07/13.
//

import UIKit
import SnapKit
import Then

// MARK: - ArchiveHeaderView
class ArchiveHeaderView: UIView {
    
    // MARK: - UI Components
    private let titleLabel = UILabel().then{
        $0.text = "보석고민함"
        $0.textColor = .white
        $0.font = .kH1B20
    }
    
    private let templateInfo = UIImageView().then {
        $0.image = UIImage(named: "icn_template_info")
        $0.contentMode = .scaleToFill
        $0.backgroundColor = .clear
    }
    
    private let myPage = UIImageView().then {
        $0.image = UIImage(named: "icn_mypage")
        $0.contentMode = .scaleToFill
        $0.backgroundColor = .clear
    }
    
    let numLabel = UILabel().then {
        $0.text = "총 n개"
        $0.textColor = .white
        $0.font = .kB4R14
    }
    
    let sortBtn = UIButton().then {
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
}

extension ArchiveHeaderView{
    func setLayout(){
        self.backgroundColor = .clear
        self.addSubViews([titleLabel, templateInfo, myPage, sortBtn, numLabel, toggleBtn])
        
        titleLabel.snp.makeConstraints{
            $0.top.equalToSuperview().offset(24.adjustedW)
            $0.centerX.equalToSuperview()
        }
        
        templateInfo.snp.makeConstraints{
            $0.top.equalToSuperview().offset(25.adjustedW)
            $0.leading.equalToSuperview().offset(16.adjustedW)
            $0.width.equalTo(28)
            $0.height.equalTo(28)
        }
        
        myPage.snp.makeConstraints{
            $0.centerY.equalTo(titleLabel.snp.centerY)
            $0.trailing.equalToSuperview().offset(-16.adjustedW)
            $0.width.equalTo(24)
            $0.height.equalTo(24)
        }
        
        sortBtn.snp.makeConstraints{
            $0.top.equalTo(titleLabel.snp.bottom).offset(25)
            $0.leading.equalToSuperview().offset(16.adjustedW)
            $0.trailing.equalToSuperview().offset(-16.adjustedW)
            $0.height.equalTo(32.adjustedW)
        }
        
        numLabel.snp.makeConstraints{
            $0.top.equalTo(sortBtn.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(16.adjustedW)
        }
        
        toggleBtn.snp.makeConstraints{
            $0.trailing.equalTo(sortBtn.snp.trailing).offset(-24.adjustedW)
            $0.centerY.equalTo(sortBtn.snp.centerY)
            $0.width.equalTo(24.adjustedW)
            $0.height.equalTo(24.adjustedW)
        }
    }
}

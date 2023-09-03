//
//  StorageModalVC.swift
//  KAERA
//
//  Created by saint on 2023/07/13.
//

import UIKit
import SnapKit
import Then


class ArchiveModalCVC: UICollectionViewCell {
    
    let templateCell = UIView().then {
        $0.backgroundColor = .clear
        $0.layer.cornerRadius = 8
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.kGray5.cgColor
    }
    
    private let templateImage = UIImageView().then {
        $0.image = UIImage(named: "jewel")
        $0.backgroundColor = .clear
    }
    
    private let templateTitle = UILabel().then {
        $0.font = .kB4R14
        $0.textColor = .white
    }
    
    private let templateDetail = UILabel().then {
        $0.font = .kSb1R12
        $0.textColor = .kGray4
    }
    
    let checkIcon = UIImageView().then {
        $0.image = UIImage(named: "icn_check")
        $0.backgroundColor = .clear
        $0.isHidden = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ArchiveModalCVC{
    
    // MARK: - Layout
    private func setLayout() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        contentView.addSubview(templateCell)
        
        templateCell.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        templateCell.addSubviews([templateImage, templateTitle, templateDetail, checkIcon])
        
        templateImage.snp.makeConstraints {
            $0.width.height.equalTo(46.adjustedW)
            $0.leading.equalToSuperview().offset(10.adjustedW)
            $0.centerY.equalToSuperview()
        }
        
        templateTitle.snp.makeConstraints {
            $0.leading.equalTo(templateImage.snp.trailing).offset(8.adjustedW)
            $0.top.equalToSuperview().offset(19.adjustedW)
        }
        
        templateDetail.snp.makeConstraints {
            $0.leading.equalTo(templateTitle.snp.leading)
            $0.top.equalTo(templateTitle.snp.bottom).offset(4.adjustedW)
        }
        
        checkIcon.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-20.adjustedW)
            $0.width.height.equalTo(26.adjustedW)
        }
    }
    
    // MARK: - DataBind
    func dataBind(model: TemplateInfoPublisherModel, indexPath: IndexPath) {
        templateImage.image = model.image
        templateTitle.text = model.templateTitle
        templateDetail.text = model.templateDetail
        
        if indexPath.row == 0 {
            // 보석 이미지를 숨김
            templateImage.isHidden = true
            
            // 제목과 상세설명을 왼쪽으로 이동
            templateTitle.snp.remakeConstraints {
                $0.leading.equalToSuperview().offset(14.adjustedW)
                $0.top.equalToSuperview().offset(19.adjustedW)
            }
            
            templateDetail.snp.remakeConstraints {
                $0.leading.equalToSuperview().offset(14.adjustedW)
                $0.top.equalTo(templateTitle.snp.bottom).offset(4.adjustedW)
            }
        } else {
            // 보석 이미지를 보이게 함
            templateImage.isHidden = false
            
            // 제목과 상세설명의 위치를 원래대로 되돌림
            templateTitle.snp.remakeConstraints {
                $0.leading.equalTo(templateImage.snp.trailing).offset(8.adjustedW)
                $0.top.equalToSuperview().offset(19.adjustedW)
            }
            
            templateDetail.snp.remakeConstraints {
                $0.leading.equalTo(templateTitle.snp.leading)
                $0.top.equalTo(templateTitle.snp.bottom).offset(4.adjustedW)
            }
        }
    }
}



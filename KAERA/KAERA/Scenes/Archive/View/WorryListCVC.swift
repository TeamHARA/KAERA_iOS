//
//  WorryListCVC.swift
//  KAERA
//
//  Created by saint on 2023/07/13.
//

import UIKit
import SnapKit
import Then

class WorryListCVC: UICollectionViewCell {
    
    // MARK: - Properties
    private let worryCell = UIImageView().then {
        $0.image = UIImage(named: "framebg")
        $0.backgroundColor = .clear
    }
    
    private let jewelImage = UIImageView().then {
        $0.image = UIImage(named: "jewel")
        $0.backgroundColor = .clear
    }
    
    private let worryTitle = UILabel().then {
        $0.text = "고민 제목입니당"
        $0.font = .kB3B14
        $0.textColor = .white
    }
    
    private let divLine = UIImageView().then {
        $0.image = UIImage(named: "icn_div_line")
        $0.backgroundColor = .clear
    }

    private let worryDate = UILabel().then {
        $0.text = "2023.02.10~2023.04.01"
        $0.font = .kSb1R12
        $0.textColor = .kGray4
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Layout
extension WorryListCVC {
    private func setLayout() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        contentView.addSubview(worryCell)
        
        worryCell.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        worryCell.addSubviews([jewelImage, worryTitle, divLine, worryDate])
        
        jewelImage.snp.makeConstraints {
            $0.width.height.equalTo(80.adjustedW)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(8.adjustedW)
        }
        
        worryTitle.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(jewelImage.snp.bottom).offset(10.adjustedW)
        }
        
        divLine.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(worryTitle.snp.bottom).offset(8.adjustedW)
            $0.width.equalTo(140.adjustedW)
            $0.height.equalTo(5)
        }
        
        worryDate.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(divLine.snp.bottom).offset(8.adjustedW)
        }
    }
}

// MARK: - Function(DataBinding)
extension WorryListCVC {
    func dataBind(model: WorryListPublisherModel) {
        jewelImage.image = model.image
        worryTitle.text = model.title
        worryDate.text = model.period
    }
}

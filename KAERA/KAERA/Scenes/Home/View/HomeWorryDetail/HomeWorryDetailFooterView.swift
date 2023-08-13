//
//  HomeWorryDetailFooterView.swift
//  KAERA
//
//  Created by 김담인 on 2023/07/23.
//

import UIKit
import SnapKit
import Then

final class HomeWorryDetailFooterView: UITableViewHeaderFooterView {
    
    private let writtenDateLabel = UILabel().then {
        $0.textColor = .kGray5
        $0.font = .kSb1R12
        $0.text = "작성일 2019.09.01"
    }
    
    private let seperateLeft = UIImageView().then {
        $0.image = UIImage(named: "seperate_left")
    }
    private let seperateRight = UIImageView().then {
        $0.image = UIImage(named: "seperate_right")
    }
    private let answerHeader = UILabel().then {
        $0.text = "내가 내린 답은"
        $0.font = .kB2R16
        $0.textColor = .kYellow2
    }
    
    private let headerView = UIView()
    
    private let answerLabel = UILabel().then {
        $0.font = .kB2R16
        $0.textColor = .kWhite
        $0.textAlignment = .center
        $0.text = "내가 내린 답은 이거임"
    }
        
    // MARK: - Initialization
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Function
    func setData(updateAt: String) {
        writtenDateLabel.text = updateAt
    }
    
    func setDiggingLayout() {
        self.contentView.addSubview(writtenDateLabel)
        
        writtenDateLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.trailing.equalToSuperview().inset(14)
            $0.bottom.equalToSuperview().inset(72.adjustedH)
        }
    }
    
    func setDugLayout() {
        headerView.addSubviews([seperateLeft, answerHeader, seperateRight])
        seperateLeft.snp.makeConstraints {
            $0.leading.centerY.equalToSuperview()
            $0.width.equalTo(98.adjustedW)
        }
        answerHeader.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        seperateRight.snp.makeConstraints {
            $0.trailing.centerY.equalToSuperview()
            $0.width.equalTo(98.adjustedW)
        }
        
        self.contentView.addSubviews([headerView, answerLabel])
        
        headerView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.directionalHorizontalEdges.equalToSuperview().inset(14)
            $0.height.equalTo(18)
        }
        
        answerLabel.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom).offset(21)
            $0.directionalHorizontalEdges.equalToSuperview().inset(14)
            $0.bottom.equalToSuperview().inset(40)
        }
    }
}

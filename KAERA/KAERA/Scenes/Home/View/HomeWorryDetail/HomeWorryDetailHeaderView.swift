//
//  HomeWorryDetailHeaderView.swift
//  KAERA
//
//  Created by 김담인 on 2023/07/22.
//

import UIKit
import SnapKit
import Then

final class HomeWorryDetailHeaderView: UITableViewHeaderFooterView {
    
    // MARK: - Properties
    private let gemStoneImageView = UIImageView().then {
        $0.image = UIImage(named: "gemstone_blue")
    }
    
    private let worryTitle = UILabel().then {
        $0.textColor = .kWhite
        $0.font = .kH3B18
        $0.text = "고민 제목"
        $0.textAlignment = .center
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
        self.contentView.addSubviews([gemStoneImageView, worryTitle])
        
        gemStoneImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(15)
            $0.height.width.equalTo(80.adjustedH)
        }
        
        worryTitle.snp.makeConstraints {
            $0.top.equalTo(gemStoneImageView.snp.bottom).offset(24)
            $0.centerX.equalToSuperview()
        }
    }
    
}

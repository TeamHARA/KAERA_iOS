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
    
    // MARK: - Initialization
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Function
    func setData(updateAt: String) {
        writtenDateLabel.text = updateAt
    }
    
    private func setLayout() {
        self.contentView.addSubview(writtenDateLabel)
        
        writtenDateLabel.snp.makeConstraints {
            $0.top.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(72.adjustedH)
        }
    }
    
    
}

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
    
    private let worryPeriod = UILabel().then {
        $0.font = .kSb1R12
        $0.textColor = .kGray4
    }
    
    struct DictionaryKey: Hashable {
        let templateId: Int
        let type: PageType
    }
    
    private let gemStoneDictionary: [DictionaryKey : String] = [
        DictionaryKey(templateId: 1, type: .digging) : "gemstone_blue",
        DictionaryKey(templateId: 2, type: .digging) : "gemstone_red",
        DictionaryKey(templateId: 3, type: .digging) : "gemstone_orange",
        DictionaryKey(templateId: 4, type: .digging) : "gemstone_green",
        DictionaryKey(templateId: 5, type: .digging) : "gemstone_pink",
        DictionaryKey(templateId: 6, type: .digging) : "gemstone_yellow",
        DictionaryKey(templateId: 1, type: .dug) : "gem_blue_l",
        DictionaryKey(templateId: 2, type: .dug) : "gem_red_l",
        DictionaryKey(templateId: 3, type: .dug) : "gem_orange_l",
        DictionaryKey(templateId: 4, type: .dug) : "gem_green_l",
        DictionaryKey(templateId: 5, type: .dug) : "gem_pink_l",
        DictionaryKey(templateId: 6, type: .dug) : "gem_yellow_l"
    ]
    
    
    // MARK: - Initialization
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Function
    func setData(templateId: Int, title: String, type: PageType, period: String) {
        worryTitle.text = title
        if let imgName = gemStoneDictionary[DictionaryKey(templateId: templateId, type: type)] {
            gemStoneImageView.image = UIImage(named: imgName)
        }
        switch type {
        case .digging:
            setDiggingLayout()
        case .dug:
            setDugLayout()
            worryPeriod.text = period
        }
    }
    
    private func setLayout() {
        self.contentView.addSubview(gemStoneImageView)
        
        gemStoneImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(26)
            $0.height.width.equalTo(80.adjustedH)
        }
    }
    
    private func setDiggingLayout() {
        self.contentView.addSubview(worryTitle)
        
        worryTitle.snp.makeConstraints {
            $0.top.equalTo(gemStoneImageView.snp.bottom).offset(27)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(22)
        }
    }
    
    private func setDugLayout() {
        self.contentView.addSubviews([worryTitle, worryPeriod])
        
        worryTitle.snp.makeConstraints {
            $0.top.equalTo(gemStoneImageView.snp.bottom).offset(27)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(20)
        }
        
        worryPeriod.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(worryTitle.snp.bottom).offset(9)
            $0.bottom.equalToSuperview().inset(36)
        }
    }
    
}

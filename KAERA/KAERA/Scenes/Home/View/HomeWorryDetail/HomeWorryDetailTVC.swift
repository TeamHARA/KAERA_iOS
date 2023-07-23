//
//  HomeWorryDetailTVC.swift
//  KAERA
//
//  Created by 김담인 on 2023/07/21.
//

import UIKit
import SnapKit
import Then

final class HomeWorryDetailTVC: UITableViewCell {
    
    private let worryTitle = UILabel().then {
        $0.text = "고민 제목"
        $0.textColor = .kGray5
        $0.font = .kB2R16
    }
    
    private let worryContent = UILabel().then {
        $0.font = .kB4R14
        $0.textColor = .kWhite
        $0.numberOfLines = 0
        $0.lineBreakMode = .byTruncatingTail
        $0.lineBreakStrategy = .hangulWordPriority
    }
    
    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        self.selectionStyle = .none
        setContentText(text: "")
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setContentText(text: String) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = worryContent.font.lineHeight * 0.5 // 폰트 높이의 150%인 줄 간격을 설정합니다.
        let attributedText = NSAttributedString(
            string: "내가 선택한 방법을 적어봅시다.내가 선택한 방법을 적어봅시다.내가 선택한 방법을 적어봅시다.내가 선택한 방법을 적어봅시다.",
            attributes: [
                .paragraphStyle: paragraphStyle,
            ]
        )
        
        worryContent.attributedText = attributedText
        worryContent.sizeToFit()
    }
    
}
// MARK: - UI
extension HomeWorryDetailTVC {
    private func setLayout() {
        contentView.addSubviews([worryTitle, worryContent])
        
        worryTitle.snp.makeConstraints {
            $0.top.directionalHorizontalEdges.equalToSuperview()
        }
        
        worryContent.snp.makeConstraints {
            $0.top.equalTo(worryTitle.snp.bottom).offset(12)
            $0.directionalHorizontalEdges.equalToSuperview()
        }
    }
}

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
    
    private let worryQuestion = UILabel().then {
        $0.text = "고민 제목"
        $0.textColor = .kGray5
        $0.font = .kB2R16
    }
    
    private let worryAnswer = UILabel().then {
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
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setData(question: String, answer: String) {
        worryQuestion.text = question
        setAnswerTextStyle(text: answer)
    }
    
    private func setAnswerTextStyle(text: String) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = worryAnswer.font.lineHeight * 0.5 // 폰트 높이의 150%인 줄 간격을 설정합니다.
        let attributedText = NSAttributedString(
            string: text,
            attributes: [
                .paragraphStyle: paragraphStyle,
            ]
        )
        
        worryAnswer.attributedText = attributedText
        worryAnswer.sizeToFit()
    }
    
}
// MARK: - UI
extension HomeWorryDetailTVC {
    private func setLayout() {
        contentView.addSubviews([worryQuestion, worryAnswer])
        
        worryQuestion.snp.makeConstraints {
            $0.top.directionalHorizontalEdges.equalToSuperview()
        }
        
        worryAnswer.snp.makeConstraints {
            $0.top.equalTo(worryQuestion.snp.bottom).offset(12)
            $0.directionalHorizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview().inset(28.adjustedH)
        }
    }
}

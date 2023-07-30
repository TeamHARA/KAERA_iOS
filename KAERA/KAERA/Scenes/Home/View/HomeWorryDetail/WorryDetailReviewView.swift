//
//  WorryDetailReviewView.swift
//  KAERA
//
//  Created by 김담인 on 2023/07/29.
//

import UIKit
import SnapKit
import Then

final class WorryDetailReviewView: UIView {
    
    private let reviewTitle = UILabel().then {
        $0.textColor = .kWhite
        let text = "이 고민 이후 나의 기록"
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(.foregroundColor,
                                      value: UIColor.kYellow2,
                                      range: (text as NSString).range(of: "나의 기록"))
        $0.attributedText = attributedString
    }

    let reviewTextView = UITextView().then {
        $0.textColor = .kGray5
        $0.font = .kSb2R12W
        $0.backgroundColor = .clear
        $0.isScrollEnabled = false
        $0.textContainerInset = UIEdgeInsets.zero // 텍스트 컨테이너의 여백 제거
        $0.textContainer.lineFragmentPadding = 0 // 텍스트 컨테이너의 텍스트 시작 위치 조정
        $0.text = "이 고민을 통해 배운점 또는 생각을 자유롭게 적어보세요"
    }
    
    private let reviewDateLabel = UILabel().then {
        $0.textColor = .kGray4
        $0.font = .kSb1R12
        $0.text = "2019.09.01"
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setTextView()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - UI
extension WorryDetailReviewView {
    private func setUI() {
        self.backgroundColor = .kGray1
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 8
        self.layer.borderColor = UIColor.kGray3.cgColor
    }
    
    private func setTextView() {
    }
    
    private func setLayout() {
        self.addSubviews([reviewTitle, reviewTextView, reviewDateLabel])
        
        reviewTitle.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(12)
            $0.height.equalTo(18)
        }
        
        reviewTextView.snp.makeConstraints {
            $0.directionalHorizontalEdges.equalToSuperview().inset(12)
            $0.top.equalTo(reviewTitle.snp.bottom).offset(12)
            $0.bottom.equalToSuperview().inset(25)
        }
        
        reviewDateLabel.snp.makeConstraints {
            $0.bottom.trailing.equalToSuperview().inset(12)
            $0.height.equalTo(13)
        }
    }
}

//
//  WorryQuoteView.swift
//  KAERA
//
//  Created by 김담인 on 2023/08/07.
//

import UIKit
import SnapKit
import Then

final class WorryQuoteView: UIView {
        
    private let gemImage = UIImageView().then {
        $0.image = UIImage(named: "gem_red_l")
    }
    private let titleLabel = UILabel().then {
        $0.text = "이 고민을 통해 더욱 빛나기를!"
        $0.textColor = .kWhite
        $0.font = .kH3B18
    }
    private let subTitleLabel = UILabel().then {
        $0.text = ""
        $0.textAlignment = .center
        $0.textColor = .kWhite
        $0.font = .kMoR13
        $0.numberOfLines = 2
    }
        
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getRandomQuote(text: String) {
        let style = NSMutableParagraphStyle()
        style.lineSpacing = UIFont.kB4R14.lineHeight * 0.6
        style.alignment = .center
        let attributedText = NSAttributedString(
            string: text,
            attributes: [
                .paragraphStyle: style,
                .foregroundColor: UIColor.kWhite,
                .font: UIFont.kMoR13
            ]
        )
        subTitleLabel.attributedText = attributedText
    }
}

// MARK: - UI
extension WorryQuoteView {
    private func setLayout() {
        self.addSubviews([gemImage, titleLabel, subTitleLabel])
        
        gemImage.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(22)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(gemImage.snp.bottom).offset(12)
            $0.centerX.equalToSuperview()
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(23)
            $0.centerX.equalToSuperview()
        }
    }
}

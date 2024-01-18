//
//  GemStoneEmptyView.swift
//  KAERA
//
//  Created by 배성호 on 2024/01/16.
//

import UIKit
import SnapKit
import Then

final class ErrorView: UIView {
    
    // MARK: - Properties
    private var errorType: ErrorCase = .appError
    
    private lazy var errorImageView = UIImageView().then {
        switch self .errorType {
        case .appError:
            $0.image = UIImage(named: "app_error")
        case .internetError:
            $0.image = UIImage(named: "internet_error")
        }
    }
    
    private lazy var errorBtn = UIButton().then {
        switch self .errorType {
        case .appError:
            $0.setBackgroundImage(UIImage(named: "app_error_btn"), for: .normal)
        case .internetError:
            $0.backgroundColor = .clear
            $0.titleLabel?.font = .kB4R14
            $0.setTitle("새로고침하기", for: .normal)
            $0.setTitleColor(.kGray4, for: .normal)
            $0.layer.cornerRadius = 30
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.kGray4.cgColor
        }
    }

    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func modifyType(errorType: ErrorCase) {
        self.errorType = errorType
    }
    
    
    // MARK: - Function
    private func setLayout() {
        self.addSubviews([errorImageView, errorBtn])
        
        errorImageView.snp.makeConstraints {
            switch errorType {
            case .appError:
                $0.top.equalToSuperview().offset(183.adjustedH)
                $0.centerX.equalToSuperview()
                $0.width.equalTo(250.adjustedW)
                $0.height.equalTo(222.adjustedH)
            case .internetError:
                $0.top.equalToSuperview().offset(145.adjustedH)
                $0.centerX.equalToSuperview()
                $0.width.equalTo(284.adjustedW)
                $0.height.equalTo(250.adjustedH)
            }
        }
        
        errorBtn.snp.makeConstraints {
            switch errorType {
            case .appError:
                $0.top.equalTo(errorImageView.snp.bottom).offset(30.adjustedH)
                $0.centerX.equalToSuperview()
                $0.width.equalTo(250.adjustedW)
                $0.height.equalTo(58.adjustedH)
            case .internetError:
                $0.top.equalTo(errorImageView.snp.bottom).offset(40.adjustedH)
                $0.centerX.equalToSuperview()
                $0.width.equalTo(178.adjustedW)
                $0.height.equalTo(36.adjustedH)
            }
        }
    }
    
    
}

//
//  ErrorView.swift
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
    
    private let errorImageView = UIImageView()
    private let errorBtn = UIButton()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func modifyType(errorType: ErrorCase) {
        self.errorType = errorType
        updateUI()
        setLayout()
    }
    
    private func updateUI() {
        /// 이미지 뷰와 버튼의 속성을 errorType에 따라 업데이트
        switch errorType {
        case .appError:
            errorImageView.image = UIImage(named: "app_error")
            errorBtn.setBackgroundImage(UIImage(named: "app_error_btn"), for: .normal)
            errorBtn.backgroundColor = nil
            errorBtn.setTitle(nil, for: .normal)
            errorBtn.setTitleColor(nil, for: .normal)
            errorBtn.layer.cornerRadius = 0
            errorBtn.layer.borderWidth = 0
            errorBtn.layer.borderColor = UIColor.clear.cgColor
        case .internetError:
            errorImageView.image = UIImage(named: "internet_error")
            errorBtn.setBackgroundImage(nil, for: .normal)
            errorBtn.backgroundColor = .clear
            errorBtn.titleLabel?.font = .kB4R14
            errorBtn.setTitle("새로고침하기", for: .normal)
            errorBtn.setTitleColor(.kGray4, for: .normal)
            errorBtn.layer.cornerRadius = 18
            errorBtn.layer.borderWidth = 1
            errorBtn.layer.borderColor = UIColor.kGray4.cgColor
        }
    }
    
    func pressBtn(_ closure: @escaping () -> ()) {
        errorBtn.press {
            closure()
        }
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

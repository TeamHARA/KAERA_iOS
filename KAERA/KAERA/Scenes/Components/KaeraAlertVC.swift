//
//  KaeraAlertVC.swift
//  KAERA
//
//  Created by 김담인 on 2023/09/12.
//

import UIKit
import SnapKit
import Then

final class KaeraAlertVC: BaseVC {
    
    // MARK: - Enum
    enum KaeraAlertButtonType {
        case onlyOK
        case cancelAndOK
    }
    
    // MARK: - Properties
    private let backgroundStackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fillProportionally
        $0.alignment = .fill
        $0.backgroundColor = UIColor.kGray3
        $0.makeRounded(cornerRadius: 8.adjustedH)
        $0.spacing = 1
    }
    
    private let contentView = UIView().then {
        $0.backgroundColor = .kGray2
    }
    
    private let alertImageView = UIImageView().then {
        $0.image = UIImage(named: "icn_alert")
    }
    
    private let titleLabel = UILabel().then {
        $0.text = "plz set title"
        $0.font = .kB3B14
        $0.textColor = .kWhite
        $0.numberOfLines = 2
        $0.textAlignment = .center
    }
    
    private let subTitleLabel = UILabel().then {
        $0.text = "plz set subTitle"
        $0.font = .kSb1R12
        $0.textColor = .kGray5
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }
        
    private let buttonStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.alignment = .fill
        $0.backgroundColor = UIColor.kGray3
        $0.spacing = 1
    }
    private let cancelButton = UIButton(type: .system).then {
        $0.setTitle("취소", for: .normal)
        $0.titleLabel?.font = .kB2R16
        $0.setTitleColor(UIColor.kWhite, for: .normal)
        $0.backgroundColor = .kGray2
    }
    lazy var OKButton = UIButton(type: .system).then {
        $0.setTitle(okTitle ?? "확인", for: .normal)
        $0.titleLabel?.font = .kB2R16
        $0.setTitleColor(UIColor.kRed1, for: .normal)
        $0.backgroundColor = .kGray2
    }
    
    private var buttonType: KaeraAlertButtonType = .cancelAndOK
    private var okTitle: String? = nil
    
    // MARK: - Initialization
    init(buttonType: KaeraAlertButtonType = .cancelAndOK, okTitle: String = "확인") {
        super.init(nibName: nil, bundle: nil)
        
        setPresentation()
        self.buttonType = buttonType
        self.okTitle = okTitle
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setDefaultUI()
        self.setCancelButtonAction()
        self.setBackgroundLayout()
        self.setContentStackViewLayout()
        
        switch self.buttonType {
        case .onlyOK:
            self.setOnlyOKButtonLayout()
        case .cancelAndOK:
            self.setButtonStackViewLayout()
        }
    }
    
    // MARK: - Functions
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard let touch = touches.first else {
            return
        }
        
        /// 배경 영역을 탭한 경우 뷰 컨트롤러를 닫음
        if !backgroundStackView.frame.contains(touch.location(in: self.view)) {
            UIView.animate(withDuration: 0.5, animations: {
                self.dismiss(animated: true, completion: nil)
            })
        }
    }
    
    func setTitleSubTitle(title: String, subTitle: String, highlighting: String = "") {
        let attributedString = NSMutableAttributedString(string: title)
        
        attributedString.addAttribute(
            .foregroundColor,
            value: UIColor.kRed1,
            range: (title as NSString).range(of: highlighting))
                
        titleLabel.attributedText = attributedString
        titleLabel.sizeToFit()

        subTitleLabel.text = subTitle
        subTitleLabel.sizeToFit()
    }
    
    private func setPresentation() {
        self.modalPresentationStyle = .overFullScreen
        self.modalTransitionStyle = .crossDissolve
    }
    
    func setCancelButtonAction() {
        cancelButton.press { [weak self] in
            self?.dismiss(animated: true)
        }
    }
    
}

// MARK: - UI
extension KaeraAlertVC {
    private func setDefaultUI() {
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        view.addSubview(backgroundStackView)
        
        backgroundStackView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.height.equalTo(194.adjustedH)
            $0.width.equalTo(341.adjustedW)
        }
    }
    
    private func setBackgroundLayout() {
        backgroundStackView.addArrangedSubviews([contentView, buttonStackView ])
        
        contentView.snp.makeConstraints {
            $0.height.equalTo(135.adjustedH)
            $0.width.equalToSuperview()
        }
        
        buttonStackView.snp.makeConstraints {
            $0.height.equalTo(60)
            $0.left.right.bottom.equalToSuperview()
        }
    }
    
    private func setContentStackViewLayout() {

        contentView.addSubviews([alertImageView, titleLabel, subTitleLabel])
        
        alertImageView.snp.makeConstraints {
            $0.height.equalTo(39)
            $0.width.equalTo(45)
            $0.top.equalToSuperview().inset(22)
            $0.centerX.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(alertImageView.snp.bottom).offset(15)
            $0.centerX.equalToSuperview()
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(6)
            $0.centerX.equalToSuperview()
        }
    }
    
    private func setButtonStackViewLayout() {
        buttonStackView.addArrangedSubviews([cancelButton, OKButton])
    }
    
    private func setOnlyOKButtonLayout() {
        buttonStackView.addArrangedSubviews([OKButton])
    }
}



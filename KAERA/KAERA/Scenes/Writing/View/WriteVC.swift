//
//  WorryVC.swift
//  KAERA
//
//  Created by saint on 2023/07/09.
//

import UIKit
import SnapKit
import Then

class WriteVC: UIViewController{
    // MARK: - Properties
    private let writeModalVC = WriteModalVC()
    
    private let closeBtn = UIButton().then {
        $0.setBackgroundImage(UIImage(named: "icn_close"), for: .normal)
        $0.contentMode = .scaleAspectFit
    }
    
    private let completeBtn = UIButton().then {
        $0.backgroundColor = .kGray3
        $0.titleLabel?.font = .kB4R14
        $0.setTitle("완료", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 12
    }
    
    private let templateBtn = UIButton().then {
        $0.backgroundColor = .clear
    }
    
    private let templateTitle = UILabel().then {
        $0.text = "템플릿을 선택해주세요"
        $0.textColor = .kWhite
        $0.font = .kB2R16
    }
    
    private let dropdownImg = UIImageView().then {
        $0.image = UIImage(named: "icn_drop_down")
        $0.contentMode = .scaleAspectFit
        $0.backgroundColor = .clear
    }
    
    private let underLine = UIView().then {
        $0.backgroundColor = .kGray3
    }
    
    private let worryTitleLabel = UILabel().then {
        $0.text = "고민에 이름을 붙여주세요"
        $0.textColor = .kWhite
        $0.font = .kB2R16
    }
    
    private let worryTitleTextField = UITextField().then{
        $0.layer.cornerRadius = 8
        $0.backgroundColor = .kGray3
        $0.textColor = .kWhite
        $0.font = .kSb1R12
        $0.addLeftPadding(10)
        
        // Placeholder 색상 설정
        let placeholderText = "이 고민에 이름을 붙이자면..."
        let placeholderColor = UIColor.kGray4
        $0.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: [NSAttributedString.Key.foregroundColor: placeholderColor])
    }
    
    private let worryContentLabel = UILabel().then {
        $0.text = "고민 내용 작성하기"
        $0.textColor = .kWhite
        $0.font = .kB2R16
    }
    
    private let baseImage = UIImageView().then {
        $0.image = UIImage(named: "gem_no_template")
        $0.contentMode = .scaleToFill
        $0.backgroundColor = .clear
    }
    
    private let introTitle = UILabel().then {
        $0.text = "선택된 템플릿이 없어요!"
        $0.textColor = .kWhite
        $0.font = .kH3B18
    }
    
    private let introDetail = UILabel().then {
        $0.text = "상단에서 템플릿을 골라볼까요?"
        $0.textColor = .kGray4
        $0.font = .kSb1R12
    }
    
    private let pickerVC = WritePickerVC()
    
    // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        writeModalVC.sendTitleDelegate = self
        setLayout()
        pressBtn()
    }
    
    // MARK: - Functions
    private func pressBtn() {
        closeBtn.press { [self] in
            dismiss(animated: true)
        }
        
        completeBtn.press { [self] in
            pickerVC.view.alpha = 0 /// pickerView를 초기에 보이지 않게 설정
            ///
            pickerVC.modalPresentationStyle = .overCurrentContext
            present(pickerVC, animated: false, completion: { /// 애니메이션을 false로 설정
                UIView.animate(withDuration: 0.5, animations: { [self] in /// 애니메이션 추가
                    pickerVC.view.alpha = 1 /// pickerView가 서서히 보이게 설정
                    pickerVC.view.layoutIfNeeded()
                })
            })
        }
        
        templateBtn.press {
            self.writeModalVC.modalPresentationStyle = .pageSheet
            
            if let sheet = self.writeModalVC.sheetPresentationController {
                /// 지원할 크기 지정(.medium(), .large())
                sheet.detents = [.large()]
                
                /// 시트 상단에 그래버 표시 (기본 값은 false)
                sheet.prefersGrabberVisible = true
            }
            self.present(self.writeModalVC, animated: true)
        }
    }
}

// MARK: - Layout
extension WriteVC {
    private func setLayout() {
        view.backgroundColor = .kGray1
        view.addSubviews([closeBtn, completeBtn, templateBtn, templateTitle])
        templateBtn.addSubviews([templateTitle, dropdownImg, underLine])
        view.addSubviews([worryTitleLabel, worryTitleTextField, worryContentLabel])
        view.addSubviews([baseImage, introTitle, introDetail])
        
        closeBtn.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(20.adjustedW)
            $0.leading.equalTo(self.view.safeAreaLayoutGuide).offset(16.adjustedW)
            $0.height.width.equalTo(24.adjustedW)
        }
        
        completeBtn.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(20.adjustedW)
            $0.trailing.equalTo(self.view.safeAreaLayoutGuide).offset(-16.adjustedW)
            $0.width.equalTo(50.adjustedW)
            $0.height.equalTo(26.adjustedW)
        }
        
        templateBtn.snp.makeConstraints {
            $0.top.equalTo(completeBtn.snp.bottom).offset(16)
            $0.height.equalTo(60.adjustedW)
            $0.leading.trailing.equalToSuperview()
        }
        
        templateTitle.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(12.adjustedW)
            $0.centerY.equalToSuperview()
        }
        
        dropdownImg.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-16.adjustedW)
            $0.centerY.equalToSuperview()
            $0.height.width.equalTo(24.adjustedW)
        }
        
        underLine.snp.makeConstraints {
            $0.bottom.equalTo(templateBtn.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        worryTitleLabel.snp.makeConstraints {
            $0.top.equalTo(underLine.snp.bottom).offset(20.adjustedW)
            $0.leading.equalToSuperview().offset(12.adjustedW)
        }
        
        worryTitleTextField.snp.makeConstraints {
            $0.top.equalTo(worryTitleLabel.snp.bottom).offset(12.adjustedW)
            $0.leading.equalToSuperview().offset(12)
            $0.trailing.equalToSuperview().offset(-12)
            $0.height.equalTo(44.adjustedW)
        }
        
        worryContentLabel.snp.makeConstraints {
            $0.top.equalTo(worryTitleTextField.snp.bottom).offset(26.adjustedW)
            $0.leading.equalToSuperview().offset(12.adjustedW)
        }
        
        baseImage.snp.makeConstraints {
            $0.top.equalTo(worryContentLabel.snp.bottom).offset(120.adjustedW)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(120.adjustedW)
            $0.height.equalTo(95.adjustedW)
        }
        
        introTitle.snp.makeConstraints {
            $0.top.equalTo(baseImage.snp.bottom).offset(32)
            $0.centerX.equalToSuperview()
        }
        
        introDetail.snp.makeConstraints {
            $0.top.equalTo(introTitle.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
        }
    }
}

// MARK: - TemplageTitleDelegate
extension WriteVC: TemplateTitleDelegate {
    func sendTitle(templateTitle: String) {
        self.templateTitle.text = templateTitle
    }
}



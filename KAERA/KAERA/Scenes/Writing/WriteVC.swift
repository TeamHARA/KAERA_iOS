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
        $0.image = UIImage(named: "icnDropDown")
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
    
    // pickerView 관련 코드
    let pickerVC = UIViewController()
    let pickerData = Array(1...30).map { String($0) }
    
    private let datePickerView = UIPickerView().then {
        $0.backgroundColor = .kGray1
        $0.layer.cornerRadius = 8
    }
    
    private let pickerViewTitle = UILabel().then {
        $0.text = "이 고민, 언제까지 끝낼까요?"
        $0.font = .kB2R16
        $0.textColor = .kYellow1
    }
    
    private let firstLabel = UILabel().then {
        $0.text = "이 고민을"
        $0.font = .kH1B20
        $0.textColor = .white
    }
    
    private let secondLabel = UILabel().then {
        $0.text = "일 후까지 끝낼게요"
        $0.font = .kH1B20
        $0.textColor = .white
    }
    
    private let upperCover = UIView().then {
        $0.backgroundColor = .kGray1
    }
    
    private let lowerCover = UIView().then {
        $0.backgroundColor = .kGray1
    }
    
    private let completeWritingBtn = UIButton().then {
        $0.backgroundColor = .kGray5
        $0.titleLabel?.font = .kB2R16
        $0.setTitle("작성완료", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.layer.cornerRadius = 8
    }
    
    private let noDeadlineBtn = UIButton().then {
        $0.backgroundColor = .clear
        $0.titleLabel?.font = .kB4R14
        
        let title = "기한 설정하지 않기"
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.kB4R14,
            .foregroundColor: UIColor.kGray5,
            .underlineStyle: NSUnderlineStyle.single.rawValue,
            .underlineColor: UIColor.kGray5
        ]
        
        let attributedTitle = NSAttributedString(string: title, attributes: titleAttributes)
        $0.setAttributedTitle(attributedTitle, for: .normal)
    }
    
    
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
        
        templateBtn.press {
            self.writeModalVC.modalPresentationStyle = .pageSheet
            
            if let sheet = self.writeModalVC.sheetPresentationController {
                
                /// 지원할 크기 지정
                /// 크기 늘리고 싶으면 뒤에 ", .large()" 추가
                /// 줄이려면 .medium()
                sheet.detents = [.large()]
                
                /// 시트 상단에 그래버 표시 (기본 값은 false)
                sheet.prefersGrabberVisible = true
                
                /// 뒤 배경 흐리게 제거 (기본 값은 모든 크기에서 배경 흐리게 됨)
                /// 배경 흐리게 할 시에는 sheet가 올라왔을 때 배경 클릭해도 sheet 안 사라짐
                //                sheet.largestUndimmedDetentIdentifier = .medium
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
extension WriteVC: TemplageTitleDelegate {
    func sendTitle(templateTitle: String) {
        self.templateTitle.text = templateTitle
    }
}



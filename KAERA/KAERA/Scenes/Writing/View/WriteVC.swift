//
//  WorryVC.swift
//  KAERA
//
//  Created by saint on 2023/07/09.
//

import UIKit
import Combine
import SnapKit
import Then

class WriteVC: UIViewController {
    
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
    
    private let navigationBarView = CustomNavigationBarView(leftType: .close, rightType: .done, title: "")
    
    private let templateBtn = UIButton().then {
        $0.backgroundColor = .clear
    }
    
    private let templateTitle = UILabel().then {
        $0.text = "템플릿을 선택해주세요"
        $0.textColor = .kWhite
        $0.font = .kB2R16
    }
    
    private let templateInfo = UILabel().then {
        $0.textColor = .kGray5
        $0.font = .kSb1R12
    }
    
    private let dropdownImg = UIImageView().then {
        $0.image = UIImage(named: "icn_drop_down")
        $0.contentMode = .scaleAspectFit
        $0.backgroundColor = .clear
    }
    
    private let dividingLine = UIView().then {
        $0.backgroundColor = .kGray2
    }
    
    private let bottomDividingLine = UIView().then {
        $0.backgroundColor = .kGray3
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
        setNaviButtonAction()
        setLayout()
        pressBtn()
        setObserver()
    }
    
    // MARK: - Functions
    @objc func didCompleteWritingNotification(_ notification: Notification) {
        DispatchQueue.main.async { [self] in
            self.dismiss(animated: true)
        }
    }
    
    private func setObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.didCompleteWritingNotification(_:)),
            name: NSNotification.Name("CompleteWriting"),
            object: nil
        )
    }
    
    private func setNaviButtonAction() {
        navigationBarView.setLeftButtonAction {
            self.dismiss(animated: true, completion: nil)
        }
        
        navigationBarView.setRightButtonAction  { [self] in
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
    }
    
    private func pressBtn() {
        
        templateBtn.press {
            self.writeModalVC.modalPresentationStyle = .pageSheet
            
            if let sheet = self.writeModalVC.sheetPresentationController {
                /// 지원할 크기 지정(.medium(), .large())
                sheet.detents = [.medium()]
                
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
        view.addSubviews([navigationBarView, templateBtn])
        templateBtn.addSubviews([templateTitle, templateInfo, dropdownImg])
        view.addSubviews([dividingLine])
        view.addSubviews([baseImage, introTitle, introDetail])
        
        navigationBarView.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(16)
            $0.top.equalToSuperview().inset(70)
            $0.height.equalTo(43)
        }
        
        templateBtn.snp.makeConstraints {
            $0.top.equalTo(navigationBarView.snp.bottom)
            $0.height.equalTo(69.adjustedW)
            $0.leading.trailing.equalToSuperview()
        }
        
        templateTitle.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12.adjustedW)
            $0.leading.equalToSuperview().offset(16.adjustedW)
        }
        
        templateInfo.snp.makeConstraints {
            $0.top.equalTo(templateTitle.snp.bottom).offset(9.adjustedW)
            $0.leading.equalToSuperview().offset(16.adjustedW)
        }
        
        dropdownImg.snp.makeConstraints {
            $0.top.equalToSuperview().offset(9.adjustedW)
            $0.trailing.equalToSuperview().offset(-16.adjustedW)
            $0.height.width.equalTo(24.adjustedW)
        }
        
        dividingLine.snp.makeConstraints {
            $0.top.equalTo(templateBtn.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(12)
        }
        
        baseImage.snp.makeConstraints {
            $0.top.equalTo(dividingLine.snp.bottom).offset(200.adjustedW)
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
    func templateReload(templateId: Int, templateTitle: String, templateInfo: String) {
        self.templateTitle.text = templateTitle
        self.templateInfo.text = templateInfo
        setTemplateContentTV(templateId)
    }
    
    private func setTemplateContentTV(_ templateId: Int) {
        let tvc = TemplateContentTV(templateId:  templateId)
        self.view.addSubview(tvc)
        tvc.snp.makeConstraints{
            $0.top.equalTo(self.dividingLine.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
}



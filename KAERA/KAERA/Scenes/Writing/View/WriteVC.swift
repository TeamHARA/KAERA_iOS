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

enum WriteType {
    case post
    case patch
}

class WriteVC: BaseVC {
    
    // MARK: - View Model
    private let templateContentVM = TemplateContentViewModel()
    private var cancellables = Set<AnyCancellable>()
    let input = PassthroughSubject<Int, Never>.init()
    
    // MARK: - Properties
    private let writeModalVC = WriteModalVC()
    let templateContentTV = TemplateContentTV()
    private let templateHeaderView = TemplateContentHeaderView()
    
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
    
    /// tableView의 데이터들을 담는 싱글톤 클래스
    let contentInfo = ContentInfo.shared
    
    private let pickerVC = WritePickerVC(type: .post)
    
    private var writeType: WriteType = .post
    
    private var tempAnswers: [String] = []
    
    // MARK: - Initialization
    init(type: WriteType) {
        super.init(nibName: nil, bundle: nil)
        self.writeType = type
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        writeModalVC.sendTitleDelegate = self
        setNaviButtonAction()
        setLayout()
        pressBtn()
        hideKeyboardWhenTappedAround()
        addKeyboardObserver()
        dataBind()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.didCompleteWritingNotification(_:)),
            name: NSNotification.Name("CompleteWriting"),
            object: nil
        )
    }
    
    // MARK: - Functions
    func dataBind() {
        let output = templateContentVM.transform(
            input: TemplateContentViewModel.Input(input)
        )
        output.receive(on: DispatchQueue.main)
            .sink { [weak self] templateContents in
                self?.updateUI(templateContents)
            }.store(in: &cancellables)
    }
    
    private func updateUI(_ templateContents: TemplateContentModel) {
        switch self .writeType {
        case .post:
            templateContentTV.setData(type: .post, questions: templateContents.questions, hints: templateContents.hints)
        case .patch:
            /// 고민상세뷰로부터 전달받은 답변을 hints로 사용
            templateContentTV.setData(type: .patch, questions: templateContents.questions, hints: tempAnswers)
        }
        
        view.addSubview(templateContentTV)
        templateContentTV.snp.updateConstraints {
            $0.top.equalTo(self.dividingLine.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        templateContentTV.reloadData()
    }
    
    @objc func didCompleteWritingNotification(_ notification: Notification) {
        DispatchQueue.main.async { [self] in
            self.dismiss(animated: true)
        }
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
    
    func setTempAnswers(answers: [String]) {
        self.tempAnswers = answers
    }
}

// MARK: - Layout
extension WriteVC {
    private func setLayout() {
        view.backgroundColor = .kGray1
        view.addSubviews([navigationBarView, templateBtn])
        templateBtn.addSubviews([templateTitle, templateInfo, dropdownImg])
        view.addSubviews([baseImage, introTitle, introDetail])
        view.addSubviews([dividingLine])
        
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
        templateContentTV.templateId = templateId
        input.send(templateContentTV.templateId)
    }
}

// MARK: - Keyboard
extension WriteVC {
    
    private func addKeyboardObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboardWillAppear(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self, selector: #selector(keyboardWillDisappear),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
    }
    
    private func removeKeyboardObserver() {
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    /// 키보드 높이가 올라올 때, contentInset을 키보드 높이만큼 조정해줌.
    @objc func keyboardWillAppear(_ notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardHeight = keyboardFrame.cgRectValue.height
            
            let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardHeight + 50, right: 0.0)
            templateContentTV.contentInset = contentInsets
        }
    }
    
    /// 키보드 내려갈 떄, 다시 원래대로 복귀
    @objc func keyboardWillDisappear(_ notification: NSNotification) {
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        
        templateContentTV.contentInset = contentInsets
    }
}

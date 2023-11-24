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
    case postDifferentTemplate
    case patch
    case patchDifferentTemplate
}

final class WriteVC: BaseVC {
    
    // MARK: - View Model
    private let templateContentVM = TemplateContentViewModel()
    private var cancellables = Set<AnyCancellable>()
    let input = PassthroughSubject<Int, Never>.init()
    
    // MARK: - Properties
    private let writeModalVC = WriteModalVC()
    let templateContentTV = TemplateContentTV()

    private let navigationBarView = CustomNavigationBarView(leftType: .close, rightType: .done, title: "")
    
    let templateBtn = UIButton().then {
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
    let postContent = WorryPostManager.shared
    
    private let pickerVC = WritePickerVC(type: .post)
    private var writeType: WriteType = .post
    
    private var tempAnswers: [String] = []
    
    let worryPatchContent = WorryPatchManager.shared
    var worryPatchPublishedContent = PatchWorryModel(worryId: 1, templateId: 1, title: "", answers: [])
    
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
        /// 초기에 완료 상태 비활성화
        navigationBarView.setupDoneButtonStatus(status: true)
        setNaviButtonAction()
        setLayout()
        setDelegate()
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
    private func setDelegate() {
        writeModalVC.sendTitleDelegate = self
        templateContentTV.buttonDelegate = self
    }
    
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
        /// 고민 작성, 고민 작성(템플릿 변경), 고민 수정(템플릿 변경) 의 경우에는 값을 초기화해주는 것이기 때문에, writeModalVC에서 선택한 템플릿의 값으로 cell을 설정해준다.
        case .post:
            templateContentTV.title = ""
            templateContentTV.setData(type: .post, questions: templateContents.questions, hints: templateContents.hints)
        case .postDifferentTemplate:
            templateContentTV.title = ""
            templateContentTV.setData(type: .postDifferentTemplate, questions: templateContents.questions, hints: templateContents.hints)
        case .patchDifferentTemplate:
            templateContentTV.title = ""
            templateContentTV.setData(type: .patchDifferentTemplate, questions: templateContents.questions, hints: templateContents.hints)
        /// 고민 수정의 경우에는 HomeWorryEditVC에서 tempAnswer로 전달받은 원래 답변으로 cell을 초기화 시켜준다.
        case .patch:
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
            switch self .writeType {
            case .post, .postDifferentTemplate:
                pickerVC.view.alpha = 0 /// pickerView를 초기에 보이지 않게 설정
                ///
                pickerVC.modalPresentationStyle = .overCurrentContext
                present(pickerVC, animated: false, completion: { /// 애니메이션을 false로 설정
                    UIView.animate(withDuration: 0.5, animations: { [self] in /// 애니메이션 추가
                        pickerVC.view.alpha = 1 /// pickerView가 서서히 보이게 설정
                        pickerVC.view.layoutIfNeeded()
                    })
                })
            case .patch, .patchDifferentTemplate:
                worryPatchPublishedContent.worryId = worryPatchContent.worryId
                worryPatchPublishedContent.templateId = worryPatchContent.templateId
                worryPatchPublishedContent.title = worryPatchContent.title
                worryPatchPublishedContent.answers = worryPatchContent.answers
                editWorry()
                /// HomeWorryDetailVC Reload 해주기 위해 알림 전송
                NotificationCenter.default.post(name: NSNotification.Name("CompleteWorryEditing"), object: nil, userInfo: nil)
            }
        }
    }
    
    private func pressBtn() {
        templateBtn.press {
            switch self .writeType {
            case .post:
                self.modalTemplateSelectVC()
            /// 고민 작성 시를 제외하고는 템플릿 변경 시 알럿 창을 띄워주어야 한다.
            case .patch:
                self.writeType = .patchDifferentTemplate
                self.makeAlert()
            case .postDifferentTemplate, .patchDifferentTemplate:
                self.makeAlert()
            }
        }
    }
    
    private func makeAlert() {
        let failureAlertVC = KaeraAlertVC(buttonType: .cancelAndOK, okTitle: "변경")
        failureAlertVC.setTitleSubTitle(title: "템플릿이 변경되면 작성 중인 내용이 사라집니다.", subTitle: "변경하시겠어요?", highlighting: "변경")
        self.present(failureAlertVC, animated: true)
        failureAlertVC.OKButton.press {
            self.dismiss(animated: true)
            self.modalTemplateSelectVC()
        }
    }
    
    private func modalTemplateSelectVC() {
        self.writeModalVC.modalPresentationStyle = .pageSheet
        
        if let sheet = self.writeModalVC.sheetPresentationController {
            /// 지원할 크기 지정(.medium(), .large())
            sheet.detents = [.medium()]
            
            /// 시트 상단에 그래버 표시 (기본 값은 false)
            sheet.prefersGrabberVisible = true
        }
        self.present(self.writeModalVC, animated: true)
    }
    
    func setTempAnswers(answers: [String]) {
        self.tempAnswers = answers
    }
    
    func editWorry() {
        /// 서버로 고민 내용을 Patch 시켜줌
        HomeAPI.shared.editWorry(param: worryPatchPublishedContent){ result in
            guard let result = result, let _ = result.data else { return }
        }
        self.dismiss(animated: true)
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
        // 처음 고민작성시 템플릿을 선택했을때 writeType을 바꿔줌
        if writeType == .post {
            self.writeType = .postDifferentTemplate
        }
    }
    
    private func setTemplateContentTV(_ templateId: Int) {
        templateContentTV.templateId = templateId
        input.send(templateContentTV.templateId)
    }
}

// MARK: - ActivateButtonDelegate
extension WriteVC: ActivateButtonDelegate {
    func isTitleEmpty(check: Bool) {
        /// navigationBarView의 상태를 변경해준다.
        navigationBarView.setupDoneButtonStatus(status: check)
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

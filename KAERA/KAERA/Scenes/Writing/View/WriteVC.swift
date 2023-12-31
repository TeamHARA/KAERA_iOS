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
    
    private let worryContentLabel = UILabel().then {
        $0.text = "고민 내용 작성하기"
        $0.textColor = .kWhite
        $0.font = .kB2R16
    }
    
    private let writeEmptyView = WriteEmptyView()
    
    private var isTemplateContentTVAdded = false
    
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
        setNaviButtonAction()
        setLayout()
        setDelegate()
        setPressBtn()
        hideKeyboardWhenTappedAround()
        addKeyboardObserver()
        dataBind()
    }
    
    // MARK: - Functions
    private func setDelegate() {
        writeModalVC.sendIdDelegate = self
        templateContentTV.buttonDelegate = self
    }
    
    func dataBind() {
        let output = templateContentVM.transform(
            input: TemplateContentViewModel.Input(input)
        )
        output.receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure:
                    self?.presentNetworkAlert()
                }
            }, receiveValue: { [weak self] templateContents in
                self?.stopLoadingAnimation()
                self?.updateUI(templateContents)
            })
            .store(in: &cancellables)
    }
    
    private func updateUI(_ templateContents: TemplateContentModel) {
        self.templateTitle.text = templateContents.title
        self.templateInfo.text = templateContents.guideline
        templateContentTV.setData(type: writeType, questions: templateContents.questions, hints: templateContents.hints, answers: tempAnswers)
        
        templateContentTV.reloadData()
    }
    
    private func setNaviButtonAction() {
        navigationBarView.setLeftButtonAction { [weak self] in
            // 제목, 내용 다 텍스트가 없을때만 바로 dismiss함
            if self?.checkIfWorryContentIsEmpty() ?? false {
                self?.dismiss(animated: true)
            }else {
                self?.makeWritingCancelAlert()
            }
        }
        
        navigationBarView.setRightButtonAction  { [weak self] in
            switch self?.writeType {
            case .post:
                if WorryPostManager.shared.title.isEmpty {
                    self?.showToastMessage(message: "고민의 제목을 붙여주세요!", color: .black)
                } else if self?.checkEmptyAnswer() ?? true {
                    self?.showToastMessage(message: "내용이 전부 작성되지 않았어요!", color: .black)
                } else {
                    let pickerVC = WritePickerVC(type: .post)
                    pickerVC.view.alpha = 0 /// pickerView를 초기에 보이지 않게 설정
                    ///
                    pickerVC.modalPresentationStyle = .overCurrentContext
                    self?.present(pickerVC, animated: false, completion: { /// 애니메이션을 false로 설정
                        UIView.animate(withDuration: 0.5, animations: {  /// 애니메이션 추가
                            pickerVC.view.alpha = 1 /// pickerView가 서서히 보이게 설정
                            pickerVC.view.layoutIfNeeded()
                        })
                    })
                }
            case .patch:
                if WorryPostManager.shared.title.isEmpty {
                    self?.showToastMessage(message: "고민의 제목을 붙여주세요!", color: .black)
                } else if self?.checkEmptyAnswer() ?? true {
                    self?.showToastMessage(message: "내용이 전부 작성되지 않았어요!", color: .black)
                } else {
                    let worryPatchManager = WorryPatchManager.shared
                    let patchWorryContent: PatchWorryModel = PatchWorryModel(worryId: worryPatchManager.worryId, templateId: worryPatchManager.templateId, title: worryPatchManager.title, answers: worryPatchManager.answers)
                    self?.editWorry(patchWorryContent: patchWorryContent)
                }
            default:
                break
            }
        }
    }
    
    private func checkEmptyAnswer() -> Bool {
        var answers: [String] = []
        switch writeType {
        case .post:
            answers = WorryPostManager.shared.answers
        case .patch:
            answers = WorryPatchManager.shared.answers
        }
        /// answers가 아예 빈 배열일때 처리
        var hasEmptyAnswer = answers.isEmpty
        answers.forEach {
            if $0.isEmpty {
                hasEmptyAnswer = true
            }
        }
        return hasEmptyAnswer
    }
    
    private func makeWritingCancelAlert() {
        let failureAlertVC = KaeraAlertVC(buttonType: .cancelAndOK, okTitle: "나가기")
        failureAlertVC.setTitleSubTitle(title: "화면을 나가면 작성 중인 내용이 사라져요!", subTitle: "지금 나가실 건가요?")
        self.present(failureAlertVC, animated: true)
        failureAlertVC.OKButton.press { [weak self] in
            switch self?.writeType {
            case .post:
                WorryPostManager.shared.clearWorryData()
            case .patch:
                WorryPatchManager.shared.clearWorryData()
            case .none:
                break
            }
            let presentingVC = self?.presentingViewController
            self?.dismiss(animated: true) {
                presentingVC?.dismiss(animated: true)
            }
        }
    }
    
    private func checkIfWorryContentIsEmpty() -> Bool {
        var title: String = ""
        var answers: [String] = []
        
        switch self.writeType {
        case .post:
            title = WorryPostManager.shared.title
            answers = WorryPostManager.shared.answers
            /// 고민 작성 시를 제외하고는 템플릿 변경 시 알럿 창을 띄워주어야 한다.
        case .patch:
            title = WorryPatchManager.shared.title
            answers = WorryPatchManager.shared.answers
        }
    
        let joinedAnswers = answers.joined()
        
        if title.isEmpty && joinedAnswers.isEmpty {
            return true
        }else {
            return false
        }
    }

    private func setPressBtn() {
        templateBtn.press { [weak self] in
            // 제목, 내용 다 텍스트가 없을때만 바로 modal을 띄움
            if self?.checkIfWorryContentIsEmpty() ?? false {
                self?.modalTemplateSelectVC()
            }else {
                self?.makeTemplateChangeAlert()
            }
        }
    }
    
    private func makeTemplateChangeAlert() {
        let failureAlertVC = KaeraAlertVC(buttonType: .cancelAndOK, okTitle: "변경")
        failureAlertVC.setTitleSubTitle(title: "템플릿이 변경되면 작성 중인 내용이 사라집니다.", subTitle: "변경하시겠어요?", highlighting: "변경")
        self.present(failureAlertVC, animated: true)
        failureAlertVC.OKButton.press { [weak self] in
            switch self?.writeType {
            case .post:
                WorryPostManager.shared.answers = []
            case .patch:
                WorryPatchManager.shared.answers = []
            case .none:
                break
            }
            self?.dismiss(animated: true) {
                self?.modalTemplateSelectVC()
            }
        }
    }
    
    func modalTemplateSelectVC() {
        self.writeModalVC.modalPresentationStyle = .pageSheet
        
        if let sheet = self.writeModalVC.sheetPresentationController {
            /// 지원할 크기 지정(.medium(), .large())
            sheet.detents = [.medium(), .large()]
            
            /// 시트 상단에 그래버 표시 (기본 값은 false)
            sheet.prefersGrabberVisible = true
        }
        if writeType == .patch {
            writeModalVC.setTemplateIndex(templateId: WorryPatchManager.shared.templateId)
        }
        
        self.present(self.writeModalVC, animated: true)
    }
    
    func setTempAnswers(answers: [String]) {
        self.tempAnswers = answers
    }
    
    private func editWorry(patchWorryContent: PatchWorryModel) {
        self.startLoadingAnimation()
        HomeAPI.shared.editWorry(param: patchWorryContent){ [weak self] result in
            guard let result = result, let _ = result.data else { 
                self?.presentNetworkAlert()
                return
            }
            self?.stopLoadingAnimation()
            WorryPatchManager.shared.clearWorryData()
            if let editVC = self?.presentingViewController {
                if let detailVC = editVC.presentingViewController as? HomeWorryDetailVC {
                    detailVC.sendInputWithWorryId(id: WorryPatchManager.shared.worryId)
                }
                self?.showToastMessage(message: "수정완료!", color: .black)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self?.dismiss(animated: true) {
                        UIView.animate(withDuration: 0.3) {
                            editVC.view.alpha = 0
                            editVC.dismiss(animated: true)
                        }
                    }
                }
            }
        }
    }
}

// MARK: - TemplateIdDelegate
extension WriteVC: TemplateIdDelegate {
    func templateReload(templateId: Int) {
        if !isTemplateContentTVAdded {
            view.addSubview(templateContentTV)

            templateContentTV.snp.makeConstraints {
                $0.top.equalTo(self.dividingLine.snp.bottom)
                $0.horizontalEdges.equalToSuperview()
                $0.bottom.equalToSuperview()
            }
            
            isTemplateContentTVAdded = true
        }
        
        startLoadingAnimation()
        input.send(templateId)
        // 처음 고민작성시 템플릿을 선택했을때 writeType을 바꿔줌
        if writeType == .post {
            WorryPostManager.shared.templateId = templateId
        }else if writeType == .patch {
            WorryPatchManager.shared.templateId = templateId
            self.tempAnswers = []
        }
        checkButtonStatus()
    }
}

// MARK: - ActivateButtonDelegate
extension WriteVC: ActivateButtonDelegate {
    func checkButtonStatus() {
        var isTitleEmpty = true
        switch self.writeType {
        case .post:
            isTitleEmpty = WorryPostManager.shared.title.isEmpty
        case .patch:
            isTitleEmpty = WorryPatchManager.shared.title.isEmpty
        }
        
        if isTitleEmpty || self.checkEmptyAnswer() {
            setupDoneButton(status: false)
        } else {
            setupDoneButton(status: true)
        }
    }
    
    func setupDoneButton(status: Bool) {
        navigationBarView.setupDoneButtonStatus(status: status)
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

// MARK: - Layout
extension WriteVC {
    private func setLayout() {
        view.backgroundColor = .kGray1
        view.addSubviews([navigationBarView, templateBtn])
        templateBtn.addSubviews([templateTitle, templateInfo, dropdownImg])
        view.addSubview(dividingLine)

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
        
        if writeType == .patch {
            view.addSubview(templateContentTV)
            
            templateContentTV.snp.makeConstraints {
                $0.top.equalTo(self.dividingLine.snp.bottom)
                $0.horizontalEdges.equalToSuperview()
                $0.bottom.equalToSuperview()
            }
            
            self.isTemplateContentTVAdded = true
        } else {
            view.addSubview(writeEmptyView)
            
            writeEmptyView.snp.makeConstraints {
                $0.top.equalTo(dividingLine)
                $0.width.equalToSuperview()
                $0.bottom.equalToSuperview()
            }
        }
    }
}


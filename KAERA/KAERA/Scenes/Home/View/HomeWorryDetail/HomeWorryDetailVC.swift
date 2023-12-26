//
//  HomeWorryDetailVC.swift
//  KAERA
//
//  Created by 김담인 on 2023/07/21.
//

import UIKit
import Combine
import SnapKit
import Then

final class HomeWorryDetailVC: BaseVC {
    
    // MARK: - Properties
    private let worryDetailViewModel = HomeWorryDetailViewModel()
    private var cancellables = Set<AnyCancellable>()
    private let input = PassthroughSubject<Int, Never>.init()
    
    private lazy var navigationBarView: CustomNavigationBarView = {
        switch self.pageType {
        case .digging:
            return CustomNavigationBarView(leftType: .close, rightType: .edit, title: "고민캐기")
        case .dug:
            return CustomNavigationBarView(leftType: .close, rightType: .delete, title: "고민캐기")
        }
    }()
    
    private let worryDetailTV = UITableView().then {
        $0.backgroundColor = .clear
        $0.isScrollEnabled = false
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
        $0.separatorStyle = .none
    }
    
    private let worryDetailScrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
    }
    
    private let worryDetailContentView = UIView().then {
        $0.backgroundColor = .clear
    }
    
    private let backgroundImageView = UIImageView().then {
        $0.image = UIImage(named: "framebg")
    }
    
    private let bottmContainerView = UIView().then {
        $0.backgroundColor = .kGray1
    }
    
    private let digWorryButton = UIButton().then {
        $0.setTitleWithCustom("⚒️ 고민 보석 캐기", font: .kB1B16, color: .kWhite, for: .normal)
        $0.backgroundColor = .kGray3
        $0.layer.cornerRadius = 8
    }
    private let reviewView = WorryDetailReviewView()
    private var questions = [String]()
    private var answers = [String]()
    private var updateDate = ""
    private var worryTitle = ""
    private var templateId = 1
    private var worryId = 1
    private var period = ""
    private var pageType: PageType = .digging
    
    private let restReviewViewHeight: CGFloat = 67
    private var defaultTextViewHeight: CGFloat = 53
    private let reviewSpacing: CGFloat = 32
    private let placeholderText = "이 고민을 통해 배운점 또는 생각을 자유롭게 적어보세요"
    private var reviewTextViewHeight: CGFloat = 0
    private var finalAnswer = ""
    private var reviewText = ""
    private var isReviewEditing: Bool = false
    
    // MARK: - Initialization
    init(worryId: Int, type: PageType) {
        super.init(nibName: nil, bundle: nil)
        self.pageType = type
        self.worryId = worryId
        dataBind()
        self.startLoadingAnimation()
        input.send(worryId)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        // 뷰 컨트롤러가 dismiss될 때 옵저버 제거
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .kGray1
        setLayout()
        switch pageType {
        case .digging:
            setDiggingLayout()
        case .dug:
            setDugLayout()
        }
        setNaviButtonAction()
        setupTableView()
        setReviewTextView()
        setPressAction()
        reviewViewKeyboardButtonAction()
        hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.addKeyboardObserver()
    }
    
    override func viewWillLayoutSubviews() {
        setDynamicLayout()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.removeKeyboardObserver()
    }
    
    // MARK: - Function
    private func setDynamicLayout() {
        /// 테이블 뷰 contentSize.height 보다 1이상 커야지 footer뷰가 제대로 나옴
        let tableContentHeight = worryDetailTV.contentSize.height + 1
        worryDetailTV.snp.updateConstraints {
            $0.height.equalTo(tableContentHeight)
        }
        switch pageType {
        case .digging:
            worryDetailScrollView.snp.updateConstraints {
                $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(89.adjustedH)
            }
            
            worryDetailContentView.snp.updateConstraints {
                $0.height.equalTo(tableContentHeight)
            }
        case .dug:
            if reviewTextViewHeight > defaultTextViewHeight {
                worryDetailContentView.snp.updateConstraints {
                    $0.height.equalTo(tableContentHeight + reviewSpacing + restReviewViewHeight + reviewTextViewHeight)
                }
                reviewView.snp.updateConstraints {
                    $0.height.equalTo(restReviewViewHeight + reviewTextViewHeight
                                      + 10)
                }
                
            }else {
                worryDetailContentView.snp.updateConstraints {
                    $0.height.equalTo(tableContentHeight + reviewSpacing + restReviewViewHeight + defaultTextViewHeight)
                }
                
                reviewView.snp.updateConstraints {
                    $0.height.equalTo(restReviewViewHeight + defaultTextViewHeight)
                }
            }
        }
    }
    
    private func setNaviButtonAction() {
        navigationBarView.setLeftButtonAction { [weak self] in
            self?.dismiss(animated: true, completion: nil)
        }
        navigationBarView.setRightButtonAction {
            let editVC = HomeWorryEditVC(worryId: self.worryId, editType: self.pageType)
            editVC.worryDetail = self.worryDetailViewModel.worryDetail
            editVC.modalPresentationStyle = .overCurrentContext
            editVC.modalTransitionStyle = .crossDissolve
            self.present(editVC, animated: true)
        }
    }
    
    private func setupTableView() {
        worryDetailTV.dataSource = self
        worryDetailTV.delegate = self
        worryDetailTV.register(HomeWorryDetailTVC.self, forCellReuseIdentifier: HomeWorryDetailTVC.className)
        worryDetailTV.register(HomeWorryDetailHeaderView.self, forHeaderFooterViewReuseIdentifier: HomeWorryDetailHeaderView.className)
        worryDetailTV.register(HomeWorryDetailFooterView.self, forHeaderFooterViewReuseIdentifier: HomeWorryDetailFooterView.className)
        /// estimated 높이를 설정해줘야 contentSize에 반영이 됨
        worryDetailTV.estimatedSectionHeaderHeight = 200
        worryDetailTV.estimatedRowHeight = 200
        worryDetailTV.estimatedSectionFooterHeight = 200
        worryDetailTV.backgroundView = backgroundImageView
    }
    
    private func setReviewTextView() {
        reviewView.reviewTextView.delegate = self
    }
    
    private func setPressAction() {
        digWorryButton.press {
            let vc = WorryDecisionVC()
            vc.setWorryInfo(worryId: self.worryId, templateid: self.templateId)
            vc.modalPresentationStyle = .overCurrentContext
            vc.modalTransitionStyle = .crossDissolve
            vc.setKeyboardAction()
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    private func dataBind() {
        let output = worryDetailViewModel.transform(
            input: HomeWorryDetailViewModel.Input(input)
        )
        output.receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure:
                    self?.presentNetworkAlert()
                }
            }, receiveValue: { [weak self] worryDetail in
                self?.updateUI(worryDetail: worryDetail)
            })
            .store(in: &cancellables)
    }
    
    private func updateUI(worryDetail: WorryDetailModel) {
        self.stopLoadingAnimation()
        
        questions = worryDetail.subtitles
        answers = worryDetail.answers
        updateDate = worryDetail.updatedAt
        worryTitle = worryDetail.title
        templateId = worryDetail.templateId
        period = worryDetail.period
        
        switch pageType {
        case .digging:
            updateDeadline(deadline: worryDetail.dDay)

        case .dug:
            navigationBarView.setTitleText(text: "나의 고민")

            if let finalAnswer = worryDetail.finalAnswer {
                self.finalAnswer = finalAnswer
            }
            if let content = worryDetail.review.content {
                self.reviewText = content
                self.reviewView.setReviewText(content: content)
            }
            
            if let updatedAt = worryDetail.review.updatedAt {
                reviewView.setUpdatedDate(updatedAt: updatedAt)
            }
        }
        
        /// 갱신된 데이터로 테이블뷰 정보를 갱신
        /// -> 갱신된 데이터를 적용한 콘텐트 크기를 아직 모르니 contentSize는 각 셀,헤더,푸터의 estimatedSize 합으로 일단 지정됨
        worryDetailTV.reloadData()
        /// worryDetailTV 높이를 contentSize.height으로 업데이트
        worryDetailTV.frame.size.height = worryDetailTV.contentSize.height
        /// layout을 업데이트 시키면서 worryDetailTV의 콘텐트 사이즈 값이 실제 크기에 맞게 조정
        /// -> layoutSubView 메서드가 호출되면서 setDynamicLayout호출
        worryDetailTV.layoutIfNeeded()
    }
    
    /// 전달 받은 수정된 데드라인 일자로 navigationBar Title 변경
    func updateDeadline(deadline: Int) {
        var dDay = ""
        if deadline < -800 || deadline > 800 {
            dDay = "-∞"
        } else if deadline < 0 {
            dDay = "\(deadline)"
        } else if deadline > 0 {
            dDay = "+\(deadline)"
        } else if deadline == 0 {
            dDay = "-day"
        }
        navigationBarView.setTitleText(text: "고민캐기 D\(dDay)")
    }
    
    func sendInputWithWorryId(id: Int) {
        self.startLoadingAnimation()
        input.send(id)
    }
    
    private func reviewViewKeyboardButtonAction() {
        reviewView.setPressAction { [weak self] in
            self?.patchReviewText()
        }
    }
    
    private func presentReviewAlert() {
        let alertVC = KaeraAlertVC(okTitle: "삭제")
        alertVC.setTitleSubTitle(title: "기록을 취소하시나요?", subTitle: "작성된 기록이 저장되지 않았어요.")
        alertVC.OKButton.press {  [weak self] in
            self?.reviewView.updateReviewContent(text: self?.reviewText ?? "")
            self?.dismiss(animated: true) {
                self?.view.endEditing(true)
            }
        }
        alertVC.addCancelPressAction { [weak self] in
            self?.reviewView.reviewTextView.becomeFirstResponder()
        }
        self.present(alertVC, animated: true)
    }
}
// MARK: - KeyBoard
extension HomeWorryDetailVC {
    private func addKeyboardObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillAppear),
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
            object: nibName
        )
        
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillHideNotification,
            object: nibName
        )
    }
    
    @objc
    func keyboardWillAppear(_ notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            UIView.animate(withDuration: 0.1, animations: {
                self.worryDetailScrollView.contentInset.bottom = keyboardSize.height + 50
            })
        }
    }
    @objc
    func keyboardWillDisappear(_ notification: NSNotification) {
        worryDetailScrollView.contentInset.bottom = .zero
        if isReviewEditing {
            presentReviewAlert()
        }
        isReviewEditing = false
    }
}

//TODO: 뷰모델로 데이터 처리를 넘기도록 리팩토링!
// MARK: - Network
extension HomeWorryDetailVC {
    func patchReviewText() {
        self.reviewText = reviewView.reviewTextView.text ?? ""
        let reviewModel = WorryReviewRequestBody(worryId: worryId, review: reviewText)
        self.startLoadingAnimation()
        HomeAPI.shared.patchReview(body: reviewModel) { [weak self] res in
            guard let data = res?.data else {
                self?.presentNetworkAlert()
                return
            }
            self?.stopLoadingAnimation()
            self?.reviewView.updateReviewDate(date: data.updatedAt)
            self?.isReviewEditing = false
            self?.view.endEditing(true)
            self?.showToastMessage(message: "작성완료!", color: .black)
        }
    }
}

// MARK: - TextView
extension HomeWorryDetailVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        var inputText = ""
        inputText = textView.text == placeholderText ? " " : textView.text
        /// 행간 간격 150% 설정
        let style = NSMutableParagraphStyle()
        style.lineSpacing = UIFont.kB4R14.lineHeight * 0.5
        let attributedText = NSAttributedString(
            string: inputText,
            attributes: [
                .paragraphStyle: style,
                .foregroundColor: UIColor.kWhite,
                .font: UIFont.kB4R14
            ]
        )
        textView.attributedText = attributedText
        
        isReviewEditing = true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = placeholderText
            textView.textColor = .kGray5
            textView.font = .kSb1R12
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let fixedWidth = textView.frame.size.width
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        self.reviewTextViewHeight = newSize.height
    }
}


// MARK: - UITableView
extension HomeWorryDetailVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeWorryDetailTVC.className) as? HomeWorryDetailTVC else { return UITableViewCell() }
        if questions.count > indexPath.row && answers.count > indexPath.row {
            cell.setData(question: questions[indexPath.row], answer: answers[indexPath.row])
        } else {
            cell.setData(question: "No Data", answer: "No Data")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerCell = tableView.dequeueReusableHeaderFooterView(withIdentifier: HomeWorryDetailHeaderView.className) as? HomeWorryDetailHeaderView else { return nil }
        headerCell.setData(templateId: self.templateId, title: self.worryTitle, type: pageType, period: period)
        return headerCell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let footerCell = tableView.dequeueReusableHeaderFooterView(withIdentifier: HomeWorryDetailFooterView.className) as? HomeWorryDetailFooterView else { return nil }
        
        switch pageType {
        case .digging:
            footerCell.setData(updateAt: updateDate)
            footerCell.setDiggingLayout()
        case .dug:
            footerCell.setData(updateAt: updateDate, finalAnswer: finalAnswer)
            footerCell.setDugLayout()
        }
        return footerCell
    }
}

// MARK: - UI
extension HomeWorryDetailVC {
    private func setLayout() {
        self.view.addSubviews([navigationBarView, worryDetailScrollView])
        
        navigationBarView.snp.makeConstraints {
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.height.equalTo(50)
        }
        
        worryDetailScrollView.snp.makeConstraints {
            $0.top.equalTo(navigationBarView.snp.bottom)
            $0.directionalHorizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        worryDetailScrollView.addSubview(worryDetailContentView)
        
        /// contentLayoutGuide, frameLayoutGutide에 constraint를 잡아줘야함
        worryDetailContentView.snp.makeConstraints {
            $0.edges.equalTo(worryDetailScrollView.contentLayoutGuide)
            $0.width.equalTo(worryDetailScrollView.frameLayoutGuide)
            $0.height.equalTo(100)
        }
        
        worryDetailContentView.addSubview(worryDetailTV)
        
        worryDetailTV.snp.makeConstraints {
            $0.directionalHorizontalEdges.equalToSuperview()
            $0.top.equalToSuperview()
            $0.height.equalTo(worryDetailTV.contentSize.height)
        }
        
    }
    
    private func setDiggingLayout() {
        self.view.addSubviews([bottmContainerView])
        
        navigationBarView.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(16)
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.height.equalTo(50)
        }
        
        bottmContainerView.snp.makeConstraints {
            $0.directionalHorizontalEdges.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(89.adjustedH)
        }
        
        bottmContainerView.addSubview(digWorryButton)
        
        digWorryButton.snp.makeConstraints {
            $0.directionalHorizontalEdges.equalToSuperview().inset(16)
            $0.top.equalToSuperview().inset(20)
            $0.height.equalTo(52.adjustedH)
        }
    }
    
    private func setDugLayout() {
        worryDetailContentView.addSubview(reviewView)
        
        reviewView.snp.makeConstraints {
            $0.directionalHorizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview().inset(16)
            $0.height.equalTo(restReviewViewHeight + defaultTextViewHeight)
        }
    }
}


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
    
    private let navigationBarView = CustomNavigationBarView(leftType: .close, rightType: .edit, title: "고민캐기")
    
    private let worryDetailTV = UITableView().then {
        $0.backgroundColor = .clear
        $0.isScrollEnabled = false
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
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
    
    private var worryId = 1
    private var questions = [String]()
    private var answers = [String]()
    private var updateDate = ""
    private var worryTitle = ""
    private var templateId = 1
    private var deadline = ""
    private var pageType: PageType = .digging
    
    private let reviewView = WorryDetailReviewView()
    private let restReviewViewHeight: CGFloat = 67
    private var defaultTextViewHeight: CGFloat = 53
    private let reviewSpacing: CGFloat = 32
    private let placeholderText = "이 고민을 통해 배운점 또는 생각을 자유롭게 적어보세요"
    private var reviewTextViewHeight: CGFloat = 0

    // MARK: - Initialization
    init(worryId: Int, type: PageType) {
        super.init(nibName: nil, bundle: nil)
        self.worryId = worryId
        self.pageType = type
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        dataBind()
    }
    override func viewWillLayoutSubviews() {
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
    }
    
    // MARK: - Function
    private func setNaviButtonAction() {
        navigationBarView.setLeftButtonAction {
            self.dismiss(animated: true, completion: nil)
        }
        
        navigationBarView.setRightButtonAction {
            //TODO: edit 창 띄우기
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
        worryDetailTV.rowHeight = UITableView.automaticDimension
        worryDetailTV.sectionHeaderHeight = UITableView.automaticDimension
        worryDetailTV.sectionFooterHeight = UITableView.automaticDimension
        worryDetailTV.backgroundView = backgroundImageView
    }
    
    private func setReviewTextView() {
        reviewView.reviewTextView.delegate = self
    }
    
    private func dataBind() {
        let output = worryDetailViewModel.transform(
            input: HomeWorryDetailViewModel.Input(input)
        )
        output.receive(on: DispatchQueue.main)
            .sink { [weak self] worryDetail in
                self?.updateUI(worryDetail: worryDetail)
            }.store(in: &cancellables)
        /// input 전달
        input.send(worryId)
    }
    
    private func updateUI(worryDetail: WorryDetailModel) {
        questions = worryDetail.questions
        answers = worryDetail.answers
        updateDate = worryDetail.updatedAt
        worryTitle = worryDetail.title
        templateId = worryDetail.templateId
        /// 넘어오는 값이 -1일 경우 String 값으로 표현
        deadline = worryDetail.deadline < 0 ? "∞" : "\(worryDetail.deadline)"
        navigationBarView.setTitleText(text: "고민캐기 D-\(deadline)")
        worryDetailTV.reloadData()
    }
    
}
// MARK: - TextView
extension HomeWorryDetailVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        var inputText = ""
        inputText = textView.text == placeholderText ? "  " : textView.text
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
        headerCell.setData(templateId: self.templateId, title: self.worryTitle)
        
        return headerCell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let footerCell = tableView.dequeueReusableHeaderFooterView(withIdentifier: HomeWorryDetailFooterView.className) as? HomeWorryDetailFooterView else { return nil }
        footerCell.setData(updateAt: updateDate)
        switch pageType {
        case .digging:
            footerCell.setDiggingLayout()
        case .dug:
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
            $0.left.right.equalToSuperview().inset(16)
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

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
    
    // MARK: - Initialization
    init(worryId: Int) {
        super.init(nibName: nil, bundle: nil)
        self.worryId = worryId
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .kGray1
        setLayout()
        setNaviButtonAction()
        setupTableView()
        dataBind()
    }
    
    override func viewWillLayoutSubviews() {
        worryDetailScrollView.contentSize.height = worryDetailTV.contentSize.height
        worryDetailContentView.snp.updateConstraints {
            /// 테이블 뷰보다 높이가 1이상 커야지 footer뷰가 제대로 나옴
            $0.height.equalTo(worryDetailTV.contentSize.height + 1)
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
        print("worryDetail",worryDetail)
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

// MARK: - UITableView
extension HomeWorryDetailVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //TODO: 하드 코딩 수정 필요 - 데이터의 텍스트를 반영한 높이에 따라 달라지도록
        /// 셀 높이 + 여백
        return 100 + 28.adjustedH
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        /// 헤더의 높이 + 헤더와 첫번째 셀간의 간격
        return 139.adjustedH + 36.adjustedH
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 14 + 72.adjustedH
    }
}

extension HomeWorryDetailVC: UITableViewDataSource {
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
        footerCell.setData(updataAt: updateDate)
        return footerCell
    }
}

// MARK: - UI
extension HomeWorryDetailVC {
    private func setLayout() {
        self.view.addSubviews([navigationBarView, worryDetailScrollView, bottmContainerView])
        
        navigationBarView.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(16)
            $0.top.equalToSuperview().inset(70)
            $0.height.equalTo(50)
        }
        
        bottmContainerView.snp.makeConstraints {
            $0.directionalHorizontalEdges.bottom.equalToSuperview()
            $0.height.equalTo(126.adjustedH)
        }
        
        bottmContainerView.addSubview(digWorryButton)
        
        digWorryButton.snp.makeConstraints {
            $0.directionalHorizontalEdges.equalToSuperview().inset(16)
            $0.top.equalToSuperview().inset(20)
            $0.height.equalTo(52.adjustedH)
        }
        
        worryDetailScrollView.snp.makeConstraints {
            $0.top.equalTo(navigationBarView.snp.bottom)
            $0.directionalHorizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(89.adjustedH)
        }
        
        worryDetailScrollView.addSubview(worryDetailContentView)
        
        /// contentLayoutGuide, frameLayoutGutide에 constraint를 잡아줘야함
        worryDetailContentView.snp.makeConstraints {
            $0.edges.equalTo(worryDetailScrollView.contentLayoutGuide)
            $0.width.equalTo(worryDetailScrollView.frameLayoutGuide)
            $0.height.equalTo(100)
        }
        
        worryDetailContentView.addSubviews([backgroundImageView, worryDetailTV])
        
        backgroundImageView.snp.makeConstraints {
            $0.directionalHorizontalEdges.top.equalToSuperview()
            /// 바닥이 하단 뷰에 잘리지 않도록 이미지에 inset 추가
            $0.bottom.equalToSuperview().inset(5)
        }
        
        worryDetailTV.snp.makeConstraints {
            $0.directionalHorizontalEdges.equalToSuperview().inset(14)
            $0.verticalEdges.equalToSuperview()
        }
    }
}

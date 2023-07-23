//
//  HomeWorryDetailVC.swift
//  KAERA
//
//  Created by 김담인 on 2023/07/21.
//

import UIKit
import SnapKit
import Then

final class HomeWorryDetailVC: UIViewController {
    
    // MARK: - Properties
    private let navigationBarView = CustomNavigationBarView(leftType: .close, rightType: .edit, title: "고민캐기")
    private var deadLineDays = 1
    
    private let worryDetailTV = UITableView().then {
//        $0.estimatedRowHeight = 100
//        $0.rowHeight = UITableView.automaticDimension
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
    
    // MARK: - Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .kGray1
        setLayout()
        setNaviButtonAction()
        //TODO: 서버에서 넘어오는 데드라인 값을 넣어 실행
        navigationBarView.setTitleText(text: "고민캐기 D-\(deadLineDays)")
        setupTableView()
    }
    
    override func viewWillLayoutSubviews() {
        print(worryDetailScrollView.contentSize.height)
        print(worryDetailTV.contentSize.height)
        worryDetailScrollView.contentSize.height = worryDetailTV.contentSize.height + 50
        worryDetailContentView.snp.updateConstraints {
            $0.height.equalTo(worryDetailTV.contentSize.height + 30)
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
    }
}

// MARK: - UITableView
extension HomeWorryDetailVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100 + 28
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        /// 헤더의 높이 + 헤더와 첫번째 셀간의 간격
        return 139.adjustedH + 36.adjustedH
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        print(tableView.contentSize)
    }
}

extension HomeWorryDetailVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeWorryDetailTVC.className) as? HomeWorryDetailTVC else { return UITableViewCell() }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerCell = tableView.dequeueReusableHeaderFooterView(withIdentifier: HomeWorryDetailHeaderView.className) as? HomeWorryDetailHeaderView else { return nil }
        return headerCell
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
            //TODO: 동적으로 변경
            $0.height.equalTo(1000.adjustedH)
            $0.edges.equalTo(worryDetailScrollView.contentLayoutGuide)
            $0.width.equalTo(worryDetailScrollView.frameLayoutGuide)
        }

        worryDetailContentView.addSubviews([backgroundImageView, worryDetailTV])

        backgroundImageView.snp.makeConstraints {
            $0.directionalHorizontalEdges.top.equalToSuperview()
            $0.bottom.equalToSuperview().inset(5) /// 배경이미지 하단이 안짤리도록 inset 추가
        }
        
        worryDetailTV.snp.makeConstraints {
            $0.directionalHorizontalEdges.equalToSuperview().inset(14)
            $0.verticalEdges.equalToSuperview()
        }
    }
}

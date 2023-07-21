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
    private let backGroundImageView = UIImageView().then {
        $0.image = UIImage(named: "framebg")
    }
    private let worryDetailTV = UITableView().then {
        $0.estimatedRowHeight = 93
        $0.rowHeight = UITableView.automaticDimension
        $0.backgroundColor = .clear
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
        worryDetailTV.backgroundView = backGroundImageView
        worryDetailTV.dataSource = self
        worryDetailTV.delegate = self
        worryDetailTV.register(HomeWorryDetailTVC.self, forCellReuseIdentifier: HomeWorryDetailTVC.className)
    }
}

extension HomeWorryDetailVC: UITableViewDelegate {
    
}

extension HomeWorryDetailVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeWorryDetailTVC.className) as? HomeWorryDetailTVC else { return UITableViewCell() }
        return cell
    }
    
    
}

// MARK: - UI
extension HomeWorryDetailVC {
    private func setLayout() {
        self.view.addSubviews([navigationBarView, worryDetailTV])
        
        navigationBarView.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(16)
            $0.top.equalToSuperview().inset(70)
            $0.height.equalTo(50)
        }
        
        worryDetailTV.snp.makeConstraints {
            $0.directionalHorizontalEdges.equalToSuperview().inset(16)
            $0.top.equalTo(navigationBarView.snp.bottom)
            $0.bottom.equalToSuperview()
        }
    }
}

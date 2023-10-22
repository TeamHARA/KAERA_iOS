//
//  MyPageVC.swift
//  KAERA
//
//  Created by 김담인 on 2023/10/15.
//

import UIKit
import SnapKit
import Then
import Combine

final class MyPageVC: BaseVC {
    
    // MARK: - Components
    private let navigationBarView = CustomNavigationBarView(leftType: .back, rightType: nil, title: "마이페이지")
    
    private let userInfoBarView = UIView().then {
        $0.backgroundColor = .kGray2
        $0.makeRounded(cornerRadius: 8)
    }
    
    private lazy var nameLabel = UILabel().then {
        $0.text = userName
        $0.font = .kH1B20
        $0.textColor = .kWhite
    }
    
    private lazy var loginMark = UIImageView().then {
        let imageName: String = loginType == .kakao ? "icn_kakao" : "icn_apple"
        $0.image = UIImage(named: imageName)
    }
    
    private let myPageTV: UITableView = {
        let tv = UITableView(frame: .zero, style: .grouped)
        tv.backgroundColor = .clear
        tv.separatorStyle = .none
        tv.bounces = false
        tv.showsVerticalScrollIndicator = false
        tv.showsHorizontalScrollIndicator = false
        tv.allowsSelection = false
        return tv
    }()
    
    
    // MARK: - Properties
    private let userName = "캐라님"
    private let loginType: LoginType = .kakao
    private let myPageViewModel = MyPaggeViewModel()
    private let input = PassthroughSubject<MyPageInputType, Never>.init()
    private var cancellables = Set<AnyCancellable>()
    private var myPageTVCData = [MyPageTVCModel]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setTV()
        dataBind()
        input.send(.loadData)
        setNotificationCenter()
    }
    
    /// 앱 상태 변화 observer 세팅 함수
    private func setNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector:  #selector(checkPushState), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    @objc private func checkPushState() {
        input.send(.action(indexPath: IndexPath(row: 0, section: 0)))
    }
    
    private func setPressAction() {
        self.navigationBarView.setLeftButtonAction {
            self.dismiss(animated: true)
        }
    }
    
    private func setTV() {
        myPageTV.delegate = self
        myPageTV.dataSource = self
        
        myPageTV.register(MyPageTVC.self, forCellReuseIdentifier: MyPageTVC.className)
        
        myPageTV.register(MyPageTVHeaderView.self, forHeaderFooterViewReuseIdentifier: MyPageTVHeaderView.className)
        myPageTV.register(MyPageTVFooterView.self, forHeaderFooterViewReuseIdentifier: MyPageTVFooterView.className)
        
    }
    
    private func dataBind() {
        let output = myPageViewModel.transform(input: MyPaggeViewModel.Input(input))
        
        output.receive(on: DispatchQueue.main)
            .sink { [weak self] output in
                self?.handleOutput(output: output)
            }
            .store(in: &cancellables)
        
    }
    
    private func handleOutput(output: MyPageOutputType) {
        switch output {
        case .data(let data):
            self.myPageTVCData = data
            self.myPageTV.reloadData()
        case .push(let hasChanged):
            if hasChanged {
                myPageTV.reloadData()
            }
            print("push")
        case .notice:
            print("notice")
        case .account:
            print("account")
        }
    }

}

// MARK: - UITableView
extension MyPageVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return myPageTVCData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myPageTVCData[section].rowTitles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MyPageTVC.className) as? MyPageTVC else { return UITableViewCell() }
        let title = myPageTVCData[indexPath.section].rowTitles[indexPath.row]
        let buttonType = myPageTVCData[indexPath.section].rowButton
        
        cell.removeButtonTarget()
        cell.configureCell(labelText: title, buttonType: buttonType)
//        cell.cellButton.press {
//            self.input.send(.action(indexPath: indexPath))
//        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerCell = tableView.dequeueReusableHeaderFooterView(withIdentifier: MyPageTVHeaderView.className) as? MyPageTVHeaderView else { return nil }
        let headerTitle = myPageTVCData[section].headerTitle
        headerCell.setTitle(title: headerTitle)
        return headerCell
    }
    
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let footerCell = tableView.dequeueReusableHeaderFooterView(withIdentifier: MyPageTVFooterView.className) as? MyPageTVFooterView else { return nil }
        return footerCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64.adjustedH
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if myPageTVCData[section].headerTitle.count == 0 {
            return 0
        }
        return UITableView.automaticDimension
    }

    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if myPageTVCData.count == section + 1 {
            return 0
        }
        return 40.adjustedH
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        input.send(.action(indexPath: indexPath))
    }
}

// MARK: - UI
extension MyPageVC {
    
    private func setUI() {
        self.view.backgroundColor = .kGray1
        self.view.addSubviews([navigationBarView, userInfoBarView, myPageTV])
        
        navigationBarView.snp.makeConstraints {
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.height.equalTo(50)
        }
        
        userInfoBarView.snp.makeConstraints {
            $0.top.equalTo(navigationBarView.snp.bottom).offset(36.adjustedH)
            $0.leading.equalTo(view.safeAreaLayoutGuide).inset(15)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
            $0.height.equalTo(68.adjustedH)
        }
        
        userInfoBarView.addSubviews([nameLabel, loginMark])
        
        nameLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
        }
        
        loginMark.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(32.adjustedW)
            $0.centerY.equalToSuperview()
        }
        
        myPageTV.snp.makeConstraints {
            $0.directionalHorizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.top.equalTo(userInfoBarView.snp.bottom).offset(13.adjustedH)
            
        }
        
    }
}

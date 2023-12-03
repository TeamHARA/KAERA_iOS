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
    
    private let nameLabel = UILabel().then {
        let userName = KeychainManager.load(key: .userName) ?? "해라"
        let addedName = userName + " 님"
        $0.text = addedName
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
    private let loginType: LoginType = UserDefaults.standard.bool(forKey: "isKakaoLogin") ? LoginType.kakao : LoginType.apple
    private let myPageViewModel = MyPaggeViewModel()
    private let input = PassthroughSubject<MyPageInputType, Never>.init()
    private var cancellables = Set<AnyCancellable>()
    private var myPageTVCData = [MyPageTVCModel]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setTV()
        setPressAction()
        dataBind()
        startLoadingAnimation()
        input.send(.loadData)
        setNotificationCenter()
    }
    
    private func setNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector:  #selector(shouldCheckState), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    @objc private func shouldCheckState() {
        startLoadingAnimation()
        input.send(.push)
    }
    
    private func setPressAction() {
        self.navigationBarView.setLeftButtonAction { [weak self] in
            self?.navigationController?.popViewController(animated: true)
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
                self?.stopLoadingAnimation()
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
        case .accountAction:
            if let alertVC = self.presentedViewController {
                alertVC.dismiss(animated: true) {
                    if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                        // window의 rootViewController 설정
                        sceneDelegate.window?.rootViewController = SplashVC()
                    }

                }
            }
            
        case .networkFail:
            if let alertVC = self.presentedViewController {
                alertVC.dismiss(animated: true) { [weak self] in
                    self?.presentNetworkAlert()
                }
            }
            
        }
        
    }
    
    private func presentAccountAlertVC(data: MyPageAccountAlertInfoModel) {
        let alertVC = KaeraAlertVC(okTitle: data.okTitle)
        alertVC.setTitleSubTitle(title: data.title, subTitle: data.subTitle)
        switch data.type {
        case .signOut:
            alertVC.OKButton.press { [weak self] in
                self?.startLoadingAnimation()
                self?.input.send(.accountAction(type: .signOut))
            }
        case .delete:
            alertVC.OKButton.press { [weak self] in
                self?.startLoadingAnimation()
                self?.input.send(.accountAction(type: .delete))
            }
        }
        self.present(alertVC, animated: true)
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
        
        cell.clearButtonState()
        cell.updateCellContent(titleText: title, buttonType: buttonType)
        switch buttonType {
        case .push:
            cell.setPushButtonAction()
        case .next(let myPageURLs):
            if myPageURLs.indices.contains(indexPath.row) {
                let url = myPageURLs[indexPath.row]
                cell.setNextButtonAction { [weak self] in
                    self?.openSafariVC(url: url)
                }
            }
        case .account(let info):
            if info.indices.contains(indexPath.row) {
                cell.setAccountButtonAction { [weak self] in
                    self?.presentAccountAlertVC(data: info[indexPath.row])
                }
            }
        }
    
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

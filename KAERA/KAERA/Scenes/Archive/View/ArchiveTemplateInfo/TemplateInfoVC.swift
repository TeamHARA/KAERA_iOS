//
//  TemplateInfoVC.swift
//  KAERA
//
//  Created by saint on 2023/07/14.
//

import UIKit
import SnapKit
import Then
import Combine

class TemplateInfoVC: UIViewController, TemplateInfoTVCDelegate {
    
    // MARK: - Properties
    private let titleLabel = UILabel().then {
        $0.text = "고민 작성지"
        $0.textColor = .white
        $0.font = .kH1B20
    }
    
    let backBtn = UIButton().then {
        $0.setBackgroundImage(UIImage(named: "icn_back"), for: .normal)
        $0.contentMode = .scaleToFill
        $0.backgroundColor = .clear
    }
    
    private let headerView = TemplateInfoHeaderView()
    
    private lazy var templateInfoTV = UITableView(frame: .zero, style: .grouped).then {
        $0.backgroundColor = .kGray1
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.separatorStyle = .none
        $0.showsVerticalScrollIndicator = false
        $0.delegate = self
        $0.dataSource = self
    }
    
    var expandedCells = [Bool]()
    
    private let templateVM = TemplateViewModel()
    private var cancellables = Set<AnyCancellable>()
    private var templateInfoList: [TemplateInfoPublisherModel] = []
    private let input = PassthroughSubject<Void, Never> ()
    
    // writeVC Modal시에 화면에 띄어줄 제목을 담아서 보내줌
    private var templateTitleShortInfoList:
    [TemplateInfoPublisherModel] = []
    
    private let writeModalVC = WriteModalVC()
    
    private var templateId: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataBind()
        setLayout()
        pressBtn()
        registerTV()
        resetCellStatus()
        setObserver()
        sendTitleInfo()
        input.send() /// 구독 후 ViewModel과 데이터를 연동
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        resetCellStatus()
        templateInfoTV.reloadData()
    }
    
    // MARK: - Functions
    private func pressBtn() {
        backBtn.press {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    private func registerTV() {
        templateInfoTV.register(TemplateInfoTVC.self,
                                forCellReuseIdentifier: TemplateInfoTVC.classIdentifier)
    }
    
    private func resetCellStatus() {
        expandedCells = Array(repeating: false, count: 6) /// cell들의 속성을 모두 false로 초기화
    }
    
    private func setObserver() {
        /// 각 cell이 클릭될때 indexpath를 전달해주기 위해 notificationCenter 사용
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.didExpandTVC(_:)),
            name: NSNotification.Name("CellTouched"),
            object: nil
        )
    }
    
    @objc func didExpandTVC(_ notification: Notification) {
        if let indexPath = notification.userInfo?["indexPath"] as? IndexPath {
            /// Cell의 상태를 담고 있는 Bool 배열에서 click된 cell의 상태를 변경 (true <-> false)
            expandedCells[indexPath.row] = !expandedCells[indexPath.row]
            templateInfoTV.reloadRows(at: [indexPath], with: .automatic)
            print(expandedCells)
        }
    }
    
    private func dataBind() {
        let output = templateVM.transform(input: input.eraseToAnyPublisher())
        output.receive(on: DispatchQueue.main)
            .sink { [weak self] list in
                self?.updateTV(list)
            }
            .store(in: &cancellables)
    }
    
    private func updateTV(_ list: [TemplateInfoPublisherModel]) {
        templateInfoList = list
        templateInfoTV.reloadData()
    }
    
    // writeVC Modal시에 화면에 띄어줄 title 및 shortInfo를 보내주기 위한 함수
    private func sendTitleInfo() {
        let output = templateVM.transform(input: input.eraseToAnyPublisher())
        output.receive(on: DispatchQueue.main)
            .sink { [weak self] list in
                self?.templateTitleShortInfoList = list
            }
            .store(in: &cancellables)
    }
    
    // MARK: - TemplateInfoTVCDelegate
    func didPressWritingButton(templateId: Int) {
        let writeVC = WriteVC()
        writeVC.modalPresentationStyle = .fullScreen
        self.present(writeVC, animated: true, completion: nil)
        writeVC.dataBind()
        self.templateId = templateId
        writeVC.input.send(templateId)
        writeVC.templateReload(templateId: templateId, templateTitle: self.templateTitleShortInfoList[templateId].templateTitle, templateInfo: self.templateTitleShortInfoList[templateId].templateDetail)
    }
}

// MARK: - Layout
extension TemplateInfoVC{
    func setLayout() {
        view.backgroundColor = .kGray1
        view.addSubViews([titleLabel, backBtn, headerView, templateInfoTV])
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(24.adjustedW)
            $0.centerX.equalToSuperview()
        }
        
        backBtn.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(24.adjustedW)
            $0.leading.equalToSuperview().offset(16.adjustedW)
            $0.width.equalTo(24)
            $0.height.equalTo(24)
        }
        
        headerView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20.adjustedW)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(342.adjustedW)
            $0.height.equalTo(168.adjustedW)
        }
        
        templateInfoTV.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom).offset(16.adjustedW)
            $0.leading.equalTo(self.view.safeAreaLayoutGuide).offset(16.adjustedW)
            $0.trailing.equalTo(self.view.safeAreaLayoutGuide).offset(-16.adjustedW)
            $0.bottom.equalToSuperview().offset(-20.adjustedW)
        }
    }
}

// MARK: - UITableViewDelegate
extension TemplateInfoVC: UITableViewDelegate {
    
    /// tableView와 Header 사이에 생기는 공백을 제거해주기 위해 빈뷰를 추가
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        /// expand 된 cell의 높이에 맞게 자동으로 변경해주기 위함
        return UITableView.automaticDimension
    }
}

// MARK: - UITableViewDataSource
extension TemplateInfoVC : UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return templateInfoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TemplateInfoTVC.classIdentifier, for: indexPath) as? TemplateInfoTVC else {return UITableViewCell()}
        
        cell.settingData(isExpanded: expandedCells[indexPath.row])
        /// 각 cell 클릭 시 해당하는 cell의 indexPath를 TVC의 indexPath로 전달
        cell.indexPath = indexPath
        cell.delegate = self
        
        cell.dataBind(model: templateInfoList[indexPath.row])
        
        return cell
    }
}

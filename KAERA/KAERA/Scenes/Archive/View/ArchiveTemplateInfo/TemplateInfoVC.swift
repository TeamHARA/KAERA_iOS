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

class TemplateInfoVC: UIViewController {
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        pressBtn()
        registerTV()
        resetCellStatus()
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
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        expandedCells[indexPath.row] = !expandedCells[indexPath.row]
        tableView.reloadRows(at: [indexPath], with: .automatic)
        print(expandedCells)
    }
}

// MARK: - UITableViewDataSource
extension TemplateInfoVC : UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TemplateInfoTVC.classIdentifier, for: indexPath) as? TemplateInfoTVC else {return UITableViewCell()}
        
        cell.settingData(isExpanded: expandedCells[indexPath.row])
        cell.layoutIfNeeded()
        return cell
    }
}

//
//  TemplateContentTV.swift
//  KAERA
//
//  Created by saint on 2023/08/12.
//

import UIKit
import Combine
import SnapKit
import Then

class TemplateContentTV: UITableView {
    
    // MARK: - Properties
    var templateId: Int = 0
    var questions: [String] = []
    var hints: [String] = []
    
    let contentInfo = ContentInfo.shared
    
    // MARK: - Life Cycle
    init() {
        super.init(frame: .zero, style: .grouped)
        registerTV()
        setTV()
        setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    private func registerTV() {
        self.register(TemplateContentTVC.self,
                      forCellReuseIdentifier: TemplateContentTVC.classIdentifier)
        self.register(TemplateContentHeaderView.self, forHeaderFooterViewReuseIdentifier: TemplateContentHeaderView.className)
        self.estimatedSectionHeaderHeight = 110.adjustedH
    }
    
    private func setUI() {
        self.backgroundColor = .kGray1
        self.separatorStyle = .none
        self.showsVerticalScrollIndicator = false
    }
    
    private func setTV() {
        self.delegate = self
        self.dataSource = self
    }
}

// MARK: - UITableViewDelegate
extension TemplateContentTV: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        /// 헤더의 높이 + 헤더와 첫번째 셀간의 간격
        return 74.adjustedH + 36.adjustedH
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        /// expand 된 cell의 높이에 맞게 자동으로 변경해주기 위함
        return UITableView.automaticDimension
    }
}

// MARK: - UITableViewDataSource
extension TemplateContentTV : UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questions.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerCell = tableView.dequeueReusableHeaderFooterView(withIdentifier: TemplateContentHeaderView.className) as? TemplateContentHeaderView else { return nil }
        headerCell.worryTitleTextField.becomeFirstResponder()

        /// headerCell에 입력된 고민 제목을 contentInfo에 담아준다. 
        headerCell.delegate = self
        
        return headerCell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TemplateContentTVC.classIdentifier, for: indexPath) as? TemplateContentTVC else {return UITableViewCell()}
        
        cell.dataBind(question: questions[indexPath.row], hint: hints[indexPath.row])
        
        return cell
    }
}

extension TemplateContentTV: TemplateContentHeaderViewDelegate,  TemplateContentTVCDelegate {
    func textFieldDidEndEditing(view: TemplateContentHeaderView, newText: String) {
        contentInfo.title = newText
    }
    
    func textViewDidEndEditing(cell: TemplateContentTVC, newText: String) {

        if let indexPath = indexPath(for: cell) {
            /// 각 cell의 힌트를 작성된 텍스트로 변경하여 contentInfo에 담아준다.
            hints[indexPath.row] = newText
            contentInfo.answers = hints
        }
    }
}

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
    private var questions: [String] = []
    private var hints: [String] = []
    private var answers: [String] = []
    private var writeType: WriteType = .post
    
    var tempTitle: String = ""
    
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
    func setData(type: WriteType, questions: [String], hints: [String]) {
        self.writeType = type
        self.questions = questions
        self.hints = hints
        self.answers = Array(repeating: "", count: hints.count)
    }
    
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
        
        /// .patch(고민 수정)의 경우 제목이 이미 있으므로 이를 headerCell의 제목으로 지정해줌.
        headerCell.worryTitleTextField.text = tempTitle
        headerCell.worryTitleTextField.becomeFirstResponder()

        /// headerCell에 입력된 고민 제목을 contentInfo에 담아준다.
        headerCell.delegate = self
        
        return headerCell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TemplateContentTVC.classIdentifier, for: indexPath) as? TemplateContentTVC else {return UITableViewCell()}
        
        /// 1씩 작은 templateId에 1을 더해주어 원래 값으로 만들어준다.
        contentInfo.templateId = templateId + 1
        
        /// cell에서 endEditing 시에 적힌 값을 TV로 보내준다.
        cell.delegate = self
        
        cell.dataBind(type: self.writeType, question: questions[indexPath.row], hint: hints[indexPath.row], index: indexPath.row)
        
        return cell
    }
}

extension TemplateContentTV: TemplateContentHeaderViewDelegate, TemplateContentTVCDelegate {
    
    func textViewDidEndEditing(index: Int, newText: String) {
        answers[index] = newText
        contentInfo.answers = answers
    }
    
    func textFieldDidEndEditing(newText: String) {
        contentInfo.title = newText
    }
}

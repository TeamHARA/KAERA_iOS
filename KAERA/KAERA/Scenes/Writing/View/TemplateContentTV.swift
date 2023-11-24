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

protocol ActivateButtonDelegate: AnyObject {
    func isTitleEmpty(check: Bool)
}

final class TemplateContentTV: UITableView {
    
    // MARK: - Properties
    var templateId: Int = 0
    private var questions: [String] = []
    var title: String = ""
    var hints: [String] = []
    var answers: [String] = []
    private var writeType: WriteType = .post
    
    var tempTitle: String = ""
    
    let worryPostContent = WorryPostManager.shared
    let worryPatchContent = WorryPatchManager.shared
    
    weak var buttonDelegate: ActivateButtonDelegate?
    
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
    func setData(type: WriteType, questions: [String], hints: [String], answers: [String] = []) {
        self.writeType = type
        self.questions = questions
        self.hints = hints
        self.answers = Array(repeating: "", count: hints.count)
        
        for (idx, answer) in answers.enumerated() {
            self.answers[idx] = answer
        }
        worryPatchContent.answers = self.answers
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
        switch self .writeType {
        case .patch:
            headerCell.worryTitleTextField.text = title
        default:
            headerCell.worryTitleTextField.text = title
            headerCell.titleNumLabel.text = "\(title.count)/7"
        }
        headerCell.worryTitleTextField.becomeFirstResponder()
        
        /// headerCell에 입력된 고민 제목을 contentInfo에 담아준다.
        headerCell.delegate = self
        
        return headerCell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TemplateContentTVC.classIdentifier, for: indexPath) as? TemplateContentTVC else {return UITableViewCell()}
        
        /// cell에서 endEditing 시에 적힌 값을 TV로 보내준다.
        cell.delegate = self
        
        /// 1씩 작은 templateId에 1을 더해주어 원래 값으로 만들어준다.
        worryPostContent.templateId = templateId + 1
        worryPatchContent.templateId = templateId + 1
        
        cell.dataBind(question: questions[indexPath.row], hint: hints[indexPath.row], answer: answers[indexPath.row], index: indexPath.row)

        return cell
    }
}

extension TemplateContentTV: TemplateContentHeaderViewDelegate, TemplateContentTVCDelegate {
    func titleDidEndEditing(newText: String) {
        /// 테이블 뷰 cell이 재사용될 때 제목 값이 날라가는 걸 방지하기 위해 title 지역변수에 제목을 저장해준다.
        self.title = newText
        worryPostContent.title = title
        worryPatchContent.title = title
        buttonDelegate?.isTitleEmpty(check: title.isEmpty)
    }
    
    func answerDidEndEditing(index: Int, newText: String) {
        /// 테이블 뷰 값의 순서가 바뀌는 것을 막기 위해 index를 cell로 부터 받아서 answers 지역변수에 index값과 함께 저장해준다.
        self.answers[index] = newText
        worryPostContent.answers = answers
        worryPatchContent.answers = answers
    }
}

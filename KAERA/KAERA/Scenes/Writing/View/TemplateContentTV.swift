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
    
    // MARK: - View Model
    private let templateContentVM = TemplateContentViewModel()
    private var cancellables = Set<AnyCancellable>()
    private let input = PassthroughSubject<Int, Never>.init()
    
    // MARK: - Properties
    private var templateId: Int = 0
    private var questions: [String] = []
    private var hints: [String] = []
    private var topConstraint: Constraint?
    
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
    private func dataBind() {
        let output = templateContentVM.transform(
            input: TemplateContentViewModel.Input(input)
        )
        output.receive(on: DispatchQueue.main)
            .sink { [weak self] templateContents in
                self?.updateUI( templateContents)
            }.store(in: &cancellables)
        /// input 전달
        input.send(templateId)
    }
    
    private func updateUI(_ templateContents: TemplateContentModel) {
        self.questions = templateContents.questions
        self.hints = templateContents.hints
        print(questions)
        print(hints)
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
        
        return headerCell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TemplateContentTVC.classIdentifier, for: indexPath) as? TemplateContentTVC else {return UITableViewCell()}
        
        cell.dataBind(question: questions[indexPath.row], hint: hints[indexPath.row])

        return cell
    }
}

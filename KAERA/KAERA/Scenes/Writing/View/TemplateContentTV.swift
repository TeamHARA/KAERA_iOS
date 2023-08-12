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

class TemplateContentTV: UIView {
    
    // MARK: - View Model
    private let templateContentVM = TemplateContentViewModel()
    private var cancellables = Set<AnyCancellable>()
    private let input = PassthroughSubject<Int, Never>.init()
    
    // MARK: - Properties
    private let templateId: Int
    private var questions: [String] = []
    private var hints: [String] = []
    
    private lazy var templateContentTV = UITableView(frame: .zero, style: .grouped).then {
        $0.backgroundColor = .clear
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.separatorStyle = .none
        $0.showsVerticalScrollIndicator = false
        $0.delegate = self
        $0.dataSource = self
    }

    // MARK: - Life Cycle
    init(templateId: Int) {
        self.templateId = templateId
        super.init(frame: .zero)
        setLayout()
        dataBind()
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
    
    private func setLayout() {
        
    }
}

// MARK: - UITableViewDelegate
extension TemplateContentTV: UITableViewDelegate {
    
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
extension TemplateContentTV : UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TemplateInfoTVC.classIdentifier, for: indexPath) as? TemplateInfoTVC else {return UITableViewCell()}
//
//        cell.settingData(isExpanded: expandedCells[indexPath.row])
//        /// 각 cell 클릭 시 해당하는 cell의 indexPath를 TVC의 indexPath로 전달
//        cell.indexPath = indexPath
//
//        cell.dataBind(model: templateInfoList[indexPath.row])
        
        return cell
    }
}


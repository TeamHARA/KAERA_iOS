//
//  TemplateContentTVC.swift
//  KAERA
//
//  Created by saint on 2023/08/12.
//

import UIKit
import SnapKit
import Then

class TemplateContentTVC: UITableViewCell {
    
    private var questionLabel = UILabel().then {
        $0.text = "질문지 제목"
        $0.font = .kB1B16
        $0.textColor = .white
        $0.backgroundColor = .clear
    }
    
    var placeHolder: String = ""
    
    lazy var textView = UITextView().then {
        $0.isScrollEnabled = false
        $0.delegate = self
        $0.textContainer.lineBreakMode = .byWordWrapping
        $0.textContainerInset = UIEdgeInsets(top: 18, left: 17, bottom: 18, right: 17)
        $0.backgroundColor = .kGray2
        $0.layer.cornerRadius = 12
        $0.text = placeHolder
        $0.textColor = .kGray4
        $0.font = .kB2R16
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setLayout()
        textView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    private func setLayout() {
        contentView.backgroundColor = .kGray1
        contentView.addSubviews([questionLabel, textView])
        
        questionLabel.snp.makeConstraints{
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().offset(16)
            $0.height.equalTo(24)
        }
        
        textView.snp.makeConstraints {
            $0.top.equalTo(questionLabel.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(111)
            $0.bottom.equalToSuperview().offset(-54)
        }
    }
    
    func dataBind(question: String, hint: String) {
        questionLabel.text = question
        /// 아래의 textViewDelegate에서 update된 placeholder를 써주기 위해 placeholder에도 hint를 담아준다.
        placeHolder = hint
        textView.text = placeHolder
    }
}



extension TemplateContentTVC: UITextViewDelegate {
    // MARK: textview 높이 자동조절
    func textViewDidChange(_ textView: UITextView) {
        
        let size = CGSize(width: self.frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        
        textView.constraints.forEach { (constraint) in
            
            /// 111 이하일때는 더 이상 줄어들지 않게하기
            if estimatedSize.height <= 111 {
                
            }
            else {
                if constraint.firstAttribute == .height {
                    constraint.constant = estimatedSize.height
                }
            }
        }
        
        if let tableView = superview as? UITableView {
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .kGray4 {
            textView.text = nil
            textView.textColor = .kWhite
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty == true {
            textView.text = placeHolder
            textView.textColor = .kGray4
        }
    }
}


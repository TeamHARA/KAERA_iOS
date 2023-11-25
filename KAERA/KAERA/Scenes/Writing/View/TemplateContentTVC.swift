//
//  TemplateContentTVC.swift
//  KAERA
//
//  Created by saint on 2023/08/12.
//

import UIKit
import SnapKit
import Then

protocol TemplateContentTVCDelegate: AnyObject {
    func answerDidEndEditing(index: Int, newText: String)
}

class TemplateContentTVC: UITableViewCell {
    
    // MARK: - Properties
    weak var delegate: TemplateContentTVCDelegate?
    
    private var indexPath: Int = 0
    
    private var keyboardHeight: CGFloat = 336.adjustedH
    
    private var questionLabel = UILabel().then {
        $0.text = "질문지 제목"
        $0.font = .kB1B16
        $0.textColor = .white
        $0.backgroundColor = .clear
    }
    
    private let textViewConstant: CGFloat = 111.adjustedH
    
    private var placeHolder: String = ""
            
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
            $0.height.equalTo(111.adjustedH)
            $0.bottom.equalToSuperview().offset(-54)
        }
    }
    
    func dataBind(question: String, hint: String, answer: String, index: Int) {
        questionLabel.text = question
        placeHolder = hint
        self.indexPath = index
        
        if answer.isEmpty {
            textView.text = placeHolder
            textView.textColor = .kGray4
        } else {
            textView.text = answer
            textView.textColor = .kWhite
        }
    }
}

extension TemplateContentTVC: UITextViewDelegate {
    // MARK: textview 높이 자동조절
    func textViewDidChange(_ textView: UITextView) {
        
        /// width를 self.frame.width로 지정하였더니, 텍스트뷰가 바로바로 업데이트되지 않는 문제 발생
        let size = CGSize(width: textView.bounds.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)        
        
        /// 높이가 111보다 커지면 아래의 코드 실행, 넘지 않으면 고정 높이 반영
        textView.constraints.forEach { (constraint) in
            if constraint.firstAttribute == .height {
                if estimatedSize.height > textViewConstant {
                    constraint.constant = estimatedSize.height
                }
                else {
                    constraint.constant = textViewConstant
                }
            }
        }
        
        /// 좀더 자연스로운 애니메이션 효과? 를 위해 필요
        self.layoutIfNeeded()
        
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
        let trimmedText = textView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if trimmedText.isEmpty == true {
            textView.text = placeHolder
            textView.textColor = .kGray4
        }
        
        delegate?.answerDidEndEditing(index: self.indexPath, newText: trimmedText)
    }
}

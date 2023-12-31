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
    func answerHasChanged(index: Int, newText: String)
}

class TemplateContentTVC: UITableViewCell {
    
    // MARK: - Properties
    weak var delegate: TemplateContentTVCDelegate?
    private var indexPath: Int = 0
    private var keyboardHeight: CGFloat = 336.adjustedH
    private let textViewHeightConstant: CGFloat = 111.adjustedH
    private var placeHolder: String = ""
    private var wasTextViewEmpty: Bool = true
    
    // MARK: - Components
    private var questionLabel = UILabel().then {
        $0.text = "질문지 제목"
        $0.font = .kB1B16
        $0.textColor = .white
        $0.backgroundColor = .clear
    }
    
    private let textView = UITextView().then {
        $0.isScrollEnabled = false
        $0.textContainer.lineBreakMode = .byWordWrapping
        $0.textContainerInset = UIEdgeInsets(top: 18, left: 17, bottom: 18, right: 17)
        $0.backgroundColor = .kGray2
        $0.layer.cornerRadius = 12
        $0.text = ""
        $0.textColor = .kGray4
        $0.font = .kB2R16
    }
    
    
    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setLayout()
        textView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    func setTextViewStyle(inputText: String, textColor: UIColor) {
        let style = NSMutableParagraphStyle()
        style.lineSpacing = UIFont.kB2R16.lineHeight * 0.5
        style.alignment = .justified
        let attributedText = NSAttributedString(
            string: inputText,
            attributes: [
                .paragraphStyle: style,
                .foregroundColor: textColor,
                .font: UIFont.kB2R16
            ]
        )
        
        textView.attributedText = attributedText
    }
    
    func dataBind(question: String, hint: String, answer: String, index: Int) {
        questionLabel.text = question
        placeHolder = hint
        self.indexPath = index
        
        if answer.isEmpty {
            setTextViewStyle(inputText: placeHolder,textColor: .kGray4)
        } else {
            setTextViewStyle(inputText: answer, textColor: .kWhite)
        }
    }
    
    func adjustTextViewHeight() {
        let newSize = CGSize(width: textView.frame.size.width, height: .infinity)

        let newSizeThatFits = textView.sizeThatFits(newSize)

        if newSizeThatFits.height > textViewHeightConstant {
            textView.snp.updateConstraints {
                $0.height.equalTo(newSizeThatFits.height)
            }
        }
    }
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
                if estimatedSize.height > textViewHeightConstant {
                    constraint.constant = estimatedSize.height
                }
                else {
                    constraint.constant = textViewHeightConstant
                }
            }
        }
        
        /// 좀더 자연스로운 애니메이션 효과? 를 위해 필요
        self.layoutIfNeeded()
        
        if let tableView = superview as? UITableView {
            tableView.beginUpdates()
            tableView.endUpdates()
        }
        
        let newText = textView.text ?? ""
        let trimmedText = newText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if trimmedText.isEmpty && !wasTextViewEmpty{
            delegate?.answerHasChanged(index: self.indexPath, newText: "")
            wasTextViewEmpty = true
        }else if !trimmedText.isEmpty && wasTextViewEmpty {
            delegate?.answerHasChanged(index: self.indexPath, newText: newText)
            wasTextViewEmpty = false
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        var inputText = ""
        inputText = textView.textColor == .kGray4 ? " " : textView.text
        setTextViewStyle(inputText: inputText, textColor: .kWhite)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        let trimmedText = textView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if trimmedText.isEmpty == true {
            textView.text = placeHolder
            textView.textColor = .kGray4
        }
        delegate?.answerHasChanged(index: self.indexPath, newText: textView.text ?? "")
    }
}

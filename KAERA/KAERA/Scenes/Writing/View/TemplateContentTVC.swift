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
    
    // MARK: - Properties
    private var keyboardHeight: CGFloat = 336.adjustedH
    
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
            $0.height.equalTo(111.adjustedH)
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
        
        /// width를 self.frame.width로 지정하였더니, 텍스트뷰가 바로바로 업데이트되지 않는 문제 발생
        let size = CGSize(width: textView.bounds.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        
        /// 높이가 111보다 커지면 아래의 코드 실행, 넘지 않으면 return 으로 함수 통과
        guard estimatedSize.height > 111.adjustedH else { return }
        textView.constraints.forEach { (constraint) in
            if constraint.firstAttribute == .height {
                constraint.constant = estimatedSize.height
            }
        }
                
        /// 좀더 자연스로운 애니메이션 효과? 를 위해 필요
        self.layoutIfNeeded()

        if let tableView = superview as? UITableView {
            tableView.beginUpdates()
            tableView.endUpdates()
        }
        scrollToCursorPositionIfBelowKeyboard()
    }
    
    /// textViewDidChange에서 textViewCell의 높이에 맞게 커서 위치를 자동으로 조절해주기
    private func scrollToCursorPositionIfBelowKeyboard() {
        print("텍스트뷰 높이", textView.bounds.size.height, "키보드 높이", keyboardHeight)
        
        /// 키보드에 커서가 가리지 않게끔 커서 위치 조정해주기
        let textViewFrame = CGRect(x: 0, y: textView.bounds.size.height - keyboardHeight, width: textView.bounds.size.width, height: keyboardHeight)
        print("텍스트 뷰 프레임", textViewFrame)
        textView.inputView?.frame = textViewFrame
        /// 좀더 자연스로운 애니메이션 효과? 를 위해 필요(즉각 업데이트 위함인듯)
        textView.reloadInputViews()
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


//
//  TemplateContentHeaderView.swift
//  KAERA
//
//  Created by saint on 2023/08/13.
//

import UIKit
import SnapKit
import Then

protocol TemplateContentHeaderViewDelegate: AnyObject {
    func titleHasChanged(newText: String)
}

final class TemplateContentHeaderView: UITableViewHeaderFooterView {
    
    // MARK: - Properties
    weak var delegate: TemplateContentHeaderViewDelegate?
    
    let worryTitleTextField = UITextField().then{
        $0.layer.cornerRadius = 8
        $0.backgroundColor = .clear
        $0.textColor = .kWhite
        $0.font = .kB2R16
        $0.addLeftPadding(16)
        
        // Placeholder 색상 설정
        let placeholderText = "고민에 이름을 붙여주세요"
        let placeholderColor = UIColor.kGray4
        $0.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: [NSAttributedString.Key.foregroundColor: placeholderColor])
    }
    
    let titleNumLabel = UILabel().then {
        $0.text = "0/7"
        $0.font = .kB2R16
        $0.textColor = .kGray4
        $0.textAlignment = .right
    }
    
    private let dividingLine = UIView().then {
        $0.backgroundColor = .kGray3
    }
    
    private let maxLength = 7
    
    // MARK: - Initialization
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setLayout()
        addObserver()
        worryTitleTextField.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Function
    private func setLayout() {
        self.contentView.addSubviews([worryTitleTextField, titleNumLabel, dividingLine])
        
        worryTitleTextField.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.width.equalTo(200.adjustedW)
            $0.height.equalTo(73.adjustedW)
        }
        
        titleNumLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(28.adjustedH)
            $0.trailing.equalToSuperview().offset(-16)
        }
        
        dividingLine.snp.makeConstraints {
            $0.top.equalTo(worryTitleTextField.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1.adjustedW)
        }
    }
    
    private func addObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange), name: UITextField.textDidChangeNotification, object: nil)
    }
    
    @objc func textDidChange(noti: NSNotification) {
        if let text = worryTitleTextField.text {
            /// 마지막 문자에 한글 받침을 사용할 수 없는 문제를 해결하기 위해 변경
            if text.count >= maxLength {
                if let endIndex = text.index(text.startIndex, offsetBy: maxLength, limitedBy: text.endIndex) {
                    let fixedText = text[..<endIndex]
                    /// 공백을 추가했다가
                    worryTitleTextField.text = String(fixedText) + " "
                    
                    /// 공백을 바로 제거해줌으로써 한글 받침을 쓸 수 있게 구현해준다.
                    DispatchQueue.main.async {
                        self.worryTitleTextField.text = String(fixedText)
                    }
                    var newText = String(fixedText)
                    let trimmedText = newText.trimmingCharacters(in: .whitespacesAndNewlines)
                    if trimmedText.isEmpty {
                        newText = ""
                    }
                    delegate?.titleHasChanged(newText: newText)
                }
            }
        }
    }
}

// MARK: - UITextFieldDelegate
extension TemplateContentHeaderView: UITextFieldDelegate {
    
    /// return 눌렸을 때 키보드 자동으로 내려가게끔 해줌.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let inputText = textField.text else { return true }
        var newText = inputText
        
        if let char = string.cString(using: String.Encoding.utf8) {
            /// backSpace는 글자수 제한이 걸려도 눌릴 수 있게 해줌
            let isBackSpace = strcmp(char, "\\b")
            if isBackSpace == -92 {
                newText = String(newText.dropLast())
            } else {
                newText = newText + string
            }
        }
        
        if newText.count < maxLength {
            let trimmedText = newText.trimmingCharacters(in: .whitespacesAndNewlines)
            if trimmedText.isEmpty {
                newText = ""
            }
            /// 단순히 "완료" 버튼 활성화를 위한 delegate
            delegate?.titleHasChanged(newText: newText)
        }
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        /// 글자 수 부분 색상 변경 및 글자 수 표시
        let attributedString = NSMutableAttributedString(string: "\(worryTitleTextField.text!.count)/7")
        attributedString.addAttribute(.foregroundColor, value: UIColor.kWhite, range: ("\(worryTitleTextField.text!.count)/7" as NSString).range(of:"\(worryTitleTextField.text!.count)"))
        titleNumLabel.attributedText = attributedString
    }
    
    /// 제목작성이 끝나는 시점에서 delegate를 추가로 실행하여 온전한 제목 전송
    func textFieldDidEndEditing(_ textField: UITextField) {
        let inputText = textField.text ?? ""
        delegate?.titleHasChanged(newText: inputText)
    }
}





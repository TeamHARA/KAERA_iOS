//
//  WorryDecisionVC.swift
//  KAERA
//
//  Created by 김담인 on 2023/08/03.
//

import UIKit
import SnapKit
import Then

final class WorryDecisionVC: BaseVC {
    
    private let mainView = UIView().then {
        $0.backgroundColor = .kGray2
        $0.layer.cornerRadius = 20
    }
    
    private let pickaxeImageView = UIImageView().then {
        $0.image = UIImage(named: "Pickaxe")
    }
    
    private let mainTitle = UILabel().then {
        $0.text = "이 고민, 어떻게 캐낼까요?"
        $0.font = .kB1B16
        $0.textColor = .kWhite
    }
    
    private let subTitle = UILabel().then {
        $0.text = "고민 끝에 결정한 나의 생각을 적어주세요!"
        $0.font = .kSb1R12
        $0.textColor = .kGray5
    }
    
    private let worryTextView = UITextView().then {
        $0.backgroundColor = .kGray4
        $0.layer.cornerRadius = 8
        $0.text = "40자 이내로 적어주세요."
        $0.font = .kB4R14
        $0.textColor = .kGray3
        $0.isScrollEnabled = true
        $0.textContainerInset = UIEdgeInsets(top: 12, left: 5, bottom: 12, right: 5)
    }
    
    private let doneButton = UIButton().then {
        $0.backgroundColor = .kYellow1
        $0.setTitle("완료", for: .normal)
        $0.titleLabel?.textColor = .kWhite
        $0.titleLabel?.font = .kB1B16
        $0.titleLabel?.textAlignment = .center
        $0.layer.cornerRadius = 8
    }
    private let quoteView = WorryQuoteView().then {
        $0.backgroundColor = .kGray2
        $0.layer.cornerRadius = 20
        $0.alpha = 0.0
    }

    private let topInset: CGFloat = 303.adjustedH
    private var hasKeyboard: Bool = false
    private let placeholderText = "40자 이내로 적어주세요."

    private var defaultTextHeight: CGFloat = 40
    private lazy var defaultMainViewHeight: CGFloat = (282 - defaultTextHeight).adjustedH
    
    private var templateId: Int = 0
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        setLayout()
        hideKeyboardWhenTappedAround()
        setTextView()
        setPressAction()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.addKeyboardObserver()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.removeKeyboardObserver()
    }
    
    // MARK: - Function
    private func setTextView() {
        worryTextView.delegate = self
    }
    
    private func setPressAction() {
        self.doneButton.press {
            // 고민 완료 Post
            self.showWorryQuote()
        }
    }
    
    private func showWorryQuote() {
        self.mainView.isHidden = true

        UIView.animate(withDuration: 0.7, animations: {
            self.quoteView.alpha = 1.0
        })

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.3) {
            UIView.animate(withDuration: 0.5, animations: {
                self.quoteView.alpha = 0.0
            })
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.8) {
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    func setTemplateId(id: Int) {
        self.templateId = id
    }

}
// MARK: - Keyboard Setting
extension WorryDecisionVC {
    private func addKeyboardObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboardWillAppear(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self, selector: #selector(keyboardWillDisappear),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)

    }
    
    
    private func removeKeyboardObserver() {
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillShowNotification,
            object: nibName
        )
        
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillHideNotification,
            object: nibName
        )
    }
    
    @objc
    func keyboardWillAppear(_ notification: NSNotification) {
        hasKeyboard = true
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                UIView.animate(withDuration: 0.1, animations: { [self] in
                    let newInset = abs(topInset - (keyboardSize.height - 100))
                    mainView.snp.updateConstraints {
                        $0.top.equalTo(view.safeAreaLayoutGuide).inset(newInset.adjustedH)
                    }
                })
        }
    }
    @objc
    func keyboardWillDisappear(_ notification: NSNotification) {
        UIView.animate(withDuration: 0.1, animations: { [self] in
            mainView.snp.updateConstraints {
                $0.top.equalTo(view.safeAreaLayoutGuide).inset(topInset.adjustedH)
            }
        })
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard let touch = touches.first else {
            return
        }
        
        /// 배경 영역을 탭한 경우 뷰 컨트롤러를 닫음
        if !mainView.frame.contains(touch.location(in: view)) && !hasKeyboard {
            UIView.animate(withDuration: 0.3, animations: {
                self.dismiss(animated: true, completion: nil)
            })
        }
        
        ///  키보드가 내려가 있었을 때와 키보드가 올라왔있다가 내려가고 호출되어 false 고정
        hasKeyboard = false
    }
}

// MARK: - TextView Delegate
extension WorryDecisionVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        var inputText = ""
        inputText = textView.text == placeholderText ? " " : textView.text
        /// 행간 간격 150% 설정
        let style = NSMutableParagraphStyle()
        style.lineSpacing = UIFont.kB4R14.lineHeight * 0.5
        style.alignment = .justified
        let attributedText = NSAttributedString(
            string: inputText,
            attributes: [
                .paragraphStyle: style,
                .foregroundColor: UIColor.kGray1,
                .font: UIFont.kB4R14
            ]
        )
        
        textView.attributedText = attributedText
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        let trimmedText = textView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if trimmedText.isEmpty {
            textView.text = placeholderText
            textView.font = .kB4R14
            textView.textColor = .kGray3
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        guard !textView.text.isEmpty else { return }
        
        if textView.text.count > 40 {
            textView.deleteBackward()
        }
        if textView.contentSize.height < defaultTextHeight * 2 - textView.textContainerInset.top {
            
            worryTextView.snp.updateConstraints {
                $0.height.equalTo(textView.contentSize.height)
            }

            mainView.snp.updateConstraints {
                $0.height.equalTo(textView.contentSize.height + defaultMainViewHeight)
            }
        }
    }
}

// MARK: - UI
extension WorryDecisionVC {
    private func setLayout() {
        self.view.addSubviews([quoteView,mainView])
        
        mainView.addSubviews([pickaxeImageView, mainTitle, subTitle, worryTextView, doneButton])
        
        mainView.snp.makeConstraints {
            $0.directionalHorizontalEdges.equalToSuperview().inset(19)
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(topInset.adjustedH)
            $0.height.equalTo(defaultMainViewHeight + defaultTextHeight)
        }
        
        pickaxeImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(20)
            $0.height.width.equalTo(54)
        }
        
        mainTitle.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(pickaxeImageView.snp.bottom).offset(21)
        }
        
        subTitle.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(mainTitle.snp.bottom).offset(12)
        }
        
        worryTextView.snp.makeConstraints {
            $0.directionalHorizontalEdges.equalToSuperview().inset(18)
            $0.top.equalTo(subTitle.snp.bottom).offset(16)
            $0.height.equalTo(defaultTextHeight)
        }
        
        doneButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(38)
            $0.height.equalTo(30)
            $0.width.equalTo(78)
        }

        quoteView.snp.makeConstraints {
            $0.directionalHorizontalEdges.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(284.adjustedH)
            $0.height.equalTo(244.adjustedH)
        }
    }
}

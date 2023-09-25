//
//  WritePickerView.swift
//  KAERA
//
//  Created by saint on 2023/07/13.
//

import UIKit
import SnapKit
import Then

class WritePickerVC: UIViewController {
    
    // MARK: - Properties
    let pickerData = Array(1...30).map { String($0) }
    
    let datePickerView = UIPickerView().then {
        $0.backgroundColor = .kGray1
    }
    
    let contentInfo = ContentInfo.shared
    
    private let pickerViewTitle = UILabel().then {
        $0.text = "이 고민, 언제까지 끝낼까요?"
        $0.font = .kB1B16
        $0.textColor = .kYellow1
    }
    
    private let firstLabel = UILabel().then {
        $0.text = "이 고민을"
        $0.font = .kH2R20
        $0.textColor = .kWhite
    }
    
    private let secondLabel = UILabel().then {
        $0.text = "일 후까지 끝낼게요"
        $0.font = .kH2R20
        $0.textColor = .kWhite
    }
    
    private let upperCover = UIView().then {
        $0.backgroundColor = .kGray1
        $0.layer.cornerRadius = 8
        $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    private let lowerCover = UIView().then {
        $0.backgroundColor = .kGray1
        $0.layer.cornerRadius = 8
        $0.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }
    
    private let completeWritingBtn = UIButton().then {
        $0.backgroundColor = .kGray5
        $0.titleLabel?.font = .kB2R16
        $0.setTitle("작성완료", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.layer.cornerRadius = 8
    }
    
    private let noDeadlineBtn = UIButton().then {
        $0.backgroundColor = .clear
        $0.titleLabel?.font = .kB4R14
        
        let title = "기한 설정하지 않기"
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.kB4R14,
            .foregroundColor: UIColor.kGray5,
            .underlineStyle: NSUnderlineStyle.single.rawValue,
            .underlineColor: UIColor.kGray5
        ]
        
        let attributedTitle = NSAttributedString(string: title, attributes: titleAttributes)
        $0.setAttributedTitle(attributedTitle, for: .normal)
    }
    
    
    // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        pressBtn()
        setDelegate()
    }
    
    // MARK: - Functions
    private func pressBtn() {
        completeWritingBtn.press {[self] in
            UIView.animate(withDuration: 0.5, animations: { [self] in
                view.alpha = 0
                view.layoutIfNeeded()
            }, completion: { _ in
                self.dismiss(animated: false, completion: {
                    NotificationCenter.default.post(name: NSNotification.Name("CompleteWriting"), object: nil, userInfo: nil)
                })
            })
            
            let selectedRow = datePickerView.selectedRow(inComponent: 0)
            let selectedValue = pickerData[selectedRow]
            contentInfo.deadline = Int(selectedValue)
            print("Template ID: \(contentInfo.templateId ?? 0)")
            print("Title: \(contentInfo.title ?? "")")
            print("Answers: \(contentInfo.answers ?? [])")
            print("Deadline: \(contentInfo.deadline ?? 0)")
            }
    }
    
    private func setDelegate() {
        datePickerView.delegate = self
        datePickerView.dataSource = self
    }
}

// MARK: - Layout
extension WritePickerVC {
    private func setLayout() {
        view.backgroundColor = .black.withAlphaComponent(0.5)
        view.addSubviews([datePickerView, upperCover, pickerViewTitle, lowerCover, completeWritingBtn, noDeadlineBtn])
        
        /// datepickerView 관련 Component
        datePickerView.addSubviews([firstLabel, secondLabel])
        
        datePickerView.snp.makeConstraints {
            $0.width.equalTo(358.adjustedW)
            $0.height.equalTo(136.adjustedW)
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(302.adjustedW)
        }
        
        firstLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(32.adjustedW)
            $0.centerY.equalToSuperview()
        }
        
        secondLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-32.adjustedW)
            $0.centerY.equalToSuperview()
        }
        
        /// pickerVC 관련 Component
        upperCover.snp.makeConstraints {
            $0.leading.equalTo(datePickerView.snp.leading)
            $0.trailing.equalTo(datePickerView.snp.trailing)
            $0.bottom.equalTo(datePickerView.snp.top)
            $0.height.equalTo(120)
        }
        
        pickerViewTitle.snp.makeConstraints {
            $0.top.equalTo(upperCover.snp.top).offset(54.adjustedW)
            $0.centerX.equalToSuperview()
        }
        
        lowerCover.snp.makeConstraints {
            $0.leading.equalTo(datePickerView.snp.leading)
            $0.trailing.equalTo(datePickerView.snp.trailing)
            $0.top.equalTo(datePickerView.snp.bottom)
            $0.height.equalTo(192)
        }
        
        completeWritingBtn.snp.makeConstraints {
            $0.width.equalTo(326.adjustedW)
            $0.height.equalTo(52.adjustedW)
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(lowerCover.snp.bottom).offset(-90.adjustedW)
        }
        
        noDeadlineBtn.snp.makeConstraints {
            $0.width.equalTo(113.adjustedW)
            $0.height.equalTo(21.adjustedW)
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(lowerCover.snp.bottom).offset(-56.adjustedW)
        }
    }
}

// MARK: - UIPickerViewDelegate, UIPickerViewDataSource
extension WritePickerVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let customView = UIView()
        
        let numLabel = UILabel().then {
            $0.text = pickerData[row]
            $0.font = .kH2R20
            $0.textColor = .kWhite
        }
        
        customView.addSubview(numLabel)
        
        numLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(124.adjustedW)
            $0.centerY.equalToSuperview()
        }
        
        return customView
    }
}

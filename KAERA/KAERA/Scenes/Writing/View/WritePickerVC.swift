//
//  WritePickerView.swift
//  KAERA
//
//  Created by saint on 2023/07/13.
//

import UIKit
import SnapKit
import Then

enum DeadlineType {
    case post
    case patch
}

class WritePickerVC: BaseVC {
    
    // MARK: - Properties
    let pickerData = Array(1...30).map { String($0) }
    
    let pickerViewLayout = UIView().then {
        $0.backgroundColor = .kGray1
        $0.layer.cornerRadius = 8
        $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }
    
    let datePickerView = UIPickerView().then {
        $0.backgroundColor = .kGray1
    }
        
    var worryId: Int = 0
        
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

    let completeWritingBtn = UIButton().then {
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
    
    private var deadlineType: DeadlineType = .post
    
    private let archiveVC = ArchiveVC()
    
    // MARK: - Initialization
    init(type: DeadlineType) {
        super.init(nibName: nil, bundle: nil)
        self.deadlineType = type
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        completeWritingBtn.press { [weak self] in
            /// picker에서 고른 숫자를 deadline으로 설정해줌.
            let selectedRow = self?.datePickerView.selectedRow(inComponent: 0) ?? 0
            WorryPostManager.shared.deadline = selectedRow + 1
            self?.completeDeadline(deadline: selectedRow + 1)
        }
        
        noDeadlineBtn.press { [weak self] in
            WorryPostManager.shared.deadline = -1
            self?.completeDeadline(deadline: -1)
        }
        
    }
    
    private func completeDeadline(deadline: Int) {
        switch self.deadlineType {
        case .post:
            let worryPostContent = WorryPostManager.shared
            let postWorryModel = WorryContentRequestModel(templateId: worryPostContent.templateId, title: worryPostContent.title, answers: worryPostContent.answers, deadline: worryPostContent.deadline)
            self.postWorryContent(postWorryContent: postWorryModel)
            
        case .patch:
            let deadlineContent = PatchDeadlineModel(worryId: self.worryId, dayCount: deadline)
            self.patchWorryDeadline(deadlineContent: deadlineContent)
        }
    }
    
    private func setDelegate() {
        datePickerView.delegate = self
        datePickerView.dataSource = self
    }
    
    private func postWorryContent(postWorryContent: WorryContentRequestModel) {
        startLoadingAnimation()
        WriteAPI.shared.postWorryContent(param: postWorryContent) { [weak self] result in
            guard let result = result, let data = result.data else {
                self?.presentNetworkAlert()
                return
            }
            self?.stopLoadingAnimation()
            
            if let writeNC = self?.presentingViewController, let NC = writeNC as? BaseNC {
                UIView.animate(withDuration: 0.5, animations: {
                    self?.pickerViewLayout.alpha = 0
                }) { [weak self] _ in
                    self?.dismiss(animated: false) {
                        
                        let worryDetailModel = WorryDetailModel(title: data.title, templateId: data.templateId, subtitles: data.subtitles , answers: data.answers, period: "", updatedAt: data.createdAt, deadline: data.deadline, dDay: data.dDay, finalAnswer: "", review: Review(content: "", updatedAt: ""))
                        
                        let worryDetailVC = HomeWorryDetailVC(worryId: data.worryId, type: .digging, worryDetail: worryDetailModel)
                        NC.setViewControllers([worryDetailVC], animated: true)
                    }
                }
            }
            /// WorryPostManager 데이터 초기화
            WorryPostManager.shared.clearWorryData()
        }
    }
    
    func patchWorryDeadline(deadlineContent: PatchDeadlineModel) {
        self.startLoadingAnimation()
        HomeAPI.shared.updateDeadline(param: deadlineContent) { [weak self] result in
            self?.stopLoadingAnimation()
            guard let result, let data = result.data else {
                let failureAlertVC = KaeraAlertVC(buttonType: .onlyOK, okTitle: "확인")
                failureAlertVC.setTitleSubTitle(title: "일자 수정에 실패했어요", subTitle: "다시 한번 시도해주세요.", highlighting: "실패")
                self?.present(failureAlertVC, animated: true)
                return
            }
            if let editVC = self?.presentingViewController {
                if let detailVC = editVC.presentingViewController as? HomeWorryDetailVC {
                    detailVC.updateDeadline(deadline: data.dDay)
                }
                UIView.animate(withDuration: 0.5, animations: {
                    self?.pickerViewLayout.alpha = 0
                }) { [weak self] _ in
                    self?.dismiss(animated: false) {
                        editVC.dismiss(animated: true)
                    }
                }
            }
            
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard let touch = touches.first else {
            return
        }
        
        /// 배경 영역을 탭한 경우 뷰 컨트롤러를 닫음
        if !pickerViewLayout.frame.contains(touch.location(in: self.view)) {
            UIView.animate(withDuration: 0.5, animations: {
                self.pickerViewLayout.alpha = 0
            }) { _ in
                self.dismiss(animated: false, completion: nil)
            }
        }
    }
}

// MARK: - Layout
extension WritePickerVC {
    private func setLayout() {
        view.backgroundColor = .black.withAlphaComponent(0.5)
        view.addSubview(pickerViewLayout)
        
        pickerViewLayout.addSubviews([pickerViewTitle, datePickerView, completeWritingBtn, noDeadlineBtn])
        
        pickerViewLayout.snp.makeConstraints {
            $0.width.equalTo(358.adjustedW)
            $0.height.equalTo(448.adjustedH)
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        
        pickerViewTitle.snp.makeConstraints {
            $0.top.equalToSuperview().offset(54.adjustedW)
            $0.centerX.equalToSuperview()
        }
        
        /// datepickerView 관련 Component
        datePickerView.addSubviews([firstLabel, secondLabel])
        
        datePickerView.snp.makeConstraints {
            $0.width.equalTo(358.adjustedW)
            $0.height.equalTo(136.adjustedW)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(pickerViewTitle.snp.bottom).offset(50.adjustedH)
        }
        
        firstLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(32.adjustedW)
            $0.centerY.equalToSuperview()
        }
        
        secondLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-32.adjustedW)
            $0.centerY.equalToSuperview()
        }

        completeWritingBtn.snp.makeConstraints {
            $0.width.equalTo(326.adjustedW)
            $0.height.equalTo(52.adjustedW)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(datePickerView.snp.bottom).offset(50.adjustedH)
        }
        
        noDeadlineBtn.snp.makeConstraints {
            $0.width.equalTo(113.adjustedW)
            $0.height.equalTo(21.adjustedW)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(completeWritingBtn.snp.bottom).offset(23.adjustedH)
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

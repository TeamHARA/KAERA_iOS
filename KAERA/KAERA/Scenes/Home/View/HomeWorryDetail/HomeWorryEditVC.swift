//
//  HomeWorryEditVC.swift
//  KAERA
//
//  Created by 김담인 on 2023/09/10.
//

import UIKit
import SnapKit
import Then
import Combine

final class HomeWorryEditVC: BaseVC {
    
    var worryDetail: WorryDetailModel?
    
    private var worryId: Int = 0
    private var editType: PageType = .digging
    
    private let menuStackView = UIStackView().then {
        $0.axis = .vertical
        $0.backgroundColor = .kGray3
        $0.distribution = .fillEqually
        $0.spacing = 1
        $0.layer.cornerRadius = 12
        $0.layer.masksToBounds = true
    }
    
    private let editWorryButton = UIButton().then {
        $0.setTitle("글 수정하기", for: .normal)
        $0.backgroundColor = .kGray2
    }
    
    private let editDeadlineButton = UIButton().then {
        $0.setTitle("데드라인 수정하기", for: .normal)
        $0.backgroundColor = .kGray2
    }
    
    private let deleteWorryButton = UIButton().then {
        $0.setTitle("글 삭제하기", for: .normal)
        $0.backgroundColor = .kGray2
    }
    
    private let cancelButton = UIButton().then {
        $0.backgroundColor = .kGray2
        $0.setTitle("취소", for: .normal)
        $0.setTitleColor(UIColor.kRed1, for: .normal)
        $0.layer.cornerRadius = 12
    }
    
    let worryPatchContent = WorryPatchManager.shared
    
    private let archiveVC = ArchiveVC()

    init(worryId: Int, editType: PageType) {
        super.init(nibName: nil, bundle: nil)
        self.worryId = worryId
        self.editType = editType
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setPressAction()
        hideKeyboardWhenTappedAround()
    }
    
    // MARK: - Function
    private func dismissVC() {
        self.dismiss(animated: true)
    }
    
    private func setPressAction() {
        editWorryButton.press { [weak self] in
            let writeVC = WriteVC(type: .patch)
            writeVC.modalPresentationStyle = .fullScreen
            writeVC.modalTransitionStyle = .coverVertical
            self?.present(writeVC, animated: true)
            /// 적힌 제목을 templateContentTV의 제목으로 설정해줌
            if let worryTitle = self?.worryDetail?.title {
                writeVC.templateContentTV.title = worryTitle
            }
            /// 적힌 답변을 writeVC로 보내줌
            writeVC.setTempAnswers(answers: self?.worryDetail?.answers ?? [])
            let templateId = (self?.worryDetail?.templateId ?? 1)
            
            self?.worryPatchContent.worryId =  self?.worryId ?? 0
            self?.worryPatchContent.templateId = templateId
            writeVC.input.send(templateId)
        }
        
        editDeadlineButton.press { [weak self] in
            let pickerVC = WritePickerVC(type: .patch)
            pickerVC.worryId = self?.worryId ?? 0
            pickerVC.modalPresentationStyle = .fullScreen
            pickerVC.modalTransitionStyle = .coverVertical
            pickerVC.view.alpha = 0 /// pickerView를 초기에 보이지 않게 설정
            ///
            pickerVC.modalPresentationStyle = .overCurrentContext
            self?.present(pickerVC, animated: false, completion: { /// 애니메이션을 false로 설정
                UIView.animate(withDuration: 0.5, animations: { /// 애니메이션 추가
                    pickerVC.view.alpha = 1 /// pickerView가 서서히 보이게 설정
                    pickerVC.view.layoutIfNeeded()
                })
            })
            
            pickerVC.datePickerView.selectRow(abs(self?.worryDetail?.dDay ?? 0) - 1, inComponent: 0, animated: true)
        }
        
        deleteWorryButton.press {
            /// 서버통신 성공 시 띄울 창 구현
            let alertVC = KaeraAlertVC(okTitle: "삭제")
            alertVC.setTitleSubTitle(title: "고민을 삭제하시나요?", subTitle: "삭제된 고민은 복구할 수 없어요", highlighting: "삭제")
            
            /// 서버통신 실패 시 띄울 알럿 창 구현
            let failureAlertVC = KaeraAlertVC(buttonType: .onlyOK, okTitle: "확인")
            failureAlertVC.setTitleSubTitle(title: "삭제에 실패했어요", subTitle: "다시 한번 시도해주세요.", highlighting: "삭제")
            
            alertVC.OKButton.press { [weak self] in
                /// 서버통신 성공 시 창 모두 dismiss
                self?.deleteWorry { success in
                    if success {
                        self?.dismiss(animated: true) { [weak self] in
                            if let worryEditVC = self?.presentingViewController,
                               let worryDetail = worryEditVC.presentingViewController {
                                worryEditVC.dismiss(animated: true) {
                                    worryDetail.dismiss(animated: true)
                                }
                            }
                        }
                        // MARK: - worryListCV 데이터 다시 받아오고 reload시켜주어야함.
                        self?.archiveVC.dataBind()
                    /// 서버통신 실패 시 "삭제 실패" 알럿창 띄우기
                    } else {
                        self?.dismiss(animated: true) { [weak self] in
                            if let worryEditVC = self?.presentingViewController {
                                worryEditVC.dismiss(animated: true)
                            }
                        }
                        /// "삭제 실패" 알럿창 띄운 뒤 확인 버튼 클릭 시 창 닫히게 구현
                        self?.present(failureAlertVC, animated: true)
                        failureAlertVC.OKButton.press {
                            self?.dismiss(animated: true)
                        }
                    }
                }
            }
            self.present(alertVC, animated: true)
        }
        
        cancelButton.press {
            UIView.animate(withDuration: 0.3, animations: {
                self.dismiss(animated: true, completion: nil)
            })
        }
    }
    
    private func deleteWorry(completion: @escaping (Bool) -> Void) {
        self.startLoadingAnimation()
        HomeAPI.shared.deleteWorry(param: self.worryId) { response in
            self.stopLoadingAnimation()
            if response?.status == 200 {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
}

// MARK: - UI
extension HomeWorryEditVC {
    private func setUI() {
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        
        view.addSubViews([menuStackView, cancelButton])
        
        menuStackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(80)
            $0.width.equalTo(342.adjustedW)
        }
        
        switch self .editType {
        case .digging:
            menuStackView.snp.makeConstraints {
                $0.height.equalTo(156.adjustedH)
            }
            menuStackView.addArrangedSubviews([editWorryButton, editDeadlineButton, deleteWorryButton])
        case .dug:
            menuStackView.snp.makeConstraints {
                $0.height.equalTo(52.adjustedH)
            }
            menuStackView.addArrangedSubview(deleteWorryButton)
        }
        
        cancelButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.height.equalTo(52)
            $0.width.equalTo(menuStackView.snp.width)
        }
    }
}

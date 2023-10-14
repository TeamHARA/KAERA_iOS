//
//  HomeWorryEditVC.swift
//  KAERA
//
//  Created by 김담인 on 2023/09/10.
//

import UIKit
import SnapKit
import Then

final class HomeWorryEditVC: BaseVC {
    
    var worryDetail: WorryDetailModel?
    
    private var worryId: Int = 0
    
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
    
    init(worryId: Int) {
        super.init(nibName: nil, bundle: nil)
        self.worryId = worryId
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setPressAction()
        hideKeyboardWhenTappedAround()
        addObserver()
    }
    
    // MARK: - Function
    private func dismissVC() {
        self.dismiss(animated: true)
    }
    
    private func setPressAction() {
        editWorryButton.press {
            //TODO: 고민 수정하기 -> 수정용 작성페이지(고민 상세에 있던 데이터 전달)
            let writeVC = WriteVC()
            print("고민상세", self.worryDetail)
            writeVC.modalPresentationStyle = .fullScreen
            writeVC.modalTransitionStyle = .coverVertical
            self.present(writeVC,animated: true)
        }
        
        editDeadlineButton.press {
            //TODO: 데드라인 수정하기 -> 기존 데드라인 표시
            print("디데이", self.worryDetail?.dDay)
            let pickerVC = WritePickerVC(type: .patch)
            pickerVC.worryId = self.worryId
            print("worryId 보낼거 ", self.worryId, type(of: self.worryId))
            pickerVC.modalPresentationStyle = .fullScreen
            pickerVC.modalTransitionStyle = .coverVertical
            pickerVC.completeWritingBtn.press {
                self.dismiss(animated: true)
            }
            self.present(pickerVC, animated: true)
            pickerVC.datePickerView.selectRow(abs(self.worryDetail?.dDay ?? 0) - 1, inComponent: 0, animated: true)
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
        /// 고민 삭제 delete 서버 통신
        HomeAPI.shared.deleteWorry(param: self.worryId) { response in
            if response?.status == 200 {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    private func addObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.didCompleteWritingNotification(_:)),
            name: NSNotification.Name("CompleteWriting"),
            object: nil
        )
    }
    
    @objc func didCompleteWritingNotification(_ notification: Notification) {
        DispatchQueue.main.async { [self] in
            self.dismiss(animated: true)
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
            $0.height.equalTo(156.adjustedH)
            $0.width.equalTo(342.adjustedW)
        }
        
        menuStackView.addArrangedSubviews([editWorryButton, editDeadlineButton, deleteWorryButton])
        
        cancelButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.height.equalTo(52)
            $0.width.equalTo(menuStackView.snp.width)
        }
    }
}

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setPressAction()
        hideKeyboardWhenTappedAround()
    }
    // MARK: - Function
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
            let pickerVC = WritePickerVC()
            print("디데이", self.worryDetail?.dDay)
            pickerVC.modalPresentationStyle = .fullScreen
            pickerVC.modalTransitionStyle = .coverVertical
            self.present(pickerVC, animated: true)
        }
        
        deleteWorryButton.press {
            /// 버튼, 타이틀, 서브타이틀, 강조 텍스트, 버튼 액션 추가 가능
            let alertVC = KaeraAlertVC(okTitle: "삭제")
            alertVC.setTitleSubTitle(title: "고민을 삭제하시나요?", subTitle: "삭제된 고민은 복구할 수 없어요", highlighting: "삭제")
            alertVC.OKButton.press {
                //TODO: 삭제 로직 추가
                print("고민 삭제")
            }
            self.present(alertVC, animated: true)
        }
        
        cancelButton.press {
            UIView.animate(withDuration: 0.3, animations: {
                self.dismiss(animated: true, completion: nil)
            })
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
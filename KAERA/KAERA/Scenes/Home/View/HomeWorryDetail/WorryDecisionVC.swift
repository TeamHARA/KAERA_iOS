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
        $0.backgroundColor = .kGray3
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
    
    private lazy var worryTextView = UITextView().then {
        $0.backgroundColor = .kGray4
        $0.layer.cornerRadius = 8
        $0.text = "40자 이내로 적어주세요."
        $0.font = .kB4R14
        $0.textColor = .kGray3
        $0.isScrollEnabled = false
        
        $0.textContainerInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
    }
    
    private let doneButton = UIButton().then {
        $0.backgroundColor = .kYellow1
        $0.setTitle("완료", for: .normal)
        $0.titleLabel?.textColor = .kWhite
        $0.titleLabel?.font = .kB1B16
        $0.titleLabel?.textAlignment = .center
        $0.layer.cornerRadius = 8
    }
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        setLayout()
        hideKeyboardWhenTappedAround()
        setTextView()
    }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

// MARK: - UI
extension WorryDecisionVC {
    private func setLayout() {
        self.view.addSubview(mainView)
        
        mainView.addSubviews([pickaxeImageView, mainTitle, subTitle, worryTextView, doneButton])
        
        mainView.snp.makeConstraints {
            $0.directionalHorizontalEdges.equalToSuperview().inset(19)
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(topInset.adjustedH)
            $0.height.equalTo(282.adjustedH)
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
            $0.height.equalTo(40)
        }
        
        doneButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(38)
            $0.height.equalTo(30)
            $0.width.equalTo(78)
        }
    }
}

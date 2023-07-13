//
//  TemplateInfoVC.swift
//  KAERA
//
//  Created by saint on 2023/07/14.
//

import UIKit
import SnapKit
import Then
import Combine

class TemplateInfoVC: UIViewController {
    
    // MARK: - Properties
    private let titleLabel = UILabel().then {
        $0.text = "고민 작성지"
        $0.textColor = .white
        $0.font = .kH1B20
    }
    
    let backBtn = UIButton().then {
        $0.setBackgroundImage(UIImage(named: "icn_back"), for: .normal)
        $0.contentMode = .scaleToFill
        $0.backgroundColor = .clear
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        pressBtn()
    }
    
    // MARK: - Functions
    private func pressBtn() {
        backBtn.press {
            self.navigationController?.popViewController(animated: true)
        }
    }
}

// MARK: - Layout
extension TemplateInfoVC{
    func setLayout() {
        view.backgroundColor = .kGray1
        view.addSubViews([titleLabel, backBtn])
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(24.adjustedW)
            $0.centerX.equalToSuperview()
        }
        
        backBtn.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(24.adjustedW)
            $0.leading.equalToSuperview().offset(16.adjustedW)
            $0.width.equalTo(24)
            $0.height.equalTo(24)
        }
    }
}

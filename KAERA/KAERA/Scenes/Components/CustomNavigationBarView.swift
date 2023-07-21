//
//  NaviBarView.swift
//  KAERA
//
//  Created by 김담인 on 2023/07/21.
//

import UIKit
import SnapKit

enum NavigationBarButtonType {
    
    case back /// 뒤로가기(옆으로)
    case close /// 창 닫기(아래로)
    case edit /// ...으로 설정하기
    case done /// 완료
    case info /// ? 표시
    case myPage /// 햄버거 버튼
    case delete // 쓰레기통
}

final class CustomNavigationBarView: UIView {
    
    // MARK: - Properties
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .kWhite
        label.font = .kH1B20
        label.textAlignment = .center
        return label
    }()
    
    private let leftButton = UIButton()
    private let rightButton = UIButton()
    
    private var leftType: NavigationBarButtonType? = .back
    private var rightType: NavigationBarButtonType? = .edit
    
    // MARK: - Initialization
    init(leftType: NavigationBarButtonType?, rightType: NavigationBarButtonType?, title: String?) {
        super.init(frame: .zero)
        setLayout() 
        self.leftType = leftType
        self.rightType = rightType
        if let title {
            titleLabel.text = title
        }
        setupLeftButton()
        setupRightButton()
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Functions
    private func setupLeftButton() {
        if let leftType {
            switch leftType {
            case .back:
                leftButton.setImage(UIImage(named: "icn_back"), for: .normal)
            case .close:
                leftButton.setImage(UIImage(named: "icn_close"), for: .normal)
            case .info:
                leftButton.setImage(UIImage(named: "icn_template_info"), for: .normal)
            default:
                print("No Left Button Set")
                break
            }
        }
    }
    
    private func setupRightButton() {
        if let rightType {
            switch rightType {
            case .done:
                setupDoneButton()
            case .edit:
                rightButton.setImage(UIImage(named: "icn_edit"), for: .normal)
            case .myPage:
                rightButton.setImage(UIImage(named: "icn_myPage"), for: .normal)
            case .delete:
                rightButton.setImage(UIImage(named: "icn_delete"), for: .normal)
            default:
                print("No Right Button Set")
                break
            }
        }
    }
    
    private func setupDoneButton() {
        rightButton.setTitle("완료", for: .normal)
        rightButton.setTitleColor(.kWhite, for: .disabled)
        rightButton.setTitleColor(.kGray1, for: .normal)
        rightButton.setBackgroundColor(.kGray3, for: .disabled)
        rightButton.setBackgroundColor(.kYellow1, for: .normal)
        rightButton.snp.updateConstraints {
            $0.width.equalTo(50)
            $0.height.equalTo(26)
        }
    }
    
    func setTitleText(text: String) {
        self.titleLabel.text = text
    }
    
    
    func setLeftButtonAction(_ closure: @escaping () -> Void) {
        self.leftButton.addAction( UIAction { _ in closure() }, for: .touchUpInside)
    }

    func setRightButtonAction(_ closure: @escaping () -> Void) {
        self.rightButton.addAction( UIAction { _ in closure() }, for: .touchUpInside)
    }
    
}

// MARK: - UI
extension CustomNavigationBarView {
    
    private func setLayout() {
        self.addSubviews([leftButton, rightButton, titleLabel])
        titleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        leftButton.snp.makeConstraints {
            $0.top.bottom.left.equalToSuperview()
            $0.width.height.equalTo(24)
        }
        
        rightButton.snp.makeConstraints {
            $0.top.bottom.right.equalToSuperview()
            $0.width.height.equalTo(24)
        }
    }
    
}

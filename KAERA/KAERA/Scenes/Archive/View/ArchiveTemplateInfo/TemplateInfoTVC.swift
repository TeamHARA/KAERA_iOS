//
//  TemplateInfoTVC.swift
//  KAERA
//
//  Created by saint on 2023/07/14.
//

import UIKit
import SnapKit
import Then

// MARK: - ListTableViewCell
class TemplateInfoTVC: UITableViewCell {
    
    // MARK: - Properties
    private let bgView = UIImageView().then {
        $0.image = UIImage(named: "frame_template_cell")
        $0.backgroundColor = .clear
        $0.isUserInteractionEnabled = true
    }
    
    private let jewelImage = UIImageView().then {
        $0.image = UIImage(named: "gem_orange_s_on")
        $0.backgroundColor = .clear
    }
    
    private let titleLabel = UILabel().then {
        $0.text = "템플릿 제목입니다."
        $0.font = .kB1B16
        $0.textColor = .white
    }
    
    private let dropDownImage = UIImageView().then {
        $0.image = UIImage(named: "icn_drop_down")
        $0.backgroundColor = .clear
    }
    
    private let touchArea = UIView().then {
        $0.backgroundColor = .clear
        $0.isUserInteractionEnabled = true
    }
    
    private let templateDetail = UILabel().then {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4 /// 줄 간격 설정
            
        let attributedString = NSAttributedString(
            string: "내가 할 수 있는 선택지를 나열해보세요.\n각각 어떤 장점과 단점을 가지고 있나요?\n당신의 가능성을 펼쳐 비교해 더 나은 선택을 할 수 있도록 도와줄게요.",
            attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle,
                         NSAttributedString.Key.font: UIFont.kSb1R12,
                         NSAttributedString.Key.foregroundColor: UIColor.kGray4])
            
        $0.attributedText = attributedString
        $0.numberOfLines = 0
        $0.backgroundColor = .clear
        $0.isHidden = true
    }

    
    private let writingBtn = UIButton().then {
        $0.backgroundColor = .kGray3
        $0.titleLabel?.font = .kSb1R12
        $0.setTitle("작성하러가기", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 8
        $0.isHidden = true
    }
    
    /// cell의 indexPath를 담을 변수를 선언
    var indexPath: IndexPath?

    // MARK: - View Life Cycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setLayout()
        setTapGesture()
        pressBtn()
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    private func pressBtn() {
        writingBtn.press {
            /// indexPath[1] : 값의 row data를 담고 있음. 
            print(self.indexPath?[1] ?? 0,"번째 TVC의 버튼이 눌렸습니다.")
        }
    }
    
    func setTapGesture() {
        // touchArea 제스처를 설정.
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cellTap(_:)))
        touchArea.addGestureRecognizer(tapGesture)
    }
    
    @objc
    func cellTap(_ gesture: UITapGestureRecognizer) {
        print("CellTouched")
        NotificationCenter.default.post(
                name: NSNotification.Name("CellTouched"),
                object: nil,
                userInfo: ["indexPath": indexPath ?? 0] // indexpath의 정보를 넘겨줌.
            )
    }
    
    func settingData(isExpanded : Bool) {
        if isExpanded
        {
            dropDownImage.image = UIImage(named: "icn_drop_up")
            
            // 템플릿 설명란이 화면에 보여지게
            templateDetail.snp.updateConstraints {
                $0.top.equalTo(jewelImage.snp.bottom).offset(9.adjustedW)
                $0.leading.equalToSuperview().offset(16.adjustedW)
                $0.trailing.equalToSuperview().offset(-16.adjustedW)
                $0.height.equalTo(54.adjustedW)
            }
            templateDetail.isHidden = false
            
            // 작성하러가기 버튼이 화면에 보여지게
            writingBtn.snp.updateConstraints {
                $0.top.equalTo(templateDetail.snp.bottom).offset(16.adjustedW)
                $0.centerX.equalToSuperview()
                $0.width.equalTo(106.adjustedW)
                $0.height.equalTo(26.adjustedW)
            }
            writingBtn.isHidden = false
            contentView.snp.updateConstraints{
                $0.width.equalTo(344.adjustedW)
                $0.height.equalTo(194.adjustedW)
            }
        }
        else {
            dropDownImage.image = UIImage(named: "icn_drop_down")
            
            // 템플릿 설명란이 화면에서 사라지게끔
            templateDetail.snp.updateConstraints {
                $0.height.equalTo(0.adjustedW)
            }
            templateDetail.isHidden = true
            
            // 작성하러가기 버튼이 화면에서 사라지게끔
            writingBtn.snp.updateConstraints {
                $0.height.equalTo(0.adjustedW)
            }
            writingBtn.isHidden = true
            contentView.snp.updateConstraints{
                $0.width.equalTo(344.adjustedW)
                $0.height.equalTo(84.adjustedW)
            }
        }
    }
}

// MARK: - Layout
extension TemplateInfoTVC {
    
    private func setLayout() {
        contentView.backgroundColor = .kGray1        
        contentView.addSubviews([bgView, jewelImage, titleLabel, dropDownImage, templateDetail, writingBtn])
        contentView.addSubview(touchArea)
        
        bgView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(8)
            $0.bottom.equalToSuperview().offset(-8)
            $0.leading.trailing.equalToSuperview()
        }
        
        jewelImage.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16.adjustedW)
            $0.top.equalToSuperview().offset(19.adjustedW)
            $0.width.height.equalTo(46.adjustedW)
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(jewelImage.snp.trailing).offset(14.adjustedW)
            $0.top.equalToSuperview().offset(34.adjustedW)
        }
        
        dropDownImage.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-16.adjustedW)
            $0.top.equalToSuperview().offset(30.adjustedW)
            $0.width.height.equalTo(24.adjustedW)
        }
        
        touchArea.snp.makeConstraints {
            $0.top.equalToSuperview().offset(8)
            $0.height.equalTo(68.adjustedW)
            $0.leading.trailing.equalToSuperview()
        }
        
        templateDetail.snp.makeConstraints {
            $0.top.equalTo(jewelImage.snp.bottom).offset(9.adjustedW)
            $0.leading.equalToSuperview().offset(16.adjustedW)
            $0.trailing.equalToSuperview().offset(-16.adjustedW)
            $0.height.equalTo(54.adjustedW)
        }
        
        writingBtn.snp.makeConstraints {
            $0.top.equalTo(templateDetail.snp.bottom).offset(16.adjustedW)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(106.adjustedW)
            $0.height.equalTo(26.adjustedW)
        }
    }
    
    func dataBind(model: TemplateInfoPublisherModel) {
        jewelImage.image = model.image
        titleLabel.text = model.templateTitle
        templateDetail.text = model.info
    }
}

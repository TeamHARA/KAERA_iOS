//
//  GemStoneCVC.swift
//  KAERA
//
//  Created by 김담인 on 2023/07/14.
//

import UIKit
import SnapKit
import Then

final class GemStoneCVC: UICollectionViewCell {
    
    private let gemStoneImgView = UIImageView()
    
    private let gemStoneTitle = UILabel().then {
        $0.textColor = .kGray5
        $0.font = .kB2R16
        $0.textAlignment = .center
    }
    
    private let containerView = UIView().then {
        $0.backgroundColor = .yellow
    }
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
        self.backgroundColor = .blue
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Function
    func setData(title: String, imageName: String) {
        gemStoneTitle.text = title
        gemStoneImgView.image = UIImage(named: imageName)
        startContainerAnimation()
    }
    
    private func setLayout() {
        self.addSubviews([containerView])
        
        containerView.snp.makeConstraints {
            $0.top.directionalHorizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview().inset(22)
        }
        
        containerView.addSubviews([gemStoneImgView, gemStoneTitle])

        gemStoneImgView.snp.makeConstraints {
            $0.top.centerX.equalToSuperview()
        }
        
        gemStoneTitle.snp.makeConstraints {
            $0.top.equalTo(gemStoneImgView.snp.bottom).offset(3)
            $0.centerX.equalToSuperview()
        }
    }
    
    func startContainerAnimation() {
            // containerView의 최초 위치 설정
            containerView.transform = CGAffineTransform(translationX: 0, y: 0)
            
        UIView.animate(withDuration: 0.9, delay: 0, options: [.autoreverse, .repeat], animations: {
                // containerView를 위로 이동
                self.containerView.transform = CGAffineTransform(translationX: 0, y: 10)
                
                // containerView 안의 subviews들도 함께 이동
                self.gemStoneImgView.transform = CGAffineTransform(translationX: 0, y: 10)
//                self.gemStoneTitle.transform = CGAffineTransform(translationX: 0, y: -10)
            }, completion: nil)
        }
}

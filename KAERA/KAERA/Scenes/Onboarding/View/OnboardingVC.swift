//
//  OnboardingVC.swift
//  KAERA
//
//  Created by saint on 2023/11/23.
//

import UIKit
import SnapKit
import Then

class OnboardingVC: UIViewController {
    
    // MARK: - Properties
    private let imageView = UIImageView()
    private let pageControl = CustomPageControl()
    private let images: [UIImage] = ["onboarding1", "onboarding2", "onboarding3"].compactMap { UIImage(named: $0) }
    
    private var currentPage = 0 {
        didSet {
            imageView.image = images[currentPage]
            pageControl.currentPage = currentPage
            if currentPage == 2 {
                controlBtn.setTitle("시작하기", for: .normal)
            }
            else {
                controlBtn.setTitle("다음으로", for: .normal)
            }
        }
    }
    
    private let controlBtn = UIButton().then {
        $0.backgroundColor = .kYellow1
        $0.titleLabel?.font = .kH1B20
        $0.setTitle("다음으로", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.layer.cornerRadius = 12
    }

    // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true

        setupImageView()
        setupPageControl()
        setLayout()
        setupGestures()
        setButtonAction()
    }
    
    // MARK: - Functions
    private func setupImageView() {
        imageView.contentMode = .scaleAspectFit
        imageView.image = images.first
    }

    private func setupPageControl() {
        pageControl.currentPage = 0
    }

    private func setupGestures() {
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeLeft.direction = .left
        view.addGestureRecognizer(swipeLeft)

        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)
    }
    
    @objc func handleSwipe(_ sender: UISwipeGestureRecognizer) {
        if sender.direction == .left {
            currentPage = min(currentPage + 1, images.count - 1)
        } else if sender.direction == .right {
            currentPage = max(currentPage - 1, 0)
        }
    }
    
    private func setButtonAction() {
        controlBtn.press { [weak self] in
            if self?.currentPage ?? 0 < 2 {
                self?.currentPage += 1
            }
            else {
                // TODO: - 로그인 화면으로 넘어가기
                print("시작?")
            }
        }
    }
}

// MARK: - Layout
extension OnboardingVC {
    private func setLayout() {
        view.backgroundColor = .kGray1
        
        view.addSubviews([imageView, pageControl, controlBtn])

        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.top.equalToSuperview().offset(20)
        }

        pageControl.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(62) // Set the width as needed
            $0.height.equalTo(20) // Set the height as needed
        }
        
        controlBtn.snp.makeConstraints {
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20.adjustedW)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-32)
            $0.height.equalTo(64.adjustedH)
        }
    }
}



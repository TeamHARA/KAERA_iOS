//
//  HomeVC.swift
//  KAERA
//
//  Created by 김담인 on 2023/07/12.
//

import UIKit
import SnapKit
import Then

final class HomeVC: BaseVC {
    
    // MARK: - Properties
    private var currentIndex = 0
    
    private let homeLogoImgView = UIImageView().then {
        $0.image = UIImage(named: "logo")
    }
    
    private let headerBGView = UIView().then {
        $0.backgroundColor = .kGray4
        $0.makeRounded(cornerRadius: 10)
    }
    
    private let headerLabel = UILabel().then {
        $0.textAlignment = .center
        $0.text = "열심히 캐내는 중 ⛏️"
        $0.font = .kB2R16
        $0.textColor = .kGray2
    }
    
    private let pageIcn = UIImageView().then {
        $0.image = UIImage(named: "icn_digging_page")
    }
    
    private let pageContainerView = UIView().then {
        $0.backgroundColor = .clear
    }
    private let pageVC = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
    private let homeDiggingVC = HomeGemStoneVC(type: .digging)
    private let homeDugVC = HomeGemStoneVC(type: .dug)
    private lazy var contents: [UIViewController] = [ homeDiggingVC, homeDugVC ]
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setPageViewController()
        setLayout()
    }
    
    // MARK: - Function
    private func setPageViewController() {
        self.addChild(pageVC)
        pageContainerView.frame = pageVC.view.frame
        pageVC.view.backgroundColor = .kGray1
        pageContainerView.addSubview(pageVC.view)
        pageVC.didMove(toParent: self)
        pageVC.delegate = self
        pageVC.dataSource = self
        if let firstVC = contents.first {
            pageVC.setViewControllers([firstVC], direction: .forward, animated: true)
        }
    }
}

extension HomeVC: UIPageViewControllerDelegate {
    /// Paging 애니메이션이 끝났을 때 처리
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let viewController = pageViewController.viewControllers?.first,
              let index = contents.firstIndex(where: { $0 == viewController })
        else { return }
        currentIndex = index
        if index > 0 {
            headerLabel.text = "그동안 캐낸 보석들 ✨"
            pageIcn.image = UIImage(named: "icn_dug_page")
            headerBGView.snp.updateConstraints {
                $0.width.equalTo(176.adjustedW)
            }
        } else {
            headerLabel.text = "열심히 캐내는 중 ⛏️"
            pageIcn.image = UIImage(named: "icn_digging_page")
            headerBGView.snp.updateConstraints {
                $0.width.equalTo(162.adjustedW)
            }
        }
        
    }
    
}

extension HomeVC: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = contents.firstIndex(of: viewController) else { return nil }
        let previousIndex = index - 1
        if previousIndex < 0 {
            return nil
        }
        return contents[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = contents.firstIndex(of: viewController) else { return nil }
        let nextIndex = index + 1
        if nextIndex == contents.count {
            return nil
        }
        return contents[nextIndex]
    }
    
}

// MARK: -  UI
extension HomeVC {
    private func setLayout() {
        self.view.backgroundColor = .kGray1
        self.view.addSubviews([homeLogoImgView, headerBGView, pageContainerView, pageIcn])
        
        homeLogoImgView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(56)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(38)
            $0.width.equalTo(136)
        }
        
        headerBGView.snp.makeConstraints {
            $0.top.equalTo(homeLogoImgView.snp.bottom).offset(12)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(26)
            $0.width.equalTo(162)
        }
        
        headerBGView.addSubview(headerLabel)
        
        headerLabel.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
        
        pageContainerView.snp.makeConstraints {
            $0.directionalHorizontalEdges.equalToSuperview()
            $0.top.equalTo(headerBGView.snp.bottom).offset(29)
            $0.bottom.equalToSuperview()
        }
        
        pageIcn.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(31)
            $0.height.equalTo(9)
        }
    }
}

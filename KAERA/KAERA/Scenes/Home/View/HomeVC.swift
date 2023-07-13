//
//  HomeVC.swift
//  KAERA
//
//  Created by 김담인 on 2023/07/12.
//

import UIKit
import SnapKit
import Then

class HomeVC: BaseVC {
    
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
    
    private let pageControlView = UIView().then {
        $0.backgroundColor = .clear
    }
    
    private let pageIcn = UIImageView().then {
        $0.image = UIImage(named: "icn_digging_page")
    }
    private let pageVC = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
    private let homeDiggingVC = HomeDiggingVC()
    private let homeDugVC = HomeDugVC()
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
        pageVC.view.backgroundColor = .kGray1
        self.view.addSubview(pageVC.view)
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
                $0.width.equalTo(176)
            }
        } else {
            headerLabel.text = "열심히 캐내는 중 ⛏️"
            pageIcn.image = UIImage(named: "icn_digging_page")
            headerBGView.snp.updateConstraints {
                $0.width.equalTo(162)
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
        self.view.addSubviews([homeLogoImgView, headerBGView, pageControlView])
        
        homeLogoImgView.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide).inset(8)
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
        
        pageControlView.snp.makeConstraints {
            $0.bottom.directionalHorizontalEdges.equalToSuperview()
            $0.height.equalTo(43)
            
        }
        
        pageControlView.addSubview(pageIcn)
        
        pageIcn.snp.makeConstraints {
            $0.top.centerX.equalToSuperview()
            $0.height.equalTo(9)
            $0.width.equalTo(29)
        }
        
    }
}

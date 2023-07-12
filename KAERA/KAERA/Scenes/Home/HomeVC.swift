//
//  HomeVC.swift
//  KAERA
//
//  Created by 김담인 on 2023/07/12.
//

import UIKit

class HomeVC: BaseVC {
    
    // MARK: - Properties
    private var currentIndex = 0
    private let pageVC = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
    private let homeDiggingVC = HomeDiggingVC()
    private let homeDugVC = HomeDugVC()
    private lazy var contents: [UIViewController] = [ homeDiggingVC, homeDugVC ]
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setPageViewController()
    }
    
    // MARK: - Function
    private func setPageViewController() {
        self.addChild(pageVC)
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

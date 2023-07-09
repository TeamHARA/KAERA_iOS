//
//  TabbarController.swift
//  KAERA
//
//  Created by saint on 2023/07/09.
//

import UIKit
import SnapKit
import Then
import SwiftyColor

final class TabBarController: UITabBarController {
    
    // MARK: - Properties
    let fixedHeight: CGFloat = 96
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setTabBar()
        setTabBarStyle()
        self.selectedIndex = 0
        self.delegate = self
    }
    
    // TabBar높이 지정해주는 메서드
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        var tabFrame = self.tabBar.frame
        tabFrame.size.height = fixedHeight
        tabFrame.origin.y = self.view.frame.size.height - fixedHeight
        self.tabBar.frame = tabFrame
        
        // additionalSafeAreaInsets 설정
        /// ViewController가 잘려서 아래 여백을 좀 더 주려고 inset 변경
        self.additionalSafeAreaInsets = UIEdgeInsets(top: 0, left: 0, bottom: -24, right: 0)
    }
    
    // TabBarItem 생성해 주는 메서드
    private func makeTabVC(vc: UIViewController, tabBarImg: String, tabBarSelectedImg: String) -> UIViewController {
        
        vc.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: tabBarImg)?.withRenderingMode(.alwaysOriginal),
                                     selectedImage: UIImage(named: tabBarSelectedImg)?.withRenderingMode(.alwaysOriginal))
        
        return vc
    }
    
    /// TabBarItem을 지정하는 메서드
    func setTabBar() {
        let homeTab = makeTabVC(vc: HomeVC(), tabBarImg:"icn_home_off", tabBarSelectedImg: "icn_home_on")
        homeTab.tabBarItem.tag = 0
        
        let writeTab = makeTabVC(vc: WriteVC(), tabBarImg: "icn_write", tabBarSelectedImg: "avatar_filled")
        writeTab.tabBarItem.tag = 1
        
        let storageTab = makeTabVC(vc: StorageVC(), tabBarImg: "icn_storage_off", tabBarSelectedImg: "icn_storage_on")
        storageTab.tabBarItem.tag = 2
        
        let insetAmount: CGFloat = 32
        homeTab.tabBarItem.imageInsets = UIEdgeInsets(top: -4, left: insetAmount, bottom: 4, right: -insetAmount)
        writeTab.tabBarItem.imageInsets = UIEdgeInsets(top: -4, left: 0, bottom: 4, right: 0)
        storageTab.tabBarItem.imageInsets = UIEdgeInsets(top: -4, left: -insetAmount, bottom: 4, right: insetAmount)
        
        let tabs = [homeTab, writeTab, storageTab]
        self.setViewControllers(tabs, animated: false)
    }
    
    /// TabBar의 Style을 지정하는 메서드
    private func setTabBarStyle() {
        tabBar.backgroundColor = 0x2A2E33.color
        tabBar.isTranslucent = false /// 투명 색 -> 반투명 색으로 바꿔주기 위해 false 로 설정(truetone color)
        
        // 탭바의 테두리를 설정합니다.
        tabBar.layer.borderWidth = 1
        tabBar.layer.borderColor = 0x30363D.color.cgColor
        tabBar.layer.cornerRadius = 30
    }
}

// MARK: - UITabBarControllerDelegate
extension TabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController.tabBarItem.tag == 1 {
            let writeVC = WriteVC()
            writeVC.modalPresentationStyle = .fullScreen
            writeVC.modalTransitionStyle = .coverVertical
            self.present(writeVC, animated: true, completion: nil)
            return false // 탭 변경을 막음
        }
        return true // 다른 탭은 정상적으로 변경
    }
}

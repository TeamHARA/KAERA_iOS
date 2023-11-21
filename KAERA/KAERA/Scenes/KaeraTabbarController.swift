//
//  TabbarController.swift
//  KAERA
//
//  Created by saint on 2023/07/09.
//

import UIKit
import SnapKit
import Then

final class KaeraTabbarController: UITabBarController {
    
    // MARK: - Properties
    let fixedHeight: CGFloat = 96
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setTabBarStyle()
        setTabBar()
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
        /// 탭바 아이콘 위치 조정
        self.additionalSafeAreaInsets = UIEdgeInsets(top: 0, left: 0, bottom: -fixedHeight, right: 0)
    }
    
    // TabBarItem 생성해 주는 메서드
    private func makeTabVC(vc: UIViewController, tabBarImg: String, tabBarSelectedImg: String) -> UIViewController {
        
        vc.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: tabBarImg)?.withRenderingMode(.alwaysOriginal),
                                     selectedImage: UIImage(named: tabBarSelectedImg)?.withRenderingMode(.alwaysOriginal))
        return vc
    }
    
    /// TabBarItem을 지정하는 메서드
    func setTabBar() {
        let homeTab = makeTabVC(vc: BaseNC(rootViewController: HomeVC()), tabBarImg:"icn_home_off", tabBarSelectedImg: "icn_home_on")
        homeTab.tabBarItem.tag = 0
        
        let writeTab = makeTabVC(vc: UIViewController(), tabBarImg: "icn_write", tabBarSelectedImg: "icn_write")
        writeTab.tabBarItem.tag = 1
        
        let archiveTab = makeTabVC(vc: BaseNC(rootViewController: ArchiveVC()), tabBarImg: "icn_archive_off", tabBarSelectedImg: "icn_archive_on")
        archiveTab.tabBarItem.tag = 2
        
        let insetAmount: CGFloat = 32
        homeTab.tabBarItem.imageInsets = UIEdgeInsets(top: -4, left: insetAmount, bottom: 4, right: -insetAmount)
        writeTab.tabBarItem.imageInsets = UIEdgeInsets(top: -4, left: 0, bottom: 4, right: 0)
        archiveTab.tabBarItem.imageInsets = UIEdgeInsets(top: -4, left: -insetAmount, bottom: 4, right: insetAmount)
        
        let tabs = [homeTab, writeTab, archiveTab]
        self.setViewControllers(tabs, animated: false)
    }
    
    /// TabBar의 Style을 지정하는 메서드
    private func setTabBarStyle() {
        view.backgroundColor = .kGray1
        tabBar.backgroundColor = .kGray2
        tabBar.isTranslucent = false /// 투명 색 -> 반투명 색으로 바꿔주기 위해 false 로 설정(truetone color)
        
        // 탭바의 테두리를 설정합니다.
        tabBar.layer.cornerRadius = 30
        tabBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
}

// MARK: - UITabBarControllerDelegate
extension KaeraTabbarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController.tabBarItem.tag == 1 {
            if HomeGemStoneCount.shared.count >= 12 {
                let alertVC = KaeraAlertVC(buttonType: .onlyOK, okTitle: "알겠어요!")
                alertVC.setTitleSubTitle(title: "고민 원석이 가득찼어요!", subTitle: "너무 많은 고민은 머릿 속을 어지럽혀요 \n다른 고민들을 끝낸 다음, 새 원석을 생성할 수 있어요")
                self.present(alertVC, animated: true)
            }else {
                let writeVC = WriteVC(type: .post)
                writeVC.modalPresentationStyle = .fullScreen
                writeVC.modalTransitionStyle = .coverVertical
                self.present(writeVC, animated: true, completion: nil)
            }
            return false // 탭 변경을 막음
        }
        return true // 다른 탭은 정상적으로 변경
    }
}

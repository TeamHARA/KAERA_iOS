//
//  BaseVC.swift
//  HARA
//
//  Created by 김담인 on 2022/12/27.
//

import UIKit
import SafariServices

class BaseVC: UIViewController, UIGestureRecognizerDelegate {
    
    // MARK: Properties
    lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        activityIndicator.center = view.center
        
        // 기타 옵션
        activityIndicator.color = .gray
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .medium
        activityIndicator.stopAnimating()
        return activityIndicator
    }()
    
    let screenWidth = UIScreen.main.bounds.size.width
    let screenHeight = UIScreen.main.bounds.size.height
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(activityIndicator)
        setHaraBackGroundColor()
    }
}

// MARK: - Custom Methods
extension BaseVC {
    func hideTabbar() {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    func showTabbar() {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    /// 화면 터치시 키보드 내리는 메서드
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.delegate = self
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func setHaraBackGroundColor() {
        /// 해라 기본 배경 색상으로 변경
        view.backgroundColor = .white
    }
    
    func openSafariVC(url: URL) {
        let safariVC = SFSafariViewController(url: url)
        safariVC.modalPresentationStyle = .pageSheet
        
        self.present(safariVC, animated: true)
    }
    
    func presentNetworkAlert() {
        let alertVC = KaeraAlertVC(buttonType: .onlyOK)
        alertVC.setTitleSubTitle(title: "요청에 실패했어요...😢", subTitle: "잠시후 다시 시도해주세요")
        self.present(alertVC, animated: true)
    }
}

// MARK: - Custom Methods(화면전환)
extension BaseVC {
    
    /// 특정 탭의 루트 뷰컨으로 이동시키는 메서드
    func goToRootOfTab(index: Int) {
        tabBarController?.selectedIndex = index
        if let nav = tabBarController?.viewControllers?[index] as? UINavigationController {
            nav.popToRootViewController(animated: true)
        }
    }
}

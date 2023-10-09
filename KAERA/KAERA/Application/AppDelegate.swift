//
//  AppDelegate.swift
//  KAERA
//
//  Created by 김담인 on 2023/06/29.
//

import UIKit
import KakaoSDKCommon
import Firebase
import UserNotifications



@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        KakaoSDK.initSDK(appKey: Environment.kakaoAppKey)
        // Firebase SDK 초기화
        FirebaseApp.configure()
        
        // 원격 알림 등록
        UNUserNotificationCenter.current().delegate = self
        application.registerForRemoteNotifications()
        
        /// 메시지 대리자 설정
        Messaging.messaging().delegate = self
        
        /// 푸시 권한 요청하기
        requestNotificationPermission()
        
        /// 자동 초기화 방지
        Messaging.messaging().isAutoInitEnabled = true
        
        /// 현재 등록 토큰 가져오기
        Messaging.messaging().token { token, error in
            if let error = error {
                print("Error fetching FCM registration token: \(error)")
            } else if let token = token {
                print("FCM registration token: \(token)")
                /// 키체인에 FCM Token 저장
                KeychainManager.save(key: .fcmToken, value: token)
            }
        }
        
        return true
    }
    
    /// 푸시 권한 요청
    private func requestNotificationPermission() {
        var originalStatus: Bool = false
        /// 현재 알림 세팅 값 확인
        UNUserNotificationCenter.current().getNotificationSettings { setting in
            originalStatus = setting.alertSetting == .enabled
        }
        /// 요청할 권한 옵션
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: {didAllow, Error in
            if didAllow {
                if originalStatus == false {
                    debugPrint("Push: 권한 허용")
                }
            } else {
                debugPrint("Push: 권한 거부")
            }
        })
    }
    
    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
    
    /// APN 토큰과 등록 토큰 매핑
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
    
    /// APN 토큰과 등록 토큰 매핑 실패
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        debugPrint("APN 토큰 등록 실패", "fail")
    }
    
    /// 디바이스 세로방향으로 고정
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
}

// MARK: - MessagingDelegate
extension AppDelegate: MessagingDelegate {
    
    /// 토큰 갱신 모니터링 메서드
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(String(describing: fcmToken))")
        
        if let fcmToken {
            print("Saved FCM Token: \(fcmToken)")
            /// 키체인에 FCM Token 저장
            KeychainManager.save(key: .fcmToken, value: fcmToken)
        }else {
            print("Failed Saving FCM Token")
        }
        
        /// 토큰을 NotificaitonCenter로 post
        let dataDict: [String: String] = ["token": fcmToken ?? ""]
        NotificationCenter.default.post(
            name: Notification.Name("FCMToken"),
            object: nil,
            userInfo: dataDict
        )
       
    }
    
    /// 아래 코드로 갱신된 토큰을 옵저버로 받아서 사용가능
    /*
    NotificationCenter.default.addObserver(self, selector: #selector(getNotification), name: Notification.Name(rawValue: "FCMToken"), object: nil)
    
    @objc func getNotification(_ notification: NSNotification){
        guard let tokenDictionary = notification.userInfo as! [String:Any]? else {
            return
        }
        let token: String  = tokenDictionary["token"] as! String
        print("Got TOKEN \(token)")
    }
     */
    
}

// MARK: - UNUserNotificationCenterDelegate
extension AppDelegate: UNUserNotificationCenterDelegate {
    
    /// foreGround에 푸시알림이 올 때 실행되는 메서드 + completion으로 어떻게 알림을 보여줄지 선택가능
    func userNotificationCenter(_ center: UNUserNotificationCenter,willPresent notification: UNNotification,withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.badge, .sound, .list, .banner])
    }
    
    /// 푸시알림을 클릭했을 때 실행되는 메서드
    func userNotificationCenter(_ center: UNUserNotificationCenter,didReceive response: UNNotificationResponse,withCompletionHandler completionHandler: @escaping () -> Void) {
        //TODO: 푸시알림을 통해 진입시 액션 구현
        completionHandler()
    }
}

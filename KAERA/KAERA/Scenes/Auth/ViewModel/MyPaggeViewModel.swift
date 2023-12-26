//
//  MyPaggeViewModel.swift
//  KAERA
//
//  Created by 김담인 on 2023/10/17.
//

import Foundation
import Combine
import UserNotifications
import KakaoSDKUser

final class MyPaggeViewModel: ViewModelType {
    
    typealias Input = AnyPublisher<MyPageInputType, Never>
    typealias Output = AnyPublisher<MyPageOutputType, Never>
    
    private let output = PassthroughSubject<MyPageOutputType, Never>.init()
    
    private var cancellables = Set<AnyCancellable>()
    
    private static var myPageURLs = Array<URL>()
    
    private static let accountAlertInfo = [MyPageAccountAlertInfoModel(okTitle: "로그아웃", title: "로그아웃하시겠어요?", subTitle: "고민 원석과 보석은 저장되고 있어요", type: .signOut), MyPageAccountAlertInfoModel(okTitle: "탈퇴", title: "정말로 캐라를 떠나실 건가요?", subTitle: "탈퇴 후 내용은 복구가 불가능해요😢", type: .delete)]
    
    private var myPageTVCModels: [MyPageTVCModel] = []
    
    
    func transform(input: Input) -> Output{
        input
            .sink { inputType in
                self.selectOutput(input: inputType)
            }
            .store(in: &cancellables)
        return output.eraseToAnyPublisher()
    }
    
    private func selectOutput(input: MyPageInputType) {
        switch input {
        case .loadData:
            requestMyPageData()
        case .push:
            checkPushState()
        case .accountAction(type: let type):
            requestAccountAction(type: type)
        }
    }
    
    private func checkPushState() {
        let priorState = PushSettingInfo.shared.isPushOn
        UNUserNotificationCenter.current().getNotificationSettings { setting in
            PushSettingInfo.shared.isPushOn = setting.alertSetting == .enabled
            let hasChanged: Bool = priorState != PushSettingInfo.shared.isPushOn
            ///  이전과 상태과 바뀌었으면 상태값 send
            if hasChanged{
                self.output.send(.push(hasChanged: hasChanged))
            }
        }
    }

    private func requestMyPageData() {
        UNUserNotificationCenter.current().getNotificationSettings { setting in
            PushSettingInfo.shared.isPushOn = setting.alertSetting == .enabled
        }
        
        let urlStringArray = [
            "https://daffy-lawyer-1b8.notion.site/Kaera-bd1d79798c2542728761fa628e49ada6?pvs=4",
            "https://instagram.com/kaera.app?igshid=OGQ5ZDc2ODk2ZA%3D%3D&utm_source=qr",
            "https://daffy-lawyer-1b8.notion.site/e4383e48fd2a4e32b44d9d01ba663fd5?pvs=4",
            "https://daffy-lawyer-1b8.notion.site/baf26a6459024af89fdfec26031adcf1?pvs=4"]
        var urls = Array<URL>()
        urlStringArray.forEach { url in
            if let url = URL(string: url) {
                urls.append(url)
            }
        }
        MyPaggeViewModel.myPageURLs = urls
        
        let updatedMyPageTVCModel = updateMypageURLModel()
        
        self.output.send(.data(data: updatedMyPageTVCModel))
    }
    
    private func updateMypageURLModel() -> [MyPageTVCModel] {
        myPageTVCModels = [
            MyPageTVCModel(headerTitle: "알림설정", rowTitles: ["Push 알림"], rowButton: .push),
            MyPageTVCModel(headerTitle: "정보", rowTitles: ["캐라 사용설명서", "인스타그램", "서비스 이용약관", "개인정보 처리방침"], rowButton: .next(myPageURLs: MyPaggeViewModel.myPageURLs)),
            MyPageTVCModel(headerTitle: "", rowTitles: ["로그아웃","계정탈퇴"], rowButton: .account(data: MyPaggeViewModel.accountAlertInfo))
        ]
        return myPageTVCModels
    }
    
    private func requestAccountAction(type: AccountActionType) {
        switch type {
        case .signOut:
            requestSignOut()
        case .delete:
            requestDeleteAccount()
        }
    }
    
    private func requestSignOut() {
        KeychainManager.delete(key: .accessToken)
        AuthAPI.shared.postLogout { [weak self] status in
            guard status != nil else {
                self?.output.send(.networkFail)
                return
            }
            if UserDefaults.standard.bool(forKey: "isKakaoLogin") {
                UserApi.shared.logout {(error) in
                    if error != nil {
                        self?.output.send(.networkFail)
                        return
                    }
                }
            }
            
            KeychainManager.delete(key: .accessToken)
            self?.output.send(.accountAction(type: .signOut))
        }
    }
    
    private func requestDeleteAccount() {
        AuthAPI.shared.deleteAccount { [weak self] status in
            guard status != nil else {
                self?.output.send(.networkFail)
                return
            }
            if UserDefaults.standard.bool(forKey: "isKakaoLogin") {
                UserApi.shared.unlink {(error) in
                    if error != nil {
                        self?.output.send(.networkFail)
                        return
                    }
                }
            }
            
            KeychainManager.delete(key: .accessToken)
            KeychainManager.delete(key: .refreshToken)
            KeychainManager.delete(key: .fcmToken)
            KeychainManager.delete(key: .userId)
            self?.output.send(.accountAction(type: .delete))
        }
    }
}

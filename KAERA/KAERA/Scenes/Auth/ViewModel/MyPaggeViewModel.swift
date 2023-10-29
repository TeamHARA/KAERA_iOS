//
//  MyPaggeViewModel.swift
//  KAERA
//
//  Created by 김담인 on 2023/10/17.
//

import Foundation
import Combine
import UserNotifications


final class MyPaggeViewModel: ViewModelType {
    
    typealias Input = AnyPublisher<MyPageInputType, Never>
    typealias Output = AnyPublisher<MyPageOutputType, Never>
    
    private let output = PassthroughSubject<MyPageOutputType, Never>.init()
    
    private var cancellables = Set<AnyCancellable>()
    
    private static var myPageURLs = Array<URL>()
    
    private static let accountAlertInfo = [MyPageAccountAlertInfoModel(okTitle: "로그아웃", title: "로그아웃하시겠어요?", subTitle: "고민 원석과 보석은 저장되고 있어요", type: .signOut), MyPageAccountAlertInfoModel(okTitle: "탈퇴", title: "정말로 캐라를 떠나실 건가요?", subTitle: "탈퇴 후 내용은 복구가 불가능해요😢", type: .delete)]
    
    private var myPageTVCModels: [MyPageTVCModel] = [
        MyPageTVCModel(headerTitle: "알림설정", rowTitles: ["Push 알림"], rowButton: .push),
        MyPageTVCModel(headerTitle: "정보", rowTitles: ["캐라 사용설명서", "인스타그램", "서비스 이용약관", "개인정보 처리방침"], rowButton: .next(myPageURLs: myPageURLs)),
        MyPageTVCModel(headerTitle: "", rowTitles: ["로그아웃","계정탈퇴"], rowButton: .account(data: accountAlertInfo))
    ]
    
    
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
            requestMyPageURLs()
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

    private func requestMyPageURLs() {
        //TODO: 서버에 URL 받아오기
        let result = [
            "https://daffy-lawyer-1b8.notion.site/HARA-da398bb18b39485ba103a9daf7a2bfa3",
            "https://www.google.com",
            "https://github.com/TeamHARA/KAERA_iOS",
            "https://www.notion.so/TEAM-cd8e429815a54c64b67ad272499f8e22?pvs=4"]
        
        var urls = Array<URL>()
        
        result.forEach { url in
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
        print("로그아웃 호출")
        output.send(.accountAction)
    }
    
    private func requestDeleteAccount() {
        print("회원탈퇴 호출")
        output.send(.accountAction)
    }
}

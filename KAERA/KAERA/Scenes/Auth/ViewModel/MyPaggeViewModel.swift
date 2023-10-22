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
    
    private let myPageTVCModels: [MyPageTVCModel] = [
        MyPageTVCModel(headerTitle: "알림설정", rowTitles: ["Push 알림"], rowButton: .push),
        MyPageTVCModel(headerTitle: "정보", rowTitles: ["캐라 사용설명서", "인스타그램", "서비스 이용약관", "개인정보 처리방침"], rowButton: .next),
        MyPageTVCModel(headerTitle: "", rowTitles: ["로그아웃","계정탈퇴"], rowButton: .none)
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
            checkPushState()
            self.output.send(.data(data: myPageTVCModels))
        case .action(indexPath: let indexPath):
            setInputAction(indePath: indexPath)
        }
    }
    
    private func setInputAction(indePath: IndexPath) {
        switch indePath.section {
        case 0:
            checkPushState()
        case 1:
            setInfoPage(row: indePath.row)
        case 2:
            self.output.send(.account)
        default:
            break
        }
    }
    
    private func checkPushState() {
        let priorState = PushSettingInfo.shared.isPushOn
        UNUserNotificationCenter.current().getNotificationSettings { setting in
            PushSettingInfo.shared.isPushOn = setting.alertSetting == .enabled
            let hasChanged: Bool = priorState != PushSettingInfo.shared.isPushOn
            self.output.send(.push(hasChanged: hasChanged))
        }
    }
    
    //TODO: API나오면 서버 리스폰스 모델로 교체
    struct MyPageInforURLs {
        let manual: String
        let instagram: String
        let privacy: String
        let openSource: String
    }
    
    let myPageURLs = MyPageInforURLs(manual: "https://www.google.com", instagram: "https://www.naver.com", privacy: "", openSource: "")
    
    private func setInfoPage(row: Int) {
        var urlString = ""
        switch row {
        case 0:
            urlString = myPageURLs.manual
        case 1:
            urlString = myPageURLs.instagram
        case 2:
            urlString = myPageURLs.privacy
        case 3:
            urlString = myPageURLs.openSource
        default:
            urlString = ""
        }
        if let url = URL(string: urlString) {
            self.output.send(.notice(url: url))
        }
    }


}

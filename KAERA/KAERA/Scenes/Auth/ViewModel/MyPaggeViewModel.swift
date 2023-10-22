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
        MyPageTVCModel(headerTitle: "정보", rowTitles: ["인스타그램", "서비스 이용약관", "개인정보 처리방침"], rowButton: .next),
        MyPageTVCModel(headerTitle: "", rowTitles: ["로그아웃","계정탈퇴"], rowButton: .none)
    ]
        
    func transform(input: Input) -> Output{
        input
            .sink { inputType in
                print(inputType)
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
            setNoticePage(row: indePath.row)
        case 2:
            self.output.send(.account)
        default:
            break
        }
    }
    private func setNoticePage(row: Int) {
        self.output.send(.notice)
    }
    
    private func checkPushState() {
        let priorState = PushSettingInfo.shared.isPushOn
        UNUserNotificationCenter.current().getNotificationSettings { setting in
            PushSettingInfo.shared.isPushOn = setting.alertSetting == .enabled
            let hasChanged: Bool = priorState != PushSettingInfo.shared.isPushOn
            self.output.send(.push(hasChanged: hasChanged))
        }
    }

}

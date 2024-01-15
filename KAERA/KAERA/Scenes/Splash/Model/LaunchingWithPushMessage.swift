//
//  LaunchingWithPushMessage.swift
//  KAERA
//
//  Created by 김담인 on 2024/01/13.
//

import Foundation

final class LaunchingWithPushMessage {
    
    static let shared = LaunchingWithPushMessage()
    var hasLaunchedWithPush: Bool = false
    var worryId: Int? = nil
    private init() { }
}

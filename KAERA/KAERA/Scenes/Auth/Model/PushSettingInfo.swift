//
//  PushSettingInfo.swift
//  KAERA
//
//  Created by 김담인 on 2023/10/18.
//

import Foundation

final class PushSettingInfo {
    
    static let shared = PushSettingInfo()
    
    var isPushOn: Bool = false
    
    private init() { }
}

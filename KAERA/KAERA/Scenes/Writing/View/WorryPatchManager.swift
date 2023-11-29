//
//  WorryPatchManager.swift
//  KAERA
//
//  Created by saint on 2023/10/15.
//

import Foundation

class WorryPatchManager {
    static let shared = WorryPatchManager()

    var worryId: Int = 1
    var templateId: Int = 1
    var title: String = ""
    var answers: [String] = []
    
    func clearWorryData() {
        title = ""
        answers = []
    }

    private init() { }
}


//
//  ViewModelType.swift
//  KAERA
//
//  Created by 김담인 on 2023/07/25.
//

import Foundation

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}

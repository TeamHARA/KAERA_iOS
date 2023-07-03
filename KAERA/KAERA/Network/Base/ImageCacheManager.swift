//
//  ImageCacheManager.swift
//  HARA
//
//  Created by 김담인 on 2023/01/02.
//

import UIKit

/// 캐시를 저장해 놓을 싱글톤 클래스
class ImageCacheManager {
    static let shared = NSCache<NSString, UIImage>()
    private init() {}
}

//
//  NSObject+.swift
//  HARA
//
//  Created by 김담인 on 2023/01/01.
//

import Foundation

extension NSObject {
  static var className: String {
    return String(describing: self)
  }
}
func + (left: NSAttributedString, right: NSAttributedString) -> NSAttributedString
{
  let result = NSMutableAttributedString()
  result.append(left)
  result.append(right)
  return result
}

extension NSObject {
  
    static var classIdentifier: String {
        NSStringFromClass(self.classForCoder()).components(separatedBy: ".").last!
    }
     var classIdentifier: String {
        NSStringFromClass(self.classForCoder).components(separatedBy: ".").last!
    }
}

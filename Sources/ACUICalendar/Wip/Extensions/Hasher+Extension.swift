//
//  Hasher+Extension.swift
//  ACUICalendar
//

import Foundation

extension Hasher {

  mutating func combine(_ rect: CGRect) {
    combine(rect.origin.x)
    combine(rect.origin.y)
    combine(rect.size.width)
    combine(rect.size.height)
  }
}

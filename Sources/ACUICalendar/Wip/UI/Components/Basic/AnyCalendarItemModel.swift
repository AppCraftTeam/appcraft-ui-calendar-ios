//
//  AnyCalendarItemModel.swift
//  ACUICalendar
//

import UIKit

public protocol AnyCalendarItemModel {
  var _itemViewDifferentiator: _CalendarItemViewDifferentiator { get }

  func _createView() -> UIView
  func _updateComponents(onViewOfSameType view: UIView)
  func _isContentEqual(toContentOf other: AnyCalendarItemModel) -> Bool
}

public struct _CalendarItemViewDifferentiator: Hashable {
  let viewType: ObjectIdentifier
  let viewModel: AnyHashable
}

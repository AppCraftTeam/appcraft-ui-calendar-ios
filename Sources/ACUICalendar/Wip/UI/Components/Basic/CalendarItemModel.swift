//
//  CalendarItemModel.swift
//  ACUICalendar
//
//

import Foundation
import UIKit

public struct CalendarItemModel<ViewRepresentable>: AnyCalendarItemModel where ViewRepresentable: CalendarItemViewRepresentable {
    
    public let _itemViewDifferentiator: _CalendarItemViewDifferentiator
    
    private let viewModel: ViewRepresentable.ViewModel
    private var content: ViewRepresentable.Content?
    
    public init(viewModel: ViewRepresentable.ViewModel, content: ViewRepresentable.Content) {
        _itemViewDifferentiator = _CalendarItemViewDifferentiator(
            viewType: ObjectIdentifier(ViewRepresentable.self),
            viewModel: viewModel
        )
        
        self.viewModel = viewModel
        self.content = content
    }
    
    public func _createView() -> UIView {
        ViewRepresentable.createView(withViewModel: viewModel)
    }
    
    public func _updateComponents(onViewOfSameType view: UIView) {
        guard let content,
              let view = view as? ViewRepresentable.ViewType else {
            return
        }
        
        ViewRepresentable.updateComponents(content, on: view)
    }
    
    public func _isContentEqual(toContentOf other: AnyCalendarItemModel) -> Bool {
        guard let other = other as? Self else {
            return false
        }
        
        return content == other.content
    }
}

extension CalendarItemModel where ViewRepresentable.Content == Never {
    
    public init(viewModel: ViewRepresentable.ViewModel) {
        _itemViewDifferentiator = _CalendarItemViewDifferentiator(
            viewType: ObjectIdentifier(ViewRepresentable.self),
            viewModel: viewModel
        )
        
        self.viewModel = viewModel
        content = nil
    }
}

extension CalendarItemViewRepresentable {
    
    public static func calendarItemModel(viewModel: ViewModel, content: Content) -> CalendarItemModel<Self> {
        CalendarItemModel<Self>(viewModel: viewModel, content: content)
    }
}

extension CalendarItemViewRepresentable where Content == Never {
    
    public static func calendarItemModel(viewModel: ViewModel) -> CalendarItemModel<Self> {
        CalendarItemModel<Self>(viewModel: viewModel)
    }
}

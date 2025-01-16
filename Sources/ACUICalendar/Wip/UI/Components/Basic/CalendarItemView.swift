//
//  CalendarItemView.swift
//  ACUICalendar
//

import UIKit

class CalendarItemView: UIView {
    
    let contentView: UIView
    
    var selectionHandler: (() -> Void)?
    
    var itemType: VisibleItem.ItemType?
    
    var calendarItemModel: AnyCalendarItemModel {
        didSet {
            guard calendarItemModel._itemViewDifferentiator == oldValue._itemViewDifferentiator else {
                return
            }
            
            guard !calendarItemModel._isContentEqual(toContentOf: oldValue) else { return }
            
            updateContent()
        }
    }
    
    init(initialCalendarItemModel: AnyCalendarItemModel) {
        calendarItemModel = initialCalendarItemModel
        contentView = calendarItemModel._createView()
        
        super.init(frame: .zero)
        
        contentView.insetsLayoutMarginsFromSafeArea = false
        addSubview(contentView)
        
        updateContent()
    }
    
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override class var layerClass: AnyClass {
        CATransformLayer.self
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = bounds
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        if touches.first.map(isTouchInView(_:)) ?? false {
            selectionHandler?()
        }
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        if view === self {
            return nil
        }
        
        return view
    }
    
    private func updateContent() {
        calendarItemModel._updateComponents(onViewOfSameType: contentView)
    }
    
    private func isTouchInView(_ touch: UITouch) -> Bool {
        contentView.bounds.contains(touch.location(in: contentView))
    }
}

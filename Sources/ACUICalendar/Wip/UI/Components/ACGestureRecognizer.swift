//
//  ACGestureRecognizer.swift
//  ACUICalendar
//
//  Created by Pavel Moslienko on 30.01.2025.
//

import UIKit

open class ACGestureRecognizer: UIGestureRecognizer, UIGestureRecognizerDelegate {
    
    private weak var calendarView: ACCalendarViewWip?
    
    open var didHandleGesture: ((_ gestureRecognizer: UIGestureRecognizer) -> Void)?
    
    init(calendarView: ACCalendarViewWip) {
        self.calendarView = calendarView
        super.init(target: nil, action: nil)
    }
    
    lazy open var panGestureRecognizer: UIPanGestureRecognizer = {
        let gestureRecognizer = UIPanGestureRecognizer(
            target: self,
            action: #selector(handleGesture(_:))
        )
        gestureRecognizer.maximumNumberOfTouches = 1
        gestureRecognizer.delegate = self
        
        return gestureRecognizer
    }()
    
    lazy open var longPressGestureRecognizer: UILongPressGestureRecognizer = {
        let gestureRecognizer = UILongPressGestureRecognizer(
            target: self,
            action: #selector(handleGesture(_:))
        )
        gestureRecognizer.allowableMovement = .greatestFiniteMagnitude
        gestureRecognizer.delegate = self
        
        return gestureRecognizer
    }()
    
    open func configureGestures() {
        if calendarView?.multiDaySelectionDragHandler == nil {
            calendarView?.removeGestureRecognizer(panGestureRecognizer)
            calendarView?.removeGestureRecognizer(longPressGestureRecognizer)
        } else {
            calendarView?.addGestureRecognizer(panGestureRecognizer)
            calendarView?.addGestureRecognizer(longPressGestureRecognizer)
        }
    }
    
    open func gestureRecognizer( _ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let calendarView else {
            return false
        }
        
        let isMultiSelectGesture = gestureRecognizer === longPressGestureRecognizer || gestureRecognizer === panGestureRecognizer
        let isScrollViewPanGesture = otherGestureRecognizer === calendarView.scrollView.panGestureRecognizer
        let isGestureStateChanged = gestureRecognizer.state == .changed
        
        let shouldRecognizeSimultaneously = isGestureStateChanged && isMultiSelectGesture && isScrollViewPanGesture
        print("isGestureStateChanged \(gestureRecognizer)б isMultiSelectGesture \(isMultiSelectGesture)б isScrollViewPanGesture \(isScrollViewPanGesture)")
        
        return shouldRecognizeSimultaneously
    }
    
    @objc
    open func handleGesture(_ gestureRecognizer: UIGestureRecognizer) {
        guard gestureRecognizer.state != .possible else { return }
        print("gestureRecognizer - \(gestureRecognizer)")
        self.didHandleGesture?(gestureRecognizer)
    }
}

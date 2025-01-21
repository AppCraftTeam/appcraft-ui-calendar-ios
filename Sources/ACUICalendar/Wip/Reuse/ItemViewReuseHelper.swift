//
//  ItemViewReuseHelper.swift
//  ACUICalendar
//

import UIKit

class ItemViewReuseHelper {
    
    private var viewsForVisibleItems: [VisibleItem: CalendarItemView] = [:]
    private var unusedViewsForViewDifferentiators: [_CalendarItemViewDifferentiator: [CalendarItemView]] = [:]
    
    func reusedViewContexts(visibleItems: Set<VisibleItem>) -> [ReusedViewContext] {
        var contexts = [ReusedViewContext]()
        
        var previousViewsForVisibleItems = viewsForVisibleItems
        viewsForVisibleItems.removeAll(keepingCapacity: true)
        
        visibleItems.forEach({ visibleItem in
            let viewDifferentiator = visibleItem.calendarItemModel._itemViewDifferentiator
            let context: ReusedViewContext
            
            if let view = previousViewsForVisibleItems.removeValue(forKey: visibleItem) {
                context = ReusedViewContext(
                    view: view,
                    visibleItem: visibleItem,
                    isViewReused: true,
                    isReusedViewSameAsPreviousView: true
                )
            } else if !(unusedViewsForViewDifferentiators[viewDifferentiator]?.isEmpty ?? true) {
                context = ReusedViewContext(
                    view: unusedViewsForViewDifferentiators[viewDifferentiator]!.remove(at: 0),
                    visibleItem: visibleItem,
                    isViewReused: true,
                    isReusedViewSameAsPreviousView: false
                )
            } else {
                context = ReusedViewContext(
                    view: CalendarItemView(initialCalendarItemModel: visibleItem.calendarItemModel),
                    visibleItem: visibleItem,
                    isViewReused: false,
                    isReusedViewSameAsPreviousView: false
                )
            }
            
            contexts.append(context)
            
            viewsForVisibleItems[visibleItem] = context.view
        })
        
        reuseUnusedViews(from: previousViewsForVisibleItems)
        
        return contexts
    }
    
    private func reuseUnusedViews(from previousViews: [VisibleItem: CalendarItemView]) {
        previousViews.forEach({ (visibleItem, unusedView) in
            let viewDifferentiator = visibleItem.calendarItemModel._itemViewDifferentiator
            unusedViewsForViewDifferentiators[viewDifferentiator, default: .init()].append(unusedView)
        })
    }
}

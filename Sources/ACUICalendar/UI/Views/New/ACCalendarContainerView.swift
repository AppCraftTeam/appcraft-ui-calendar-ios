//
//  ACCalendarContainerView.swift
//  ACUICalendar
//
//  Created by Pavel Moslienko on 14.10.2024.
//

import DPSwift
import UIKit

open class ACCalendarContainerView: ACCalendarBaseView {
    
    // MARK: Props
    var canInsertSections = true
    var isLandscapeOrientation = UIDevice.current.orientation.isLandscape
    
    open var showsOnlyCurrentDaysInMonth = false {
        didSet { /*collectionView.reloadData()*/ }
    }
    
    open var monthHeader: ACMonthHeader? = .init(
        horizonalPosition: .offsetFromPassDays
    )
    
    open var viewBounds: CGRect = .zero {
        didSet {
            reusedScrollView.layoutSubviews()
        }
    }
    
    private var insertionRules: (any ACDateInsertRules)?
    private lazy var pageProvider: ACPageProvider = ACVerticalPageProvider()
    private var isAnimationBusy = false
    
    public private(set) lazy var collectionViewLayout: ACCalendarLayout = ACCalendarVerticalLayout()
    
    open lazy var reusedScrollView: ACReusedScrollView = {
        print("viewBoundsviewBounds - \(viewBounds)")

        let reusedScrollView = ACReusedScrollView(
            frame: viewBounds,
            viewProvider: { index in
                self.createMonthView(index: index)
            },
            frameProvider: { index in
                self.calcMonthFrame(index: index)
            },
            currentIndex: 0,
            incrementIndexAction: { index in
                self.didDispalyedNextMonthView(index: index)
            },
            decrementIndexAction: { index in
                self.didDispalyedPrevMonthView(index: index)
            },
            layoutOrientation: .vertical
        )
        reusedScrollView.backgroundColor = .blue.withAlphaComponent(0.4)

        return reusedScrollView
    }()
    
    open var months: [ACCalendarMonthModel] {
        self.service.months
    }
    
    open var didSelectDates: ContextClosure<[Date]>?
    open var didScrollToMonth: ContextClosure<Date>?
    
    open var itemHeight: Double {
        get {
            self.collectionViewLayout.itemHeight
        }
        set {
            self.collectionViewLayout.itemHeight = newValue
        }
    }
}

private extension ACCalendarContainerView {
    
    func createMonthView(index: Int) -> UIView {
        guard let month = self.service.months[safe: Int(index)] else {
            return UIView()
        }
        let monthView = ACCalendarMonthView(
            month: month,
            theme: self.theme,
            showsOnlyCurrentDaysInMonth: self.showsOnlyCurrentDaysInMonth,
            monthHeader: self.monthHeader
        )
        monthView.didSelectDates = { day in
            self.service.daySelect(day)
            self.didSelectDates?(self.service.datesSelected)
        }
        

        return monthView
    }
    
    func calcMonthFrame(index: Int) -> CGRect {
        guard let month = self.service.months[safe: Int(index)] else {
            return .zero
        }
        let height = CGFloat((month.days.chunked(into: 7).count * 47)) + ACCalendarMonthView.headerHeight + ACCalendarMonthView.headerBottonInset
        let totalHeight = height
        return CGRect(x: 0, y: 0, width: self.viewBounds.width, height: totalHeight)
    }
    


    func didDispalyedNextMonthView(index: Int) -> Int? {
        guard index < self.service.months.count else {
            return nil
        }
        
        if let month = self.service.months[safe: Int(index)] {
            self.service.currentMonthDate = month.monthDate
            //self.calendarView.monthSelectView.updateMonthDateLabel()
        }
        
        return index + 1
    }
    
    func didDispalyedPrevMonthView(index: Int) -> Int? {
        guard index >= 0 else {
            return nil
        }
        //print("changeIndexDecreaseAction - \(index)")
        return index - 1
    }
}

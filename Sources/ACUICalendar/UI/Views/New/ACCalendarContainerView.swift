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
            layoutOrientation: scrollDirection
        )
        reusedScrollView.backgroundColor = .blue.withAlphaComponent(0.4)
        reusedScrollView.delegate = self

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
    
    open func scrollToMonth(on direction: ACCalendarDirection, animated: Bool) {
        guard let monthDate = self.service.month(on: direction) else { return }
        self.scrollToMonth(with: monthDate, animated: animated)
    }
    
    open func scrollToMonth(with monthDate: Date, animated: Bool) {
        func isEqual(_ month: ACCalendarMonthModel) -> Bool {
            self.service.calendar.compare(monthDate, to: month.monthDate, toGranularity: .month) == .orderedSame
        }
        
        guard let index = self.months.firstIndex(where: { isEqual($0) }) else { return }
        self.isAnimationBusy = true
        self.reusedScrollView.scrollToPage(pageIndex: index, animated: animated)
        self.isAnimationBusy = false
    }
    
    // MARK: - Data insertion methods
    func insertPastMonths() {
        guard self.canInsertSections else { return }
        self.canInsertSections.toggle()
        let currentIndex = reusedScrollView.currentIndex

        self.service.asyncGeneratePastDates(count: 12) { [weak self] months in
            guard let self else { return }
            
            if !months.isEmpty {
                let newMonthsCount = months.count
                let newIndex = currentIndex + newMonthsCount
                print("insertPastMonths - \(months.count), currentIndex - \(currentIndex), newIndex - \(newIndex)")
                reusedScrollView.currentIndex = newIndex
                reusedScrollView.scrollToPage(pageIndex: newIndex, animated: false)
            }
            self.canInsertSections.toggle()
        }
    }
    
    func insertFutureMonths() {
        var isAllowFetchNewMonth: Bool {
            guard let lastMonth = service.months.last?.monthDate else {
                return true
            }
            
            return service.currentMonthDate.yearsToDate(endDate: lastMonth) <= 2
        }
        
        guard isAllowFetchNewMonth,
              canInsertSections else { return }
        self.canInsertSections = false
        self.service.asyncGenerateFeatureDates(count: 12) { [weak self] months in
            guard let self else { return }
            print("insertFutureMonths - \(months.count)")
            self.canInsertSections.toggle()
        }
    }
}

private extension ACCalendarContainerView {
    func createMonthView(index: Int) -> UIView {
        guard let month = self.service.months[safe: Int(index)] else {
            return UIView()
        }
        let size = self.calcMonthFrame(index: index)
        let monthView = ACCalendarMonthView(
            month: month,
            theme: self.theme,
            showsOnlyCurrentDaysInMonth: self.showsOnlyCurrentDaysInMonth,
            scrollDirection: self.scrollDirection,
            parentSize: CGSize(width: size.width, height: size.height),
            monthHeader: self.monthHeader
        )
        monthView.didSelectDates = { day in
            self.service.daySelect(day)
            self.didSelectDates?(self.service.datesSelected)
            monthView.setDaySelection()
        }
        monthView.didGettingSelectingType = { day in
            return self.service.daySelected(day)
        }
        monthView.setDaySelection()
        
        return monthView
    }
    
    func calcMonthFrame(index: Int) -> CGRect {
        guard let month = self.service.months[safe: Int(index)] else {
            return .zero
        }
        
        switch self.scrollDirection {
        case .vertical:
            let height = CGFloat((month.days.chunked(into: 7).count * 47)) + ACCalendarMonthView.headerHeight + ACCalendarMonthView.headerBottonInset
            let totalHeight = height
            return CGRect(x: 0, y: 0, width: self.viewBounds.width, height: totalHeight)
        case .horizontal:
            return CGRect(x: 0, y: 0, width: self.viewBounds.width, height: self.viewBounds.height)
        @unknown default:
            return .zero
        }
    }
    
    func didDispalyedNextMonthView(index: Int) -> Int? {
        guard index < self.service.months.count else {
            return nil
        }
        print("didDispalyedNextMonthView \(index), all \(self.service.months.count)")
        if let displayedMonth = self.service.months[safe: index - 2] {
            self.didScrollToMonth?(displayedMonth.monthDate)
        }
        if index <= self.service.months.count {
            self.insertFutureMonths()
        }

        if let month = self.service.months[safe: Int(index)] {
            self.service.currentMonthDate = month.monthDate
            //self.calendarView.monthSelectView.updateMonthDateLabel()
        }
        
        return index + 1
    }
    
    func didDispalyedPrevMonthView(index: Int) -> Int? {
        print("didDispalyedPrevMonthView \(index)")
        guard index >= 0 else {
            self.insertPastMonths()
            return nil
        }
        if let displayedMonth = self.service.months[safe: index - 2] {
            self.didScrollToMonth?(displayedMonth.monthDate)
        }
        //print("changeIndexDecreaseAction - \(index)")
        return index - 1
    }
}


// MARK: - UIScrollViewDelegate
extension ACCalendarContainerView: UIScrollViewDelegate {
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.y / scrollView.frame.width)
        let newOffset = CGPoint(x: scrollView.frame.width * pageIndex, y: 0)
        
        let currentOffset = reusedScrollView.contentOffset
        let contentHeight = reusedScrollView.contentSize.height
        let centerOffsetY = (contentHeight - reusedScrollView.bounds.height) / 2
        let distanceFromCenterY = abs(currentOffset.y - centerOffsetY)
        
        if let month = self.service.months[safe: Int(pageIndex)] {
            print("didDispalyed Current Page: \(pageIndex), \(scrollView.contentOffset.y) newOffset - \(newOffset), scrollView \(scrollView.frame), month \(month.monthDate), distanceFromCenterY \(distanceFromCenterY), centerOffsetY - \(centerOffsetY)")
        }
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x / scrollView.frame.width)
        let newOffset = CGPoint(x: scrollView.frame.width * pageIndex, y: 0)
        //print("Current Page: \(pageIndex), newOffset - \(newOffset), scrollView \(scrollView.frame)")
        
        //scrollView.setContentOffset(newOffset, animated: true)
    }
}

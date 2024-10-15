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
            print("calcMonthFrame layoutSubviews")
            reusedScrollView.layoutSubviews()
        }
    }
    
    private var insertionRules: (any ACDateInsertRules)?
    private lazy var pageProvider: ACPageProvider = ACVerticalPageProvider()
    private var isAnimationBusy = false
    private var currentPage = 0
    
    public private(set) lazy var collectionViewLayout: ACCalendarLayout = ACCalendarVerticalLayout()
    
    open lazy var reusedScrollView: ACReusedScrollView = {
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
        let view = UIButton(type: .system)
        view.setTitle("Hello, \(index)", for: [])
        view.tintColor = .red
        print("index - \(index), all \(self.service.months.count)")
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
        
        monthView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(monthView)
        NSLayoutConstraint.activate([
            monthView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            monthView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            monthView.topAnchor.constraint(equalTo: view.topAnchor),
            monthView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        monthView.layoutSubviews()
        view.layoutSubviews()
        
        print("0 calcMonthFrame create view \(self.viewBounds) for \(index)")


        return view
    }
    
    func calcMonthFrame(index: Int) -> CGRect {
        print("zzz calcMonthFrame \(self.viewBounds) for \(index)")
        guard let month = self.service.months[safe: Int(index)] else {
            return .zero
        }
        //return CGRect(x: 0, y: 0, width: viewBounds.width, height: 300.0)
        let height = CGFloat((month.weeksCount * 47)) + ACCalendarMonthView.headerHeight + ACCalendarMonthView.headerBottonInset
        print("heightheight - \(height), \(month.weeksCount) for \(index)")
        let totalHeight = height
        return CGRect(x: 0, y: 0, width: self.viewBounds.width, height: totalHeight)
    }
    


    func didDispalyedNextMonthView(index: Int) -> Int {
        guard index < self.service.months.count else {
            return index
        }
        
        self.currentPage += 1
        if let month = self.service.months[safe: Int(index)] {
            self.service.currentMonthDate = month.monthDate
            //self.calendarView.monthSelectView.updateMonthDateLabel()
        }
        
        return self.currentPage
    }
    
    func didDispalyedPrevMonthView(index: Int) -> Int {
        //print("changeIndexDecreaseAction - \(index)")
        guard index > 0 else {
            return index
        }
        self.currentPage -= 1
        return self.currentPage
    }
}

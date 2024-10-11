//
//  ACCalendarDayViewController.swift
//  ACUICalendarDemo
//
//  Created by Дмитрий Поляков on 23.08.2022.
//

import UIKit
import DPSwift

open class ACCalendarDayViewController: UIViewController {
    
    /// Enumeration of possible calendar height settings
    public enum CalendarHeight {
        case fullscreen
        case fix(Double)
        case percent(Double)
    }
    
    // MARK: - Init
    public init(service: ACCalendarService = .default(), height: CalendarHeight = .fullscreen) {
        self.service = service
        self.calendarHeight = height
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Open properties
    /// An object that provides a set of methods for working with calendar data
    open var service: ACCalendarService
    
    /// Calendar height setting
    public let calendarHeight: CalendarHeight
    
    /// Calendar view
    ///
    /// The view serves as a wrapper to a collection view of the calendar and its components, such as date picker, month switcher
    open lazy var calendarView: ACCalendarView = {
        ACCalendarView(service: self.service)
    }()
    
    /// A boolean value indicating whether to show days from neighboring months in the current month
    open var showsOnlyCurrentDaysInMonth: Bool {
        get {
            self.calendarView.dayCollectionView.showsOnlyCurrentDaysInMonth
        }
        set {
            self.calendarView.dayCollectionView.showsOnlyCurrentDaysInMonth = newValue
        }
    }
    
    /// A boolean value indicating whether a component with arrow buttons that switch months page by page will be displayed.
    open var monthArrowSwitcherIsHidden: Bool {
        get { self.calendarView.arrowsView.isHidden }
        set {
            self.calendarView.arrowsView.isHidden = newValue
        }
    }
    
    /// A boolean value indicating whether the view button of the date picker should work
    open var monthDatePickerViewEnabled: Bool {
        get { self.calendarView.monthSelectView.isUserInteractionEnabled }
        set {
            self.calendarView.monthSelectView.isUserInteractionEnabled = newValue
        }
    }
    
    /// The inset distances for views, taking the user interface layout direction into account.
    open var contentInsets: NSDirectionalEdgeInsets {
        get { self.calendarView.contentInsets }
        set {
            self.calendarView.contentInsets = newValue
        }
    }
    
    open var itemHeight: Double {
        get { self.calendarView.dayCollectionView.itemHeight }
        set {
            self.calendarView.dayCollectionView.itemHeight = newValue
        }
    }
    
    // MARK: Actions
    open var onTapCancel: Closure?
    open var onTapDone: ContextClosure<ACCalendarService>?
    
    // MARK: - Internal properties
    var isPortraitOrientation = UIDevice.current.orientation.isPortrait
    
    var portraitConstraint: NSLayoutConstraint?
    var landscapeConstraint: NSLayoutConstraint?

    // MARK: - Lifecycle methods
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = ACCalendarUITheme().backgroundColor
        
        let guide = self.view.safeAreaLayoutGuide
        self.calendarView.backgroundColor = ACCalendarUITheme().backgroundColor
        self.calendarView.removeFromSuperview()
        self.calendarView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(self.calendarView)
        
        NSLayoutConstraint.activate([
            self.calendarView.topAnchor.constraint(equalTo: guide.topAnchor),
            self.calendarView.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            self.calendarView.trailingAnchor.constraint(equalTo: guide.trailingAnchor)
        ])
        
        self.setupCalendarViewSizeConstraint()
        
        if UIDevice.current.orientation.isLandscape {
            self.landscapeConstraint?.isActive = true
        } else {
            self.portraitConstraint?.isActive = true
        }
        
        self.navigationItem.leftBarButtonItem = .init(title: "Cancel", style: .plain, target: self, action: #selector(self.handleTapCancel))
        self.navigationItem.rightBarButtonItem = .init(title: "Done", style: .plain, target: self, action: #selector(self.handleTapDone))
        
        var page = 0
        
        let reusedScrollView = ACReusedScrollView(
            frame: self.view.bounds,
            viewProvider: { index in
                let view = UIButton(type: .system)
                view.setTitle("Hello, \(index)", for: [])
                view.tintColor = .red
                print("index - \(index), all \(self.service.months.count)")
                guard let month = self.service.months[safe: Int(index)] else {
                    return UIView()
                }
                let monthView = ACCalendarMonthView(
                    month: month,
                    theme: self.calendarView.theme,
                    showsOnlyCurrentDaysInMonth: self.showsOnlyCurrentDaysInMonth,
                    monthHeader: self.calendarView.dayCollectionView.monthHeader
                )
                monthView.didSelectDates = { day in
                    self.service.daySelect(day)
                    self.calendarView.dayCollectionView.didSelectDates?(self.service.datesSelected)
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
                
                return view
            },
            frameProvider: { index in
                //print("contentFrame for - \(index)")
//                guard let month = self.service.months[safe: Int(index)] else {
//                    return .zero
//                }
//                let height = (month.weeksCount * 45) - 10
//                print("heightheight - \(height)")
//                let totalHeight = CGFloat(height)
//                return CGRect(x: 0, y: 0, width: self.view.bounds.width, height: totalHeight)
                return CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 300.0)
            },
            currentIndex: 0,
            incrementIndexAction: { index in
                //print("changeIndexIncreaseAction - \(index)")
                page += 1
                if let month = self.service.months[safe: Int(index)] {
                    self.service.currentMonthDate = month.monthDate
                    self.calendarView.monthSelectView.updateMonthDateLabel()
                }
                
                return page
            },
            decrementIndexAction: { index in
                //print("changeIndexDecreaseAction - \(index)")
                page -= 1
                return page
            },
            layoutOrientation: .vertical
        )
        
        reusedScrollView.backgroundColor = .blue.withAlphaComponent(0.4)
        
        self.view.addSubview(reusedScrollView)
        NSLayoutConstraint.activate([
            reusedScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            reusedScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            reusedScrollView.topAnchor.constraint(equalTo: view.topAnchor),
            reusedScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    open override func viewWillTransition(
        to size: CGSize,
        with coordinator: UIViewControllerTransitionCoordinator
    ) {
        super.viewWillTransition(to: size, with: coordinator)
        if isPortraitOrientation != UIDevice.current.orientation.isPortrait {
            self.isPortraitOrientation = UIDevice.current.orientation.isPortrait
            self.updateConstraintsAfterChangingOrientation()
        }
    }
    
    // MARK: - Coniguration
    open func setCalendarLayout(
        _ layout: any ACCalendarCollectionViewLayoutConfigurator,
        animated: Bool,
        completion: ((Bool) -> Void)? = nil
    ) {
        self.calendarView.dayCollectionView.setCollectionViewLayout(layout, animated: animated)
    }
    
    // MARK: - Setup & Update methods
    private func setupCalendarViewSizeConstraint() {
        
        let guide = self.view.safeAreaLayoutGuide
        
        self.landscapeConstraint = calendarView.bottomAnchor.constraint(equalTo: guide.bottomAnchor)
        
        self.portraitConstraint = switch calendarHeight {
        case .fullscreen:
            self.calendarView.bottomAnchor.constraint(equalTo: guide.bottomAnchor)
        case .fix(let value):
            self.calendarView.heightAnchor.constraint(equalToConstant: value)
        case .percent(let value):
            self.calendarView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: value)
        }
    }
    
    open func updateConstraintsAfterChangingOrientation() {
        if isPortraitOrientation {
            self.landscapeConstraint?.isActive = false
            self.portraitConstraint?.isActive = true
        } else {
            self.portraitConstraint?.isActive = false
            self.landscapeConstraint?.isActive = true
        }
    }
    
    // MARK: - Actions
    @objc
    private func handleTapCancel() {
        self.onTapCancel?()
    }
    
    @objc
    private func handleTapDone() {
        self.onTapDone?(calendarView.service)
    }
}

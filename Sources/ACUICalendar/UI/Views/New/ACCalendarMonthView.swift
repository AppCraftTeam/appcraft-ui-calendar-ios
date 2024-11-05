//
//  ACCalendarMonthView.swift
//
//
//  Created by Pavel Moslienko on 10.10.2024.
//

import DPSwift
import UIKit

public class ACCalendarMonthView: UIView {
    
    // MARK: - Props
    private var month: ACCalendarMonthModel
    private var theme = ACCalendarUITheme()
    private var showsOnlyCurrentDaysInMonth: Bool = true
    private var scrollDirection: UICollectionView.ScrollDirection
    private var monthHeader: ACMonthHeader?
    private let monthHeaderView = ACCalendarMonthHeaderView()
    private var dayLabels: [ACCalendarDayView] = []
    
    public static var headerHeight: CGFloat = 20
    public static var headerBottonInset: CGFloat = 0
    public static var rowHeight: CGFloat = 47.0
    public var parentSize: CGSize = .zero
    public var didSelectDates: ContextClosure<ACCalendarDayModel>?
    public var didGettingSelectingType: ((_ day: ACCalendarDayModel) -> ACCalendarDateSelectionType)?
    
    // MARK: - Init
    public init(month: ACCalendarMonthModel, theme: ACCalendarUITheme, showsOnlyCurrentDaysInMonth: Bool, scrollDirection: UICollectionView.ScrollDirection, parentSize: CGSize, monthHeader: ACMonthHeader?) {
        self.month = month
        self.theme = theme
        self.showsOnlyCurrentDaysInMonth = showsOnlyCurrentDaysInMonth
        self.parentSize = parentSize
        self.monthHeader = monthHeader
        self.scrollDirection = scrollDirection
        super.init(frame: .zero)
        
        setupComponents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    override public func layoutSubviews() {
        super.layoutSubviews()
    }
    
    public func setDaySelection() {
        dayLabels.forEach { dayLabel in
            guard let day = dayLabel.day else { return }
            dayLabel.daySelection = self.didGettingSelectingType?(day) ?? .notSelected
        }
    }
}

// MARK: - Setup Methods
private extension ACCalendarMonthView {
    
    func setupComponents() {
        self.backgroundColor = .clear
        setupMonthHeaderView()
        setupWeekViews()
    }
    
    func setupMonthHeaderView() {
        monthHeaderView.parentSize = parentSize
        addSubview(monthHeaderView)
        
        monthHeaderView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            monthHeaderView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            monthHeaderView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            monthHeaderView.topAnchor.constraint(equalTo: self.topAnchor),
            monthHeaderView.heightAnchor.constraint(equalToConstant:  self.scrollDirection == .vertical ? ACCalendarMonthView.headerHeight : 0.0)
        ])
        
        monthHeaderView.isHidden = scrollDirection == .horizontal
        
        if let monthHeader = monthHeader {
            monthHeaderView.theme = theme
            monthHeaderView.updateComponents(cfg: monthHeader, model: month)
        }
    }
    
    func setupWeekViews() {
        dayLabels.removeAll()
        let monthWeekDays = month.days.chunked(into: 7)
        let totalRowHeight = ACCalendarMonthView.rowHeight * CGFloat(monthWeekDays.count)
        let availableHeight: CGFloat = parentSize.height
        let remainingSpace = availableHeight - totalRowHeight
        let singlePadding = remainingSpace / CGFloat(monthWeekDays.count)
        print("parentSize - \(parentSize), remainingSpace \(remainingSpace), \(singlePadding), count \(monthWeekDays.count)")

        var previousWeekView: UIView = monthHeaderView
        
        monthWeekDays.enumerated().forEach { index, weekDays in
            let weekView = createWeekView()
            addSubview(weekView)
            
            let topPadding = getTopPadding(for: index, padding: singlePadding)
            NSLayoutConstraint.activate([
                weekView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                weekView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                weekView.topAnchor.constraint(equalTo: previousWeekView.bottomAnchor, constant: topPadding),
                weekView.heightAnchor.constraint(equalToConstant: ACCalendarMonthView.rowHeight)
            ])
            
            setupDayViews(in: weekView, days: weekDays)
            previousWeekView = weekView
        }
        
        NSLayoutConstraint.activate([
            previousWeekView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        self.layoutSubviews()
    }
    
    func createWeekView() -> UIView {
        let weekView = UIView()
        weekView.translatesAutoresizingMaskIntoConstraints = false
        
        return weekView
    }
    
    func getTopPadding(for index: Int, padding: CGFloat) -> CGFloat {
        guard scrollDirection == .horizontal else {
            return 0.0
        }
        
        return index == 0 ? 0 : padding
    }
    
    func setupDayViews(in weekView: UIView, days: [ACCalendarDayModel]) {
        var previousDayLabel: UIView? = nil
        
        days.forEach { day in
            let dayLabel = createDayLabel(for: day)
            weekView.addSubview(dayLabel)
            dayLabels.append(dayLabel)
            
            if let previousDayLabel = previousDayLabel {
                NSLayoutConstraint.activate([
                    dayLabel.leadingAnchor.constraint(equalTo: previousDayLabel.trailingAnchor),
                    dayLabel.widthAnchor.constraint(equalTo: previousDayLabel.widthAnchor)
                ])
            } else {
                NSLayoutConstraint.activate([
                    dayLabel.leadingAnchor.constraint(equalTo: weekView.leadingAnchor)
                ])
            }
            
            previousDayLabel = dayLabel
        }
        
        if let lastDayLabel = previousDayLabel {
            NSLayoutConstraint.activate([
                lastDayLabel.trailingAnchor.constraint(equalTo: weekView.trailingAnchor)
            ])
        }
    }
    
    func createDayLabel(for day: ACCalendarDayModel) -> ACCalendarDayView {
        let dayLabel = ACCalendarDayView()
        dayLabel.day = day
        dayLabel.dayIsHidden = showsOnlyCurrentDaysInMonth && day.belongsToMonth != .current
        dayLabel.daySelection = didGettingSelectingType?(day) ?? .notSelected
        dayLabel.theme = theme
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDayLabelTap(_:)))
        dayLabel.addGestureRecognizer(tapGesture)
        dayLabel.isUserInteractionEnabled = true
        
        dayLabel.translatesAutoresizingMaskIntoConstraints = false
        dayLabel.heightAnchor.constraint(equalToConstant: ACCalendarMonthView.rowHeight).isActive = true
        return dayLabel
    }
    
    @objc
    private func handleDayLabelTap(_ sender: UITapGestureRecognizer) {
        guard let dayLabel = sender.view as? ACCalendarDayView, let day = dayLabel.day else { return }
        didSelectDates?(day)
    }
}

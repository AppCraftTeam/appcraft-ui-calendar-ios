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
    var month: ACCalendarMonthModel
    var theme = ACCalendarUITheme()
    var showsOnlyCurrentDaysInMonth: Bool = true
    var monthHeader: ACMonthHeader?
    let monthHeaderView = ACCalendarMonthHeaderView()
    var dayLabels: [ACCalendarDayView] = []
    var headerHeight: CGFloat = 20
    var headerBottonInset: CGFloat = 0
    var rowHeight: CGFloat = 47.0
    public var parentSize: CGSize = .zero
    public var didSelectDates: ContextClosure<ACCalendarDayModel>?
    public var didGettingSelectingType: ((_ day: ACCalendarDayModel) -> ACCalendarDateSelectionType)?
    
    // MARK: - Init
    public init(month: ACCalendarMonthModel, theme: ACCalendarUITheme, showsOnlyCurrentDaysInMonth: Bool, parentSize: CGSize, monthHeader: ACMonthHeader?, headerHeight: Double = 20) {
        self.month = month
        self.theme = theme
        self.showsOnlyCurrentDaysInMonth = showsOnlyCurrentDaysInMonth
        self.parentSize = parentSize
        self.monthHeader = monthHeader
        self.headerHeight = headerHeight
        super.init(frame: .zero)
        
        setupComponents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func build(
        for scrollDirection: ACCalendarScrollDirection,
        month: ACCalendarMonthModel,
        theme: ACCalendarUITheme,
        showsOnlyCurrentDaysInMonth: Bool, 
        parentSize: CGSize,
        monthHeader: ACMonthHeader?,
        headerHeight: Double = 20
    ) -> ACCalendarMonthView {
        switch scrollDirection {
        case .horizontal:
            return ACCalendarMonthHorizontalView(
                month: month,
                theme: theme,
                showsOnlyCurrentDaysInMonth: showsOnlyCurrentDaysInMonth,
                parentSize: parentSize,
                monthHeader: monthHeader,
                headerHeight: headerHeight
            )
        case .vertical:
            return ACCalendarMonthVerticalView(
                month: month,
                theme: theme,
                showsOnlyCurrentDaysInMonth: showsOnlyCurrentDaysInMonth,
                parentSize: parentSize,
                monthHeader: monthHeader,
                headerHeight: headerHeight
            )
        }
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
    
    func getTopPadding(for index: Int, padding: CGFloat) -> CGFloat {
        0.0
    }
    
    func setupMonthHeaderView() {}
    
    func setupWeekViews() {}
}

// MARK: - Setup Methods
extension ACCalendarMonthView {
    
    func setupComponents() {
        self.backgroundColor = .clear
        setupMonthHeaderView()
        setupWeekViews()
    }
        
    func createWeekView() -> UIView {
        let weekView = UIView()
        weekView.translatesAutoresizingMaskIntoConstraints = false
        
        return weekView
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
        dayLabel.heightAnchor.constraint(equalToConstant: rowHeight).isActive = true
        return dayLabel
    }
    
    @objc
    private func handleDayLabelTap(_ sender: UITapGestureRecognizer) {
        guard let dayLabel = sender.view as? ACCalendarDayView, let day = dayLabel.day else { return }
        didSelectDates?(day)
    }
}

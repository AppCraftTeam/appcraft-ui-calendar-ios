//
//  ACCalendarMonthView.swift
//
//
//  Created by Pavel Moslienko on 10.10.2024.
//

import DPSwift
import UIKit

public class ACCalendarMonthView: UIView {
    
    private var month: ACCalendarMonthModel
    private var theme = ACCalendarUITheme()
    private var showsOnlyCurrentDaysInMonth: Bool = true
    private var scrollDirection: UICollectionView.ScrollDirection
    private var monthHeader: ACMonthHeader?
    private let monthHeaderView = ACCalendarMonthHeaderView()
    
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
        
        self.setupMonthView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
    }
    
    private func setupMonthView() {
        self.backgroundColor = .clear
        
        monthHeaderView.parentSize = self.parentSize
        addSubview(monthHeaderView)
        print("scrollDirection setupMonthView \(self.scrollDirection), \(self.scrollDirection == .horizontal)")
        monthHeaderView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            monthHeaderView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            monthHeaderView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            monthHeaderView.topAnchor.constraint(equalTo: self.topAnchor),
            monthHeaderView.heightAnchor.constraint(equalToConstant:  self.scrollDirection == .vertical ? ACCalendarMonthView.headerHeight : 0.0)
        ])
        monthHeaderView.isHidden = self.scrollDirection == .horizontal
        var previousWeekView: UIView = monthHeaderView
        
        let monthWeekDays = month.days.chunked(into: 7)
        
        let numberOfWeeks = CGFloat(6)
        let totalRowHeight = ACCalendarMonthView.rowHeight * numberOfWeeks
        let availableHeight: CGFloat = 474.0 //self.bounds.height
        
        let remainingSpace = availableHeight - totalRowHeight
        let single = remainingSpace / numberOfWeeks
        print("remainingSpace - \(remainingSpace), availableHeight - \(availableHeight), totalRowHeight - \(totalRowHeight), single - \(single)")
        
        
        monthWeekDays.enumerated().forEach { (index, rowWeekDates) in
            let weekView = UIView()
            addSubview(weekView)
            
            var topPadding: CGFloat {
                switch self.scrollDirection {
                case .vertical:
                    return 0.0
                case .horizontal:
                    return index == 0 ? 0 : (single / 1)
                @unknown default:
                    return 0.0
                }
            }
            
            weekView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                weekView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                weekView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                weekView.topAnchor.constraint(equalTo: previousWeekView.bottomAnchor, constant: topPadding),
                weekView.heightAnchor.constraint(equalToConstant: ACCalendarMonthView.rowHeight)
            ])
            
            var previousDayLabel: UIView? = nil
            
            rowWeekDates.forEach { day in
                let dayLabel = ACCalendarDayView()
                dayLabel.day = day
                
                if showsOnlyCurrentDaysInMonth {
                    dayLabel.dayIsHidden = day.belongsToMonth != .current
                } else {
                    dayLabel.dayIsHidden = false
                }
                print("dddd \(self.didGettingSelectingType == nil)")
                dayLabel.daySelection =  self.didGettingSelectingType?(day) ?? .notSelected
                dayLabel.theme = theme
                
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDayLabelTap(_:)))
                dayLabel.addGestureRecognizer(tapGesture)
                dayLabel.isUserInteractionEnabled = true
                
                weekView.addSubview(dayLabel)
                
                dayLabel.translatesAutoresizingMaskIntoConstraints = false
                dayLabel.heightAnchor.constraint(equalToConstant: ACCalendarMonthView.rowHeight).isActive = true
                
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
            
            previousWeekView = weekView
        }
        
        NSLayoutConstraint.activate([
            previousWeekView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        if let monthHeader = monthHeader {
            monthHeaderView.theme = self.theme
            monthHeaderView.updateComponents(cfg: monthHeader, model: month)
        }
        
        self.layoutSubviews()
    }
    
    @objc
    private func handleDayLabelTap(_ sender: UITapGestureRecognizer) {
        guard let dayLabel = sender.view as? ACCalendarDayView,
              let day = dayLabel.day
        else {
            return
        }
        print("didSelectDates... \(day)")
        didSelectDates?(day)
    }
    
}

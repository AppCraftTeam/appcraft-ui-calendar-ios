//
//  ACCalendarMonthHorizontalView.swift
//
//
//  Created by Pavel Moslienko on 06.11.2024.
//

import DPSwift
import UIKit

public class ACCalendarMonthHorizontalView: ACCalendarMonthView {

    override func getTopPadding(for index: Int, padding: CGFloat) -> CGFloat {
        index == 0 ? 0 : padding
    }
    
    override func setupMonthHeaderView() {
        monthHeaderView.parentSize = parentSize
        addSubview(monthHeaderView)
        
        monthHeaderView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            monthHeaderView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            monthHeaderView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            monthHeaderView.topAnchor.constraint(equalTo: self.topAnchor),
            monthHeaderView.heightAnchor.constraint(equalToConstant: 0.0)
        ])
        
        monthHeaderView.isHidden = true
        
        if let monthHeader = monthHeader {
            monthHeaderView.theme = theme
            monthHeaderView.updateComponents(cfg: monthHeader, model: month)
        }
    }
    
    override func setupWeekViews() {
        dayLabels.removeAll()
        let monthWeekDays = month.days.chunked(into: 7)
        let totalRowHeight = rowHeight * 7
        let availableHeight: CGFloat = parentSize.height
        let remainingSpace = availableHeight - totalRowHeight
        let singlePadding = remainingSpace / CGFloat(monthWeekDays.count)
        print("ACCalendarMonthHorizontalView parentSize - \(parentSize), remainingSpace \(remainingSpace), \(singlePadding), count \(monthWeekDays.count), totalRowHeight - \(totalRowHeight)")
        
        var previousWeekView: UIView = monthHeaderView
        
        monthWeekDays.enumerated().forEach { index, weekDays in
            let weekView = createWeekView()
            addSubview(weekView)
            
            let topPadding = getTopPadding(for: index, padding: singlePadding)
            NSLayoutConstraint.activate([
                weekView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                weekView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                weekView.topAnchor.constraint(equalTo: previousWeekView.bottomAnchor, constant: 0),
                weekView.heightAnchor.constraint(equalToConstant: parentSize.height / 7)
            ])
            
            setupDayViews(in: weekView, days: weekDays)
            previousWeekView = weekView
        }
        
        NSLayoutConstraint.activate([
            previousWeekView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        self.layoutSubviews()
    }
    
}

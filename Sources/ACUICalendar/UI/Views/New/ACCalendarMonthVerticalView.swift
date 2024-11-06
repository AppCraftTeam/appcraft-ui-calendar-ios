//
//  ACCalendarMonthVerticalView.swift
//  
//
//  Created by Pavel Moslienko on 06.11.2024.
//

import DPSwift
import UIKit

public class ACCalendarMonthVerticalView: ACCalendarMonthView {

    override func getTopPadding(for index: Int, padding: CGFloat) -> CGFloat {
        0.0
    }
    
    override func setupMonthHeaderView() {
        monthHeaderView.parentSize = parentSize
        addSubview(monthHeaderView)
        
        monthHeaderView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            monthHeaderView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            monthHeaderView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            monthHeaderView.topAnchor.constraint(equalTo: self.topAnchor),
            monthHeaderView.heightAnchor.constraint(equalToConstant: headerHeight)
        ])
        
        monthHeaderView.isHidden = false
        
        if let monthHeader = monthHeader {
            monthHeaderView.theme = theme
            monthHeaderView.updateComponents(cfg: monthHeader, model: month)
        }
    }
    
    override func setupWeekViews() {
        dayLabels.removeAll()
        let monthWeekDays = month.days.chunked(into: 7)
        let totalRowHeight = rowHeight * CGFloat(monthWeekDays.count)
        let availableHeight: CGFloat = parentSize.height
        let remainingSpace = availableHeight - totalRowHeight
        let singlePadding = remainingSpace / CGFloat(monthWeekDays.count)
        print("ACCalendarMonthVerticalView parentSize - \(parentSize), remainingSpace \(remainingSpace), \(singlePadding), count \(monthWeekDays.count), totalRowHeight - \(totalRowHeight)")
        
        var previousWeekView: UIView = monthHeaderView
        
        monthWeekDays.enumerated().forEach { index, weekDays in
            let weekView = createWeekView()
            addSubview(weekView)
            
            let topPadding = getTopPadding(for: index, padding: singlePadding)
            NSLayoutConstraint.activate([
                weekView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                weekView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                weekView.topAnchor.constraint(equalTo: previousWeekView.bottomAnchor, constant: topPadding),
                weekView.heightAnchor.constraint(equalToConstant: rowHeight)
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

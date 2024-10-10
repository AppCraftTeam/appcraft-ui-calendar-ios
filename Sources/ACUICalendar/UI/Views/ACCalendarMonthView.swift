//
//  ACCalendarMonthView.swift
//
//
//  Created by Pavel Moslienko on 10.10.2024.
//

import UIKit

class ACCalendarMonthView: UIView {
    
    private var dateInfos: (Int, Int)
    
    init(dateInfos: (Int, Int)) {
        self.dateInfos = dateInfos
        super.init(frame: .zero)
        setupMonthView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupMonthView() {
        print("setupMonthView - \(dateInfos)")
        self.backgroundColor = .orange
        let monthLabel = UILabel()
        monthLabel.text = "\(Calendar.current.monthSymbols[dateInfos.1 - 1]) \(dateInfos.0)"
        monthLabel.textAlignment = .center
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.addArrangedSubview(monthLabel)
        
        for week in daysInMonth() {
            let weekStackView = UIStackView()
            weekStackView.axis = .horizontal
            weekStackView.spacing = 5
            weekStackView.distribution = .fillEqually
            
            for day in week {
                #warning("temp")
                let dayLabel = ACCalendarDayView()
                dayLabel.day = ACCalendarDayModel(
                    day: day,
                    dayDate: Date(),
                    dayDateText: String(day),
                    belongsToMonth: .current
                )
                dayLabel.backgroundColor = .blue
                dayLabel.frame.size = CGSize(width: 40, height: 40)
                weekStackView.addArrangedSubview(dayLabel)
            }
            stackView.addArrangedSubview(weekStackView)
        }
        
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: self.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    private func daysInMonth() -> [[Int]] {
        let calendar = Calendar.current
        let dateComponents = DateComponents(year: dateInfos.0, month: dateInfos.1)
        guard let date = calendar.date(from: dateComponents),
              let rangeOfDaysInMonth = calendar.range(of: .day, in: .month, for: date) else {
            return []
        }
        
        var daysArray = Array(rangeOfDaysInMonth)
        var daysInMonth: [[Int]] = []
        
        while !daysArray.isEmpty {
            let week = Array(daysArray.prefix(7))
            daysInMonth.append(week)
            daysArray.removeFirst(week.count)
        }
        
        return daysInMonth
    }
}

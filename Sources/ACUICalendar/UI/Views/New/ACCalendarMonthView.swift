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
    private var monthHeader: ACMonthHeader?
    
    public var didSelectDates: ContextClosure<ACCalendarDayModel>?
    
    // MARK: - Init
    public init(month: ACCalendarMonthModel, theme: ACCalendarUITheme, showsOnlyCurrentDaysInMonth: Bool, monthHeader: ACMonthHeader?) {
        self.month = month
        self.theme = theme
        self.showsOnlyCurrentDaysInMonth = showsOnlyCurrentDaysInMonth
        self.monthHeader = monthHeader
        super.init(frame: .zero)
        
        self.setupMonthView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupMonthView() {
        print("setupMonthView - \(month.month), \(month.monthDates.first), week - \(month.weeksCount), dats \(month.totalDays.count)")
        
        self.backgroundColor = .clear
        
        let monthHeaderView = ACCalendarMonthHeaderView()
        if let monthHeader = monthHeader {
            monthHeaderView.updateComponents(cfg: monthHeader, model: month)
            monthHeaderView.backgroundColor = .red
        }
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.addArrangedSubview(monthHeaderView)
        
        let days = month.days
        print("setupMonthView - days \(days)")
        
        for i in month.weeks {
            let weekStackView = UIStackView()
            weekStackView.axis = .horizontal
            weekStackView.spacing = 5
            weekStackView.distribution = .fillEqually
            
            for j in 0..<7 {
                let day = (i + j < month.days.count) ? month.days[i + j] : nil
                let dayLabel = ACCalendarDayView()
                
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDayLabelTap(_:)))
                dayLabel.addGestureRecognizer(tapGesture)
                dayLabel.isUserInteractionEnabled = true
                dayLabel.tag = i + j
                
                if day != nil {
                    dayLabel.day = day
                    dayLabel.backgroundColor = .blue.withAlphaComponent(0.5)
                } else {
                    dayLabel.backgroundColor = .black
                }
                dayLabel.frame.size = CGSize(width: 40, height: 40)
                weekStackView.addArrangedSubview(dayLabel)
            }
            
            stackView.addArrangedSubview(weekStackView)
        }
        
        addSubview(stackView)
        NSLayoutConstraint.activate([
            monthHeaderView.heightAnchor.constraint(equalToConstant: 44),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: self.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    @objc
    private func handleDayLabelTap(_ sender: UITapGestureRecognizer) {
        guard let dayLabel = sender.view as? ACCalendarDayView else {
            return
        }
        
        let dayIndex = dayLabel.tag
        let day = month.days[dayIndex]
        print("didSelectDates... \(day.dayDate)")
        didSelectDates?(day)
    }
    
}

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
    
    public static var headerHeight: CGFloat = 47
    public static var headerBottonInset: CGFloat = 10
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
        self.backgroundColor = .clear
        
        let monthHeaderView = ACCalendarMonthHeaderView()
        if let monthHeader = monthHeader {
            monthHeaderView.updateComponents(cfg: monthHeader, model: month)
            monthHeaderView.backgroundColor = .red
        }
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = ACCalendarMonthView.headerBottonInset
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.addArrangedSubview(monthHeaderView)
                
        let monthWeekDays = month.days.chunked(into: 7)
        
        monthWeekDays.forEach({ rowWeekDates in
            let weekStackView = UIStackView()
            weekStackView.axis = .horizontal
            weekStackView.spacing = 0
            weekStackView.distribution = .fillEqually
            weekStackView.translatesAutoresizingMaskIntoConstraints = false
            
            rowWeekDates.forEach({ day in
                let dayLabel = ACCalendarDayView()
                
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDayLabelTap(_:)))
                dayLabel.addGestureRecognizer(tapGesture)
                dayLabel.isUserInteractionEnabled = true
                //dayLabel.tag = i + j
                
                dayLabel.day = day
                dayLabel.backgroundColor = .blue.withAlphaComponent(0.5)
                
                let width = self.bounds.width / 7
                
                dayLabel.translatesAutoresizingMaskIntoConstraints = false
                dayLabel.heightAnchor.constraint(equalToConstant: 47).isActive = true
                weekStackView.addArrangedSubview(dayLabel)
            })
            
            weekStackView.heightAnchor.constraint(equalToConstant: 47).isActive = true
            stackView.addArrangedSubview(weekStackView)
        })
        
        addSubview(stackView)
        NSLayoutConstraint.activate([
            monthHeaderView.heightAnchor.constraint(equalToConstant: ACCalendarMonthView.headerHeight),
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

//
//  ACCalendarWeekView.swift
//  ACUICalendarDemo
//
//  Created by Дмитрий Поляков on 25.08.2022.
//

import Foundation
import UIKit
import DPSwift

open class ACCalendarWeekView: UIView {
    
    // MARK: - Init
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupComponents()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.setupComponents()
    }
    
    // MARK: - Props
    open lazy var stackView: UIStackView = {
        let result = UIStackView()
        result.axis = .horizontal
        result.distribution = .fillEqually
        
        return result
    }()
    
    open var service: ACCalendarService = .default() {
        didSet { self.updateComponents() }
    }
    
    open var theme = ACCalendarUITheme() {
        didSet { self.updateComponents() }
    }
    
    // MARK: - Methods
    open func setupComponents() {
        self.stackView.removeFromSuperview()
        self.stackView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(self.stackView)
        
        NSLayoutConstraint.activate([
            self.stackView.topAnchor.constraint(equalTo: self.topAnchor),
            self.stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
        
        self.updateComponents()
    }
    
    open func updateComponents() {
        let calendar = self.service.calendar
        let locale = self.service.locale
        let weekDays = calendar.firstDPWeekDay.generateWeek()
        
        let views: [UIView] = weekDays.map { weekDay in
            let text = weekDay
                .toLocalString(with: .eee, calendar: calendar, locale: locale)?
                .uppercased()
            
            let label = UILabel()
            label.text = text
            label.textAlignment = .center
            label.textColor = self.theme.weekDayTextColor
            label.font = self.theme.weekDayFont
            
            return label
        }
        
        self.stackView.arrangedSubviews.forEach({ $0.removeFromSuperview() })
        views.forEach({ self.stackView.addArrangedSubview($0) })
    }
    
}

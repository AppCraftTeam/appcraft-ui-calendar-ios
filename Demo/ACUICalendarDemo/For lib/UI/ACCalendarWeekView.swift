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
    public init(calendar: Calendar, locale: Locale) {
        super.init(frame: .zero)
        
        self.calendar = calendar
        self.locale = locale
        
        self.updateComponents()
    }
    
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
    
    open var calendar: Calendar = .defaultACCalendar() {
        didSet { self.updateComponents() }
    }
    
    open var locale: Locale = .current {
        didSet { self.updateComponents() }
    }
    
    open var textColor: UIColor = .black {
        didSet { self.updateComponents() }
    }
    
    open var textAlignment: NSTextAlignment = .center {
        didSet { self.updateComponents() }
    }
    
    open var font: UIFont = .systemFont(ofSize: 14) {
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
        let weekDays = self.calendar.firstDPWeekDay.generateWeek()
        
        let views: [UIView] = weekDays.map { weekDay in
            let text = weekDay
                .toLocalString(with: .eee, calendar: self.calendar, locale: self.locale)?
                .uppercased()
            
            let label = UILabel()
            label.text = text
            label.textColor = self.textColor
            label.textAlignment = self.textAlignment
            label.font = self.font
            
            return label
        }
        
        self.stackView.arrangedSubviews.forEach({ $0.removeFromSuperview() })
        views.forEach({ self.stackView.addArrangedSubview($0) })
    }
    
}

//
//  ACCalendarWeekView.swift
//  ACUICalendarDemo
//
//  Created by Дмитрий Поляков on 25.08.2022.
//

import Foundation
import UIKit

open class ACCalendarWeekView: UIView {
    
    // MARK: - Init
    public init(calendar: Calendar) {
        super.init(frame: .zero)
        
        self.calendar = calendar
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
    }
    
    open func updateComponents() {
        self.stackView.arrangedSubviews.forEach({ $0.removeFromSuperview() })
    }
    
}

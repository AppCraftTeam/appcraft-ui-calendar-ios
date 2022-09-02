//
//  ACCalendarView.swift
//  ACUICalendarDemo
//
//  Created by Дмитрий Поляков on 25.08.2022.
//

import Foundation
import UIKit

open class ACCalendarView: UIView {
    
    // MARK: - Init
    init(service: ACCalendarService = .default()) {
        self.service = service
        
        super.init(frame: .zero)
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
    open lazy var contentView = UIView()
    open lazy var topContentView = UIView()
    open lazy var bottomContentView = UIView()
    
    open lazy var monthSelectView: ACCalendarMonthSelectView = {
        let result = ACCalendarMonthSelectView()
        
        result.didToggle = { [weak self] isOn in
            self?.updateComponents()
        }
        
        return result
    }()
    
    open lazy var arrowsView: ACCalendarArrowsView = {
        let result = ACCalendarArrowsView(service: self.service, theme: self.theme)
        
        result.didTapLeftArrow = { [weak self] in
            self?.dayCollectionView.scrollToPreviousMonth(animated: true)
        }
        
        result.didTapRightArrow = { [weak self] in
            self?.dayCollectionView.scrollToNextMonth(animated: true)
        }
        
        return result
    }()
    
    open lazy var weekView = ACCalendarWeekView()
    
    open lazy var dayCollectionView: ACCalendarDayCollectionView = {
        let result = ACCalendarDayCollectionView(service: self.service, theme: self.theme)
        
        result.didScrollToMonth = { [weak self] monthDate in
            self?.service.currentMonthDate = monthDate
        }
        
        result.didSelectDates = { [weak self] dates in
            self?.service.datesSelection.datesSelected = dates
        }
        
        return result
    }()
    
    open lazy var monthPickerView: ACCalendarMonthPickerView = {
        let result = ACCalendarMonthPickerView()
        
        result.didSelectMonth = { [weak self] monthDate in
            self?.service.currentMonthDate = monthDate
        }
        
        return result
    }()
    
    open var contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: -16, trailing: -16) {
        didSet { self.setupContentView() }
    }
    
    open var service: ACCalendarService = .default() {
        didSet { self.updateComponents() }
    }
    
    open var theme = ACCalendarUITheme() {
        didSet { self.updateComponents() }
    }
    
    // MARK: - Methods
    open func setupComponents() {
        self.setupContentView()
        
        [
            self.topContentView,
            self.bottomContentView,
            self.monthSelectView,
            self.arrowsView,
            self.weekView,
            self.dayCollectionView,
            self.monthPickerView
        ].forEach({
            $0.removeFromSuperview()
            $0.translatesAutoresizingMaskIntoConstraints = false
        })
        
        self.contentView.addSubview(self.topContentView)
        self.contentView.addSubview(self.bottomContentView)
        
        self.topContentView.addSubview(self.monthSelectView)
        self.topContentView.addSubview(self.arrowsView)
        
        self.bottomContentView.addSubview(self.weekView)
        self.bottomContentView.addSubview(self.dayCollectionView)
        self.bottomContentView.addSubview(self.monthPickerView)
        
        NSLayoutConstraint.activate([
            self.topContentView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.topContentView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            self.topContentView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            self.topContentView.heightAnchor.constraint(equalToConstant: 40),
            
            self.bottomContentView.topAnchor.constraint(equalTo: self.topContentView.bottomAnchor, constant: 16),
            self.bottomContentView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            self.bottomContentView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            self.bottomContentView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            
            self.monthSelectView.leadingAnchor.constraint(equalTo: self.topContentView.leadingAnchor),
            self.monthSelectView.centerYAnchor.constraint(equalTo: self.topContentView.centerYAnchor),
            
            self.arrowsView.trailingAnchor.constraint(equalTo: self.topContentView.trailingAnchor),
            self.arrowsView.centerYAnchor.constraint(equalTo: self.topContentView.centerYAnchor),
            
            self.weekView.topAnchor.constraint(equalTo: self.bottomContentView.topAnchor),
            self.weekView.leadingAnchor.constraint(equalTo: self.bottomContentView.leadingAnchor),
            self.weekView.trailingAnchor.constraint(equalTo: self.bottomContentView.trailingAnchor),
            self.weekView.heightAnchor.constraint(equalToConstant: 24),
            
            self.dayCollectionView.topAnchor.constraint(equalTo: self.weekView.bottomAnchor, constant: 16),
            self.dayCollectionView.bottomAnchor.constraint(equalTo: self.bottomContentView.bottomAnchor),
            self.dayCollectionView.leadingAnchor.constraint(equalTo: self.bottomContentView.leadingAnchor),
            self.dayCollectionView.trailingAnchor.constraint(equalTo: self.bottomContentView.trailingAnchor),

            self.monthPickerView.topAnchor.constraint(equalTo: self.bottomContentView.topAnchor),
            self.monthPickerView.bottomAnchor.constraint(equalTo: self.bottomContentView.bottomAnchor),
            self.monthPickerView.leadingAnchor.constraint(equalTo: self.bottomContentView.leadingAnchor),
            self.monthPickerView.trailingAnchor.constraint(equalTo: self.bottomContentView.trailingAnchor)
        ])

        self.updateComponents()
    }
    
    open func setupContentView() {
        self.contentView.removeFromSuperview()
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.contentView)
        
        let insets = self.contentInsets
        
        NSLayoutConstraint.activate([
            self.contentView.topAnchor.constraint(equalTo: self.topAnchor, constant: insets.top),
            self.contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: insets.bottom),
            self.contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: insets.leading),
            self.contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: insets.trailing)
        ])
    }
    
    open func updateComponents() {
        self.backgroundColor = self.theme.backgroundColor
        
        self.monthSelectView.service = self.service
        self.dayCollectionView.theme = self.theme
        
        self.arrowsView.service = self.service
        self.arrowsView.theme = self.theme
        
        self.monthPickerView.service = self.service
        self.monthPickerView.theme = self.theme
        
        self.dayCollectionView.service = self.service
        self.dayCollectionView.theme = self.theme
        
        self.arrowsView.isHidden = self.monthSelectView.isOn
        self.dayCollectionView.isHidden = self.monthSelectView.isOn
        self.weekView.isHidden = self.monthSelectView.isOn
        self.monthPickerView.isHidden = !self.monthSelectView.isOn
    }
    
}



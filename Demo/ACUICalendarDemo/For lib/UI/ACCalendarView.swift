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
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupComponents()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.setupComponents()
    }
    
    // MARK: - Props
    
    open lazy var stackContentView: UIStackView = {
        let result = UIStackView(arrangedSubviews: [
            self.monthSelectContainerView,
            self.weekView,
            self.monthCollectionView
        ])
        result.axis = .vertical
        result.spacing = 16
        
        return result
    }()
    
    open lazy var monthSelectContainerView = UIView()
    
    open lazy var monthSelectView: ACCalendarMonthSelectView = {
        let result = ACCalendarMonthSelectView()
        result.didTap = { [weak self] state in
        }
        
        return result
    }()
    
    open lazy var arrowsView: ACCalendarArrowsView = {
        let result = ACCalendarArrowsView()
        
        result.didTapLeftArrow = { [weak self] in
            
        }
        
        result.didTapRightArrow = { [weak self] in
            
        }
        
        return result
    }()
    
    open lazy var weekView = ACCalendarWeekView()
    
    open lazy var monthCollectionView: ACCalendarMonthCollectionView = {
        let result = ACCalendarMonthCollectionView()
        
        return result
    }()
    
    open var stackContentInsets = NSDirectionalEdgeInsets(top: 100, leading: 16, bottom: -16, trailing: -16) {
        didSet { self.setupStackContentView() }
    }
    
    open var currentMonth = Date() {
        didSet {
            self.monthSelectView.monthDate = self.currentMonth
        }
    }
    
    // MARK: - Methods
    open func setupComponents() {
        self.setupStackContentView()
        
        self.monthSelectContainerView.translatesAutoresizingMaskIntoConstraints = false
        self.weekView.translatesAutoresizingMaskIntoConstraints = false
        
        self.monthSelectView.removeFromSuperview()
        self.monthSelectView.translatesAutoresizingMaskIntoConstraints = false
        
        self.arrowsView.removeFromSuperview()
        self.arrowsView.translatesAutoresizingMaskIntoConstraints = false
        
        self.monthSelectContainerView.addSubview(self.monthSelectView)
        self.monthSelectContainerView.addSubview(self.arrowsView)
        
        NSLayoutConstraint.activate([
            self.monthSelectContainerView.heightAnchor.constraint(equalToConstant: 40),
            self.weekView.heightAnchor.constraint(equalToConstant: 24),
            
            self.monthSelectView.leadingAnchor.constraint(equalTo: self.monthSelectContainerView.leadingAnchor),
            self.monthSelectView.centerYAnchor.constraint(equalTo: self.monthSelectContainerView.centerYAnchor),
            
            self.arrowsView.trailingAnchor.constraint(equalTo: self.monthSelectContainerView.trailingAnchor),
            self.arrowsView.centerYAnchor.constraint(equalTo: self.monthSelectContainerView.centerYAnchor)
        ])
    }
    
    open func setupStackContentView() {
        self.stackContentView.removeFromSuperview()
        self.stackContentView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.stackContentView)
        
        let insets = self.stackContentInsets
        
        NSLayoutConstraint.activate([
            self.stackContentView.topAnchor.constraint(equalTo: self.topAnchor, constant: insets.top),
            self.stackContentView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: insets.bottom),
            self.stackContentView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: insets.leading),
            self.stackContentView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: insets.trailing)
        ])
    }
    
}



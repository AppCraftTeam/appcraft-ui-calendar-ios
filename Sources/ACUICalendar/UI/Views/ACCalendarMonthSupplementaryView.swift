//
//  ACCalendarMonthSupplementaryView.swift
//  
//
//  Created by Damian on 11.09.2023.
//

import UIKit

open class ACCalendarMonthSupplementaryView: UICollectionReusableView {
    
    // MARK: Components
    open lazy var label = UILabel()
    
    private var labelLeadingConstraint: NSLayoutConstraint?
    
    // MARK: Properties
    open class var identifer: String {
        "ACCalendarMonthSupplementaryView"
    }
    
    open override var reuseIdentifier: String? {
        "ACCalendarMonthSupplementaryView"
    }
    
    // MARK: - Initialization
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupComponents()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup methods
    open func setupComponents() {
        self.label.textColor = .black
        self.addSubview(label)
        self.label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        self.labelLeadingConstraint = label.leadingAnchor.constraint(equalTo: leadingAnchor)
        self.labelLeadingConstraint?.isActive = true
        
    }
    
    open func updateComponents(
        cfg: ACMonthHeader,
        model: ACCalendarMonthModel
    ) {
        let monthText = getMonthName(
            from: model.monthDate,
            with: cfg.format
        ).capitalized
        
        self.label.text = monthText
        self.label.font = cfg.style.font
        self.label.textColor = cfg.style.textColor
        
        switch cfg.horizonalPosition {
        case .center:
            self.label.textAlignment = .center
        case .left:
            self.label.textAlignment = .left
        case .right:
            self.label.textAlignment = .right
        case let .custom(val):
            self.labelLeadingConstraint?.constant = val
            self.layoutIfNeeded()
        case .offsetFromPassDays:
            guard let superview else { return }
            let width = superview.frame.width / 7
            let widthString = label.intrinsicContentSize.width
            let leftInset = width * Double(model.previousMonthDates.count) 
            
            if self.frame.width - leftInset > widthString {
                self.labelLeadingConstraint?.constant = leftInset
            } else {
                self.labelLeadingConstraint?.constant = self.frame.width - widthString
            }
            self.layoutIfNeeded()
        }
    }
    
    private func getMonthName(
        from date: Date,
        with format: String
    ) -> String  {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }
}

//
//  ACCalendarMonthPickerView.swift
//  ACUICalendarDemo
//
//  Created by Дмитрий Поляков on 30.08.2022.
//

import Foundation
import UIKit

open class ACCalendarMonthPickerView: UIView {
    
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
    open lazy var picker: UIPickerView = {
        let result = UIPickerView()
        result.dataSource = self
        result.delegate = self
        
        return result
    }()
    
    open var service: ACCalendarService = .default() {
        didSet { self.updateComponents() }
    }
    
    open var theme = ACCalendarUITheme() {
        didSet { self.updateComponents() }
    }
    
    open var years: [ACCalendarYearModel] = []
    
    // MARK: - Methods
    open func setupComponents() {
//        if #available(iOS 13.4, *) {
//            self.preferredDatePickerStyle = .wheels
//        }
//
//        self.datePickerMode = .date
        self.picker.removeFromSuperview()
        self.picker.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(self.picker)
        
        NSLayoutConstraint.activate([
            self.picker.topAnchor.constraint(equalTo: self.topAnchor),
            self.picker.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.picker.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.picker.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
        
        self.updateComponents()
    }
    
    open func updateComponents() {
//        self.minimumDate = self.service.minDate
//        self.maximumDate = self.service.maxDate
//        self.date = self.service.currentMonthDate
//        self.locale = self.service.locale
//        self.calendar = self.service.calendar
        self.years = self.service.generateYears()
        self.picker.reloadAllComponents()
    }
    
}

// MARK: - PickerComponent
public extension ACCalendarMonthPickerView {
    
    enum PickerComponentType: Int, CaseIterable {
        case month = 1
        case year = 0
    }
    
}

// MARK: - UIPickerViewDataSource
extension ACCalendarMonthPickerView: UIPickerViewDataSource {
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        PickerComponentType.allCases.count
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        guard let type = PickerComponentType(rawValue: component) else { return 0 }
        
        switch type {
        case .month:
            let yearComponent = PickerComponentType.year.rawValue
            let yearIndex = pickerView.selectedRow(inComponent: yearComponent)
            return self.years.element(at: yearIndex)?.months.count ?? 0
        case .year:
            return self.years.count
        }
    }
    
}

// MARK: - UIPickerViewDelegate
extension ACCalendarMonthPickerView: UIPickerViewDelegate {
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard let type = PickerComponentType(rawValue: component) else { return nil }
        
        switch type {
        case .month:
            let yearComponent = PickerComponentType.year.rawValue
            let yearIndex = pickerView.selectedRow(inComponent: yearComponent)
            let monthDate = self.years.element(at: yearIndex)?.months.element(at: row)?.monthDate
            let monthText = monthDate?.toLocalString(withFormatType: .montLetters, locale: self.service.locale)
            return monthText
        case .year:
            let yearDate = self.years.element(at: row)?.yearDate
            let yearText = yearDate?.toLocalString(withFormatType: .year, locale: self.service.locale)
            return yearText
        }
    }
    
}

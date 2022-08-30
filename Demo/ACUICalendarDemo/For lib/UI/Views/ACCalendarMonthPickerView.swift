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

    open var years: [ACCalendarYearModel] {
        self.service.years
    }

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
//        self.years = self.service.generateYears()
        self.picker.reloadAllComponents()
        
        
        guard let yearIndex = self.service.years.firstIndex(where: { $0.yearDate.isEqual(to: self.currentMonthDate, toGranularity: .year, calendar: self.service.calendar) }),
        let monthIndex = self.service.years.element(at: yearIndex)?.months.firstIndex(where: { $0.monthDate.isEqual(to: self.currentMonthDate, toGranularity: .month, calendar: self.service.calendar) })
                
        else { return }
        
        self.picker.selectRow(monthIndex, inComponent: 0, animated: true)
        self.picker.selectRow(yearIndex, inComponent: 1, animated: true)

//        self.service.calendar.maximumRange(of: <#T##Calendar.Component#>)
//        let year = self.service.years.first(where: { $0.yearDate.isEqual(to: self.currentMonthDate, toGranularity: .year, calendar: self.service.calendar) }) ?? 0
//        self.picker.selectRow(<#T##row: Int##Int#>, inComponent: <#T##Int#>, animated: <#T##Bool#>)
    }

//    var currentYear: ACCalendarYearModel? {
//        let index = self.picker.selectedRow(inComponent: PickerComponentType.year.rawValue)
//        let result = self.service.years.element(at: index)
//
//        return result
//    }
    
//    var currentYearDate: Date? {
//        self.service.currentMonthDate
//    }
    
    var currentMonthDate: Date {
        get { self.service.currentMonthDate }
        set { self.service.currentMonthDate = newValue }
    }
    
    public func yearIndex() -> Int? {
        self.service.years.firstIndex { year in
            year.year == self.service.calendar.component(.year, from: self.currentMonthDate)
        }
    }
    
    public func year() -> ACCalendarYearModel? {
        guard let index = self.yearIndex() else { return nil }
        let year = self.service.years.element(at: index)
        
        return year
    }
    
    public func monthsCount() -> Int? {
        self.year()?.months.count
    }

}

// MARK: - PickerComponent
public extension ACCalendarMonthPickerView {

    enum PickerComponentType: Int, CaseIterable {
        case month = 0
        case year = 1
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
            let yearIndex = self.service.years.firstIndex(where: { $0.yearDate.isEqual(to: self.currentMonthDate, toGranularity: .year, calendar: self.service.calendar) }) ?? 0
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
            let yearIndex = self.service.years.firstIndex(where: { $0.yearDate.isEqual(to: self.currentMonthDate, toGranularity: .year, calendar: self.service.calendar) }) ?? 0
            
            let monthDate = self.years.element(at: yearIndex)?.months.element(at: row)?.monthDate
            let monthText = monthDate?.toLocalString(withFormatType: .montLetters, locale: self.service.locale)
            return monthText
        case .year:
            let yearDate = self.years.element(at: row)?.yearDate
            let yearText = yearDate?.toLocalString(withFormatType: .year, locale: self.service.locale)
            return yearText
        }
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        
        let monthIndex = pickerView.selectedRow(inComponent: 0)
        let yearIndex = pickerView.selectedRow(inComponent: 1)
        
        guard
            let year = self.service.years.element(at: yearIndex),
            let month = year.months.first(where: { self.service.calendar.component(.month, from: $0.monthDate) == self.service.calendar.component(.month, from: self.currentMonthDate) }) ?? year.months.first
        else { return }
        
        self.currentMonthDate = month.monthDate
        
        if component == 1 {
            self.picker.reloadComponent(0)
        }
    }

}

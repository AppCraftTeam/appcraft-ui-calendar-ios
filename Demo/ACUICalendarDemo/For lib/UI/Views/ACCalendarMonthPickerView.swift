//
//  ACCalendarMonthPickerView.swift
//  ACUICalendarDemo
//
//  Created by Дмитрий Поляков on 30.08.2022.
//

import Foundation
import UIKit
import DPSwift

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
    open lazy var pickerView: UIPickerView = {
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
    
    open var currentYear: ACCalendarYearModel?
    
    open var years: [ACCalendarYearModel] {
        self.service.years
    }
    
    open var months: [ACCalendarMonthModel] {
        self.currentYear?.months ?? []
    }
    
    open var didSelectMonth: ContextClosure<Date>?

    // MARK: - Methods
    open func setupComponents() {
        self.pickerView.removeFromSuperview()
        self.pickerView.translatesAutoresizingMaskIntoConstraints = false

        self.addSubview(self.pickerView)

        NSLayoutConstraint.activate([
            self.pickerView.topAnchor.constraint(equalTo: self.topAnchor),
            self.pickerView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.pickerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.pickerView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])

        self.updateComponents()
    }

    open func updateComponents() {
        let calendar = self.service.calendar
        let currentYear = calendar.component(.year, from: self.service.currentMonthDate)
        let currentMonth = calendar.component(.month, from: self.service.currentMonthDate)
        
        self.currentYear = self.years.first(where: { $0.year == currentYear })
        self.pickerView.reloadAllComponents()
        
        if let yearRow = self.years.firstIndex(where: { $0.year == currentYear }) {
            self.selectRow(yearRow, inComponentType: .year, animated: true)
        }
        
        if let monthRow = self.months.firstIndex(where: { $0.month == currentMonth }) {
            self.selectRow(monthRow, inComponentType: .month, animated: true)
        }
    }
    
    open func selectedRow(inComponentType type: PickerComponentType) -> Int {
        self.pickerView.selectedRow(inComponent: type.rawValue)
    }
    
    open func selectRow(_ row: Int, inComponentType type: PickerComponentType, animated: Bool) {
        self.pickerView.selectRow(row, inComponent: type.rawValue, animated: animated)
    }
    
    open func reloadComponent(withType type: PickerComponentType) {
        self.pickerView.reloadComponent(type.rawValue)
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
            return self.months.count
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
            let monthDate = self.months.element(at: row)?.monthDate
            let monthText = monthDate?.toLocalString(withFormatType: .montLetters, locale: self.service.locale)
            return monthText
        case .year:
            let yearDate = self.years.element(at: row)?.yearDate
            let yearText = yearDate?.toLocalString(withFormatType: .year, locale: self.service.locale)
            return yearText
        }
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard let type = PickerComponentType(rawValue: component) else { return }
        
        switch type {
        case .year:
            let selectedMonthRow = pickerView.selectedRow(inComponent: PickerComponentType.month.rawValue)
            let selectedMonth = self.months.element(at: selectedMonthRow)?.month
            
            self.currentYear = self.years.element(at: row)
            self.reloadComponent(withType: .month)
            
            if let row = self.months.firstIndex(where: { $0.month == selectedMonth }) {
                self.selectRow(row, inComponentType: .month, animated: true)
            }
        case .month:
            break
        }
        
        guard let monthDate = self.years.element(at: self.selectedRow(inComponentType: .year))?.months.element(at: self.selectedRow(inComponentType: .month))?.monthDate else { return }
        self.service.currentMonthDate = monthDate
        self.didSelectMonth?(monthDate)
    }

}

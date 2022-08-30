//
//  ACCalendarMonthPickerView.swift
//  ACUICalendarDemo
//
//  Created by Дмитрий Поляков on 30.08.2022.
//

import Foundation
import UIKit

//open class MonthYearPickerView: UIControl {
//
//    /// specify min date. default is nil. When `minimumDate` > `maximumDate`, the values are ignored.
//    /// If `date` is earlier than `minimumDate` when it is set, `date` is changed to `minimumDate`.
//    open var minimumDate: Date? = nil {
//        didSet {
//            guard let minimumDate = minimumDate, calendar.compare(minimumDate, to: date, toGranularity: .month) == .orderedDescending else { return }
//            date = minimumDate
//        }
//    }
//
//    /// specify max date. default is nil. When `minimumDate` > `maximumDate`, the values are ignored.
//    /// If `date` is later than `maximumDate` when it is set, `date` is changed to `maximumDate`.
//    open var maximumDate: Date? = nil {
//        didSet {
//            guard let maximumDate = maximumDate, calendar.compare(date, to: maximumDate, toGranularity: .month) == .orderedDescending else { return }
//            date = maximumDate
//        }
//    }
//
//    /// default is current date when picker created
//    open var date: Date = Date() {
//        didSet {
//            if let minimumDate = minimumDate, calendar.compare(minimumDate, to: date, toGranularity: .month) == .orderedDescending {
//                date = calendar.date(from: calendar.dateComponents([.year, .month], from: minimumDate)) ?? minimumDate
//            } else if let maximumDate = maximumDate, calendar.compare(date, to: maximumDate, toGranularity: .month) == .orderedDescending {
//                date = calendar.date(from: calendar.dateComponents([.year, .month], from: maximumDate)) ?? maximumDate
//            }
//            setDate(date, animated: true)
//            sendActions(for: .valueChanged)
//        }
//    }
//
//    /// default is current calendar when picker created
//    open var calendar: Calendar = Calendar.autoupdatingCurrent {
//        didSet {
//            monthDateFormatter.calendar = calendar
//            monthDateFormatter.timeZone = calendar.timeZone
//            yearDateFormatter.calendar = calendar
//            yearDateFormatter.timeZone = calendar.timeZone
//        }
//    }
//
//    /// default is nil
//    open var locale: Locale? {
//        didSet {
//            calendar.locale = locale
//            monthDateFormatter.locale = locale
//            yearDateFormatter.locale = locale
//        }
//    }
//
//    lazy private var pickerView: UIPickerView = {
//        let pickerView = UIPickerView(frame: self.bounds)
//        pickerView.dataSource = self
//        pickerView.delegate = self
//        pickerView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        return pickerView
//    }()
//
//    lazy private var monthDateFormatter: DateFormatter = {
//        let formatter = DateFormatter()
//        formatter.setLocalizedDateFormatFromTemplate("MMMM")
//        return formatter
//    }()
//
//    lazy private var yearDateFormatter: DateFormatter = {
//        let formatter = DateFormatter()
//        formatter.setLocalizedDateFormatFromTemplate("y")
//        return formatter
//    }()
//
//    fileprivate enum Component: Int {
//        case month
//        case year
//    }
//
//    override public init(frame: CGRect) {
//        super.init(frame: frame)
//        initialSetup()
//    }
//
//    required public init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        initialSetup()
//    }
//
//    private func initialSetup() {
//        addSubview(pickerView)
//        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
//        setDate(date, animated: false)
//    }
//
//    /// if animated is YES, animate the wheels of time to display the new date
//    open func setDate(_ date: Date, animated: Bool) {
//        guard let yearRange = calendar.maximumRange(of: .year), let monthRange = calendar.maximumRange(of: .month) else {
//            return
//        }
//        let month = calendar.component(.month, from: date) - monthRange.lowerBound
//        pickerView.selectRow(month, inComponent: .month, animated: animated)
//        let year = calendar.component(.year, from: date) - yearRange.lowerBound
//        pickerView.selectRow(year, inComponent: .year, animated: animated)
//        pickerView.reloadAllComponents()
//    }
//
//    internal func isValidDate(_ date: Date) -> Bool {
//        if let minimumDate = minimumDate,
//            let maximumDate = maximumDate, calendar.compare(minimumDate, to: maximumDate, toGranularity: .month) == .orderedDescending { return true }
//        if let minimumDate = minimumDate, calendar.compare(minimumDate, to: date, toGranularity: .month) == .orderedDescending { return false }
//        if let maximumDate = maximumDate, calendar.compare(date, to: maximumDate, toGranularity: .month) == .orderedDescending { return false }
//        return true
//    }
//
//}
//
//extension MonthYearPickerView: UIPickerViewDelegate {
//
//    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        var dateComponents = calendar.dateComponents([.hour, .minute, .second], from: date)
//        dateComponents.year = value(for: pickerView.selectedRow(inComponent: .year), representing: .year)
//        dateComponents.month = value(for: pickerView.selectedRow(inComponent: .month), representing: .month)
//        guard let date = calendar.date(from: dateComponents) else { return }
//        self.date = date
//    }
//
//}
//
//extension MonthYearPickerView: UIPickerViewDataSource {
//
//    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        return 2
//    }
//
//    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        guard let component = Component(rawValue: component) else { return 0 }
//        switch component {
//        case .month:
//            return calendar.maximumRange(of: .month)?.count ?? 0
//        case .year:
//            return calendar.maximumRange(of: .year)?.count ?? 0
//        }
//    }
//
//    private func value(for row: Int, representing component: Calendar.Component) -> Int? {
//        guard let range = calendar.maximumRange(of: component) else { return nil }
//        return range.lowerBound + row
//    }
//
//    public func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
//        let label: UILabel = view as? UILabel ?? {
//            let label = UILabel()
//            if #available(iOS 10.0, *) {
//                label.font = .preferredFont(forTextStyle: .title2, compatibleWith: traitCollection)
//                label.adjustsFontForContentSizeCategory = true
//            } else {
//                label.font = .preferredFont(forTextStyle: .title2)
//            }
//            label.textAlignment = .center
//            return label
//        }()
//
//        guard let component = Component(rawValue: component) else { return label }
//        var dateComponents = calendar.dateComponents([.hour, .minute, .second], from: date)
//
//        switch component {
//            case .month:
//                dateComponents.month = value(for: row, representing: .month)
//                dateComponents.year = value(for: pickerView.selectedRow(inComponent: .year), representing: .year)
//            case .year:
//                dateComponents.month = value(for: pickerView.selectedRow(inComponent: .month), representing: .month)
//                dateComponents.year = value(for: row, representing: .year)
//        }
//
//        guard let date = calendar.date(from: dateComponents) else { return label }
//
//        switch component {
//            case .month:
//                label.text = monthDateFormatter.string(from: date)
//            case .year:
//                label.text = yearDateFormatter.string(from: date)
//        }
//
//        if #available(iOS 13.0, *) {
//            label.textColor = isValidDate(date) ? .label : .secondaryLabel
//        } else {
//            label.textColor = isValidDate(date) ? .black : .lightGray
//        }
//
//        return label
//    }
//}
//
//private extension UIPickerView {
//    func selectedRow(inComponent component: MonthYearPickerView.Component) -> Int {
//        selectedRow(inComponent: component.rawValue)
//    }
//
//    func selectRow(_ row: Int, inComponent component: MonthYearPickerView.Component, animated: Bool) {
//        selectRow(row, inComponent: component.rawValue, animated: animated)
//    }
//}


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
        self.years = self.service.generateYears()
        self.picker.reloadAllComponents()

//        self.service.calendar.maximumRange(of: <#T##Calendar.Component#>)
    }

    var currentYear: ACCalendarYearModel? {
        let index = self.picker.selectedRow(inComponent: PickerComponentType.year.rawValue)
        let result = self.service.years.element(at: index)

        return result
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

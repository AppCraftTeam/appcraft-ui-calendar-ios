//
//  CalendarMonthCollectionView.swift
//  ACUICalendarDemo
//
//  Created by Дмитрий Поляков on 24.08.2022.
//

import Foundation
import UIKit

open class CalendarMonthCollectionView: UIView {
    
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
    lazy var collectionViewLayout: UICollectionViewLayout = ACUICalendarHorizontalLayout()
    
    lazy var collectionView: UICollectionView = {
        let result = UICollectionView(frame: .zero, collectionViewLayout: self.collectionViewLayout)
        result.showsVerticalScrollIndicator = false
        result.showsHorizontalScrollIndicator = false
        result.contentInsetAdjustmentBehavior = .never
        result.isPagingEnabled = true
        result.register(CalendarDayCell.self, forCellWithReuseIdentifier: CalendarDayCell.identifer)
        result.dataSource = self
        
        result.allowsMultipleSelection = true
        
        return result
    }()
    
    open var service: CalendarService = .init(settings: .default())
    
    public private(set) var months: [CalendarMonthModel] = []
    
    func setupComponents() {
        self.collectionView.removeFromSuperview()
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(self.collectionView)
        
        NSLayoutConstraint.activate([
            self.collectionView.topAnchor.constraint(equalTo: self.topAnchor),
            self.collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
        
        self.months = self.service.generateMonths()
        self.collectionView.reloadData()

        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(10)) { [weak self] in
            self?.scrollToMonth(.init())
        }
    }
    
    open func scrollToMonth(_ monthDate: Date) {
        func isEqual1(_ month: CalendarMonthModel) -> Bool {
            self.service.calendar.compare(monthDate, to: month.monthDate, toGranularity: .month) == .orderedSame
        }
        
        guard let index = self.months.firstIndex(where: { isEqual1($0) }) else { return }
        self.collectionView.scrollToItem(at: .init(item: 0, section: index), at: .left, animated: false)
    }
    
    var selectedDates: [Date] = []
    
}

// MARK: - UICollectionViewDataSource
extension CalendarMonthCollectionView: UICollectionViewDataSource {
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        self.months.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard self.months.indices.contains(section) else { return 0 }
        return self.months[section].allDates.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CalendarDayCell.identifer, for: indexPath) as? CalendarDayCell
        else { return .init() }
        
        let date = self.months[indexPath.section].allDates[indexPath.row]
        
        var calendar = Calendar.current
        calendar.firstWeekday = 2
        let day = calendar.component(.day, from: date)
        
        cell.dayLabel.text = day.description
        cell.isSelected = self.selectedDates.contains(where: { self.service.calendar.compare($0, to: date, toGranularity: .day) == .orderedSame })
        
        return cell
    }
    
}

extension CalendarMonthCollectionView: UICollectionViewDelegate {
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.reloadData()
    }
    
}

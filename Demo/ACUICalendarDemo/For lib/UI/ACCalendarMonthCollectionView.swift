//
//  ACCalendarMonthCollectionView.swift
//  ACUICalendarDemo
//
//  Created by Дмитрий Поляков on 24.08.2022.
//

import Foundation
import UIKit

open class ACCalendarMonthCollectionView: UIView {
    
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
    open lazy var collectionViewLayout: UICollectionViewLayout = ACCalendarHorizontalLayout()
    
    open lazy var collectionView: UICollectionView = {
        let result = UICollectionView(frame: .zero, collectionViewLayout: self.collectionViewLayout)
        result.showsVerticalScrollIndicator = false
        result.showsHorizontalScrollIndicator = false
        result.contentInsetAdjustmentBehavior = .never
        result.isPagingEnabled = true
        result.register(ACCalendarDayCollectionViewCell.self, forCellWithReuseIdentifier: ACCalendarDayCollectionViewCell.identifer)
        result.dataSource = self
        
        result.allowsMultipleSelection = true
        
        return result
    }()
    
    open var service: ACCalendarService = ACCalendarService(settings: .default())
    open var months: [ACCalendarMonthModel] = []
    
    // MARK: - Methods
    open func setupComponents() {
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
        func isEqual1(_ month: ACCalendarMonthModel) -> Bool {
            self.service.calendar.compare(monthDate, to: month.monthDate, toGranularity: .month) == .orderedSame
        }
        
        guard let index = self.months.firstIndex(where: { isEqual1($0) }) else { return }
        self.collectionView.scrollToItem(at: .init(item: 0, section: index), at: .left, animated: false)
    }
    
    var selectedDates: [Date] = []
    
}

// MARK: - UICollectionViewDataSource
extension ACCalendarMonthCollectionView: UICollectionViewDataSource {
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        self.months.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard self.months.indices.contains(section) else { return 0 }
        
        return self.months[section].days.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard self.months.indices.contains(indexPath.section) else { return .init() }
        let days = self.months[indexPath.section].days
        
        guard days.indices.contains(indexPath.item) else { return .init() }
        let day = days[indexPath.item]
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ACCalendarDayCollectionViewCell.identifer, for: indexPath) as? ACCalendarDayCollectionViewCell else { return .init() }
        
        cell.day = day
        return cell
    }
    
}

// MARK: - ACCalendarService
extension ACCalendarMonthCollectionView: UICollectionViewDelegate {
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        collectionView.reloadData()
    }
    
}

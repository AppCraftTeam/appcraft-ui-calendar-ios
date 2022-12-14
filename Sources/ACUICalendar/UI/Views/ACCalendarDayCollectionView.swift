//
//  ACCalendarDayCollectionView.swift
//  ACUICalendarDemo
//
//  Created by Дмитрий Поляков on 24.08.2022.
//

import Foundation
import UIKit
import DPSwift

open class ACCalendarDayCollectionView: ACCalendarBaseView {
    
    // MARK: - Props
    open lazy var collectionViewLayout: UICollectionViewLayout = ACCalendarHorizontalLayout()
    
    open lazy var collectionView: UICollectionView = {
        let result = UICollectionView(frame: .zero, collectionViewLayout: self.collectionViewLayout)
        result.backgroundColor = .clear
        result.showsVerticalScrollIndicator = false
        result.showsHorizontalScrollIndicator = false
        result.contentInsetAdjustmentBehavior = .never
        result.isPagingEnabled = true
        result.register(ACCalendarDayCollectionViewCell.self, forCellWithReuseIdentifier: ACCalendarDayCollectionViewCell.identifer)
        result.dataSource = self
        result.delegate = self
        
        return result
    }()
    
    open var months: [ACCalendarMonthModel] {
        self.service.months
    }
    
    open var didScrollToMonth: ContextClosure<Date>?
    open var didSelectDates: ContextClosure<[Date]>?
    
    // MARK: - Methods
    open override func setupComponents() {
        self.collectionView.removeFromSuperview()
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(self.collectionView)
        
        NSLayoutConstraint.activate([
            self.collectionView.topAnchor.constraint(equalTo: self.topAnchor),
            self.collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
        
        self.updateComponents()
    }
    
    open override func updateComponents() {
        self.collectionView.reloadData()

        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(10)) { [weak self] in
            guard let date = self?.service.currentMonthDate else { return }
            self?.scrollToMonth(with: date, animated: false)
        }
    }
    
    open func scrollToMonth(with monthDate: Date, animated: Bool) {
        func isEqual(_ month: ACCalendarMonthModel) -> Bool {
            self.service.calendar.compare(monthDate, to: month.monthDate, toGranularity: .month) == .orderedSame
        }
        
        guard let index = self.months.firstIndex(where: { isEqual($0) }) else { return }
        self.collectionView.scrollToItem(at: .init(item: 0, section: index), at: .left, animated: animated)
    }
    
    open func scrollToMonth(on direction: ACCalendarDirection, animated: Bool) {
        guard let monthDate = self.service.month(on: direction) else { return }
        self.scrollToMonth(with: monthDate, animated: animated)
    }
    
    open func handleScrolling() {
        let page = self.collectionView.contentOffset.x / self.frame.width
        
        guard let monthDate = self.months.element(at: Int(page))?.monthDate else { return }
        self.service.currentMonthDate = monthDate
        self.didScrollToMonth?(monthDate)
    }
    
}

// MARK: - UICollectionViewDataSource
extension ACCalendarDayCollectionView: UICollectionViewDataSource {
    
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
        cell.daySelection = self.service.daySelected(day)
        cell.theme = self.theme
        return cell
    }
    
}

// MARK: - ACCalendarService
extension ACCalendarDayCollectionView: UICollectionViewDelegate {
    
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        self.handleScrolling()
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.handleScrolling()
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let day = self.months.element(at: indexPath.section)?.days.element(at: indexPath.item) else { return }
        self.service.daySelect(day)
        self.didSelectDates?(self.service.datesSelected)
    }
    
}

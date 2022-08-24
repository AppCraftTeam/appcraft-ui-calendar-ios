//
//  CalendarMonthView.swift
//  ACUICalendarDemo
//
//  Created by Дмитрий Поляков on 24.08.2022.
//

import Foundation
import UIKit

open class CalendarMonthView: UIView {
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupComponents()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.setupComponents()
    }
    
    lazy var collectionViewLayout: UICollectionViewLayout = ACUICalendarHorizontalLayout()
    
    lazy var collectionView: UICollectionView = {
        let result = UICollectionView(frame: .zero, collectionViewLayout: self.collectionViewLayout)
        result.showsVerticalScrollIndicator = false
        result.showsHorizontalScrollIndicator = false
        result.contentInsetAdjustmentBehavior = .never
        result.isPagingEnabled = true
        result.register(CalendarDayCell.self, forCellWithReuseIdentifier: CalendarDayCell.identifer)
        result.dataSource = self
        result.delegate = self
        result.prefetchDataSource = self
        result.isPrefetchingEnabled = true
        return result
    }()
    
    open var service: CalendarService = .init(settings: .default())
//    var lastContentOffsetX: CGFloat = 0
    
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
        
//        let initialDate = Date()
//        guard let initialMonth = self.service.getMonth(initialDate) else { return }
//        self.months += [initialMonth]
//        self.collectionView.reloadData()
//
//        self.appendPreviousMonths()
////        self.appendNextMonths()
//
//        self.scrollToMonth(initialMonth.monthDate)
        self.months = self.service.generateAllMonths()
        self.collectionView.reloadData()
        
//        self.scrollToMonth(.init())
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1000)) { [weak self] in
            self?.scrollToMonth(.init())
        }
    }
    
    open func scrollToMonth(_ monthDate: Date) {
        func isEqual1(_ month: CalendarMonthModel) -> Bool {
            self.service.calendar.compare(monthDate, to: month.monthDate, toGranularity: .month) == .orderedSame
        }
        
        guard let index = self.months.firstIndex(where: { isEqual1($0) }) else { return }
        self.collectionView.scrollToItem(at: .init(item: 0, section: index), at: .left, animated: true)
    }
    
}

// MARK: - UICollectionViewDataSource
extension CalendarMonthView: UICollectionViewDataSource {
    
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
        
        return cell
    }
    
}

// MARK: - UICollectionViewDelegate
extension CalendarMonthView: UICollectionViewDelegate {
    
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        print("!!!", endMonthIndex, indexPath.section)
//
//        if indexPath.section > self.endMonthIndex - 5 {
//            print("!!! appendNext")
//            self.appendNextMonths()
//        }
//        print("!!!", indexPath.section, months.count, months.count - indexPath.section, months.count - indexPath.section < 5)
//
//        if months.count - indexPath.section < 5 {
//            print("!!! append")
//            self.appendNextMonths()
//        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        print("!!! didEndDisplaying", indexPath.section)
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        print("!!!", scrollView.contentOffset.x)
//        let contentOffsetX = scrollView.contentOffset.x
//
//        if contentOffsetX >= self.lastContentOffsetX {
//            let pages = collectionView.numberOfSections
//            let pageWidth = collectionView.frame.width
//            let contentWidht = CGFloat(pages) * pageWidth
//            let coporision = (contentWidht - contentOffsetX) / pageWidth
//
//            print("!!! to next", contentOffsetX, contentWidht, coporision)
//
//            if coporision < 5 {
//                self.appendNextMonths()
//            }
//        } else {
//            print("!!! to previos")
//        }
//
//        self.lastContentOffsetX = contentOffsetX
    }
    
}

extension CalendarMonthView: UICollectionViewDataSourcePrefetching {
    
    public func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
//        print("!!!", indexPaths.max()?.section)
        
//        if let min = indexPaths.min()?.section {
//            print("!!!", min, min <= 5)
//            self.appendPreviousMonths()
//        }
//
//        if let max = indexPaths.max()?.section {
//            print("!!!", max, months.count, months.count - max)
//            if months.count - max <= 5 {
////                self.appendNextMonths()
//            }
//        }
        
    }
    
}

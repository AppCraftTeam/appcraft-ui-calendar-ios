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
    open var showsOnlyCurrentDaysInMonth = false {
        didSet { collectionView.reloadData() }
    }
    
    open var monthHeader: ACMonthHeader? = .init(
        style: .default,
        horizonalPosition: .offsetFromPassDays
    )
    private lazy var pageProvider: ACPageProvider = ACVerticalPageProvider()
    public private(set) lazy var collectionViewLayout: UICollectionViewFlowLayout = ACCalendarVerticalLayout()
    
    open lazy var collectionView: UICollectionView = {
        let result = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        result.backgroundColor = .clear
        result.showsVerticalScrollIndicator = false
        result.showsHorizontalScrollIndicator = false
        result.contentInsetAdjustmentBehavior = .never
        result.register(
            ACCalendarMonthSupplementaryView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: ACCalendarMonthSupplementaryView.identifer
        )
        result.register(
            ACCalendarDayCollectionViewCell.self,
            forCellWithReuseIdentifier: ACCalendarDayCollectionViewCell.identifer
        )
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
        self.setupPageProvider()
        self.updateComponents()
    }
    
    open override func updateComponents() {
        self.collectionView.reloadData()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(10)) { [weak self] in
            guard let date = self?.service.currentMonthDate else { return }
            self?.scrollToMonth(with: date, animated: false)
        }
    }
    
    open func setCollectionViewLayout(
        _ layout: UICollectionViewFlowLayout,
        animated: Bool,
        completion: ((Bool) -> Void)? = nil
    )  {
        self.collectionViewLayout = layout
        self.collectionView.setCollectionViewLayout(layout, animated: animated, completion: completion)
        
        self.setPageProvider(for: layout)
    }
    
    open func setPageProvider(for layout: UICollectionViewFlowLayout) {
        let provider = getPageProvider(for: layout)
        self.setPageProvider(provider)
    }
    
    open func setPageProvider(_ provider: ACPageProvider) {
        self.pageProvider = provider
        self.setupPageProvider()
    }
    
    open func getPageProvider(for layout: UICollectionViewFlowLayout) -> ACPageProvider {
        switch layout {
        case is ACCalendarVerticalLayout:
            return ACVerticalPageProvider()
        default:
            return ACHorizontalPageProvider()
        }
    }
    
    private func setupPageProvider() {
        self.pageProvider.onChangePage = { [weak self] page in
            guard let self else { return }
            guard let monthDate = self.months.element(at: page)?.monthDate else {
                return
            }
            self.service.currentMonthDate = monthDate
            self.didScrollToMonth?(monthDate)
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
}

// MARK: - UICollectionViewDataSource
extension ACCalendarDayCollectionView: UICollectionViewDataSource {
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        months.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard months.indices.contains(section) else { return 0 }
        return months[section].days.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard months.indices.contains(indexPath.section) else { return .init() }
        let days = self.months[indexPath.section].days
        
        guard days.indices.contains(indexPath.item) else { return .init() }
        
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ACCalendarDayCollectionViewCell.identifer,
            for: indexPath
        ) as? ACCalendarDayCollectionViewCell
        else {
            return .init()
        }
        
        let day = days[indexPath.item]
        
        cell.day = day
        
        if showsOnlyCurrentDaysInMonth {
            cell.dayIsHidden = day.belongsToMonth != .current ? true : false
        } else {
            cell.dayIsHidden = false
        }
        
        cell.daySelection = service.daySelected(day)
        cell.theme = self.theme
        return cell
    }
}

// MARK: - ACCalendarService
extension ACCalendarDayCollectionView: UICollectionViewDelegateFlowLayout {
    public func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            guard let view = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: ACCalendarMonthSupplementaryView.identifer,
                for: indexPath
            ) as? ACCalendarMonthSupplementaryView else {
                return UICollectionReusableView()
            }
            return view
        }
        return .init()
    }
    
    public func collectionView(
        _ collectionView: UICollectionView,
        willDisplaySupplementaryView view: UICollectionReusableView,
        forElementKind elementKind: String,
        at indexPath: IndexPath
    ) {
        guard elementKind == UICollectionView.elementKindSectionHeader, let monthHeader else { return  }
        
        if let view = view as? ACCalendarMonthSupplementaryView {
            let month = months[indexPath.section]
            view.updateComponents(cfg: monthHeader, model: month)
        }
    }
    
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        self.pageProvider.scrollViewDidEndDecelerating(scrollView)
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.pageProvider.scrollViewDidScroll(scrollView)
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.pageProvider.scrollViewDidEndScrollingAnimation(scrollView)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let day = self.months.element(at: indexPath.section)?.days.element(at: indexPath.item) else { return }
        self.service.daySelect(day)
        self.didSelectDates?(self.service.datesSelected)
    }
}

//
//  ACCalendarDayCollectionView.swift
//  ACUICalendarDemo
//
//  Created by Дмитрий Поляков on 24.08.2022.
//

import UIKit
import DPSwift
import Foundation

open class ACCalendarDayCollectionView: ACCalendarBaseView {
    
    // MARK: Props
    var canInsertSections = true
    var isLandscapeOrientation = UIDevice.current.orientation.isLandscape
    
    open var showsOnlyCurrentDaysInMonth = false {
        didSet { collectionView.reloadData() }
    }
    
    open var monthHeader: ACMonthHeader? = .init(
        horizonalPosition: .offsetFromPassDays
    )
    
    private var insertionRules: (any ACDateInsertRules)?
    private lazy var pageProvider: ACPageProvider = ACVerticalPageProvider()
    private var isAnimationBusy = false
    
    public private(set) lazy var collectionViewLayout: ACCalendarLayout = ACCalendarVerticalLayout()
    
    open lazy var collectionView: UICollectionView = {
        let collectionView = ACCalendarCollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    open var months: [ACCalendarMonthModel] {
        self.service.months
    }
    
    open var didSelectDates: ContextClosure<[Date]>?
    open var didScrollToMonth: ContextClosure<Date>?
    
    open var itemHeight: Double {
        get {
            self.collectionViewLayout.itemHeight
        }
        set {
            self.collectionViewLayout.itemHeight = newValue
        }
    }
    
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
        self.backgroundColor = self.theme.backgroundColor
        
        self.collectionView.reloadData()
        self.collectionView.backgroundColor = self.theme.backgroundColor
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(10)) { [weak self] in
            guard let date = self?.service.currentMonthDate else { return }
            self?.scrollToMonth(with: date, animated: false)
        }
    }
    
    open func setCollectionViewLayout(
        _ configurator: any ACCalendarCollectionViewLayoutConfigurator,
        animated: Bool,
        completion: ((Bool) -> Void)? = nil
    ) {
        self.setPageProvider(configurator.makePageProvider())
        self.collectionViewLayout = configurator.makeLayout()
        
        self.collectionView.setCollectionViewLayout(
            collectionViewLayout,
            animated: animated,
            completion: completion
        )
        
        self.insertionRules = configurator.makeInsertionRules()
    }
    
    open func setPageProvider(_ provider: ACPageProvider) {
        self.pageProvider = provider
        self.setupPageProvider()
    }
    
    private func setupPageProvider() {
        self.pageProvider.onChangePage = { [weak self] page in
            guard let self else { return }
            guard let monthDate = self.months.element(at: page)?.monthDate else {
                return
            }
            print("page - \(page), monthDate - \(monthDate), \(self.service.currentMonthDate)")
            if !self.isAnimationBusy {
                self.service.currentMonthDate = monthDate
                self.didScrollToMonth?(monthDate)
            }
        }
    }
    
    open func scrollToMonth(with monthDate: Date, animated: Bool) {
        func isEqual(_ month: ACCalendarMonthModel) -> Bool {
            self.service.calendar.compare(monthDate, to: month.monthDate, toGranularity: .month) == .orderedSame
        }
        
        guard let index = months.firstIndex(where: { isEqual($0) }),
              service.currentMonthDate != monthDate else {
            return
        }

        let position: UICollectionView.ScrollPosition = {
            collectionViewLayout.scrollDirection == .vertical ? .top : .left
        }()
        
        self.isAnimationBusy = true
        self.collectionView.scrollToItemWithCompletion(
            at: IndexPath(item: 0, section: index),
            position: position,
            animated: true
        ) {
            self.isAnimationBusy = false
        }
    }
    
    open func scrollToMonth(on direction: ACCalendarDirection, animated: Bool) {
        guard let monthDate = self.service.month(on: direction) else { return }
        self.scrollToMonth(with: monthDate, animated: animated)
    }
    
    // MARK: - Lifecycle methods
    open override func layoutSubviews() {
        super.layoutSubviews()
        print("layoutSubviews ACCalendarDayCollectionView")
        self.checkOrientationChange()
    }
        
    // MARK: - Data insertion methods
    func insertPastMonths() {
        print("canInsertSections insertPastMonths- \(canInsertSections), all \(self.service.months.count)")
        guard self.canInsertSections else { return }
        print("insertPastMonths")
        self.canInsertSections.toggle()
        self.service.asyncGeneratePastDates(count: 12) { [weak self] months in
            guard let self else { return }
            if !months.isEmpty {
                UIView.performWithoutAnimation {
                    self.collectionView.insertSectionsAndKeepOffset(.init(months.indices.reversed()))
                }

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                    print("zzzzzz ")
                    self.limitMonthDataAfterScrollToTop(for: self.service.currentMonthDate)
                    self.canInsertSections = true
                })
            }
        }
    }
    
    // scroll to past
    func limitMonthDataAfterScrollToTop(for currentMonthDate: Date) {
        print("limitMonthDataAfterScrollToTop for \(currentMonthDate)")
        let calendar = Calendar.current
        
        guard let startDate = calendar.date(byAdding: .month, value: -12, to: currentMonthDate),
              let endDate = calendar.date(byAdding: .month, value: 12, to: currentMonthDate) else {
            return
        }
        print("limitMonthDataAfterScrollToTop startDate - \(startDate), endDate - \(endDate)")

        var sectionsToDelete = IndexSet()
        
        self.service.months.enumerated().forEach { (index, monthModel) in
            if monthModel.monthDate < startDate || monthModel.monthDate > endDate {
                sectionsToDelete.insert(index)
            }
        }
        print("limitMonthDataAfterScrollToTop sectionsToDelete \(sectionsToDelete)")

        let updatedMonths = months.enumerated().filter { (index, monthModel) in
            !sectionsToDelete.contains(index)
        }.map { $0.element }
        
        print("limitMonthDataAfterScrollToTop updatedMonths \(updatedMonths.map({ $0.monthDate }))")
        
        self.service.pastMonthGenerator.months.clear()
        Array(updatedMonths.prefix(12)).forEach({
            self.service.pastMonthGenerator.months.append($0)
        })
        
        self.service.futureMonthGenerator.months.clear()
        Array(updatedMonths.suffix(12)).forEach({
            self.service.futureMonthGenerator.months.append($0)
        })
                
        collectionView.reloadData()
    }
    
    // scroll to future
    func limitMonthDataAfterScrollToBottom(for currentMonthDate: Date) {
        print("limitMonthDataAfterScrollToBottom for \(currentMonthDate)")
        let calendar = Calendar.current
        
        guard let startDate = calendar.date(byAdding: .month, value: -12, to: currentMonthDate),
              let endDate = calendar.date(byAdding: .month, value: 12, to: currentMonthDate) else {
            return
        }
        print("limitMonthDataAfterScrollToBottom startDate - \(startDate), endDate - \(endDate)")

        var sectionsToDelete = IndexSet()
        
        self.service.months.enumerated().forEach { (index, monthModel) in
            if monthModel.monthDate < startDate || monthModel.monthDate > endDate {
                sectionsToDelete.insert(index)
            }
        }
        print("limitMonthDataAfterScrollToBottom sectionsToDelete \(sectionsToDelete)")

        let updatedMonths = months.enumerated().filter { (index, monthModel) in
            !sectionsToDelete.contains(index)
        }.map { $0.element }
        
        print("limitMonthDataAfterScrollToBottom updatedMonths \(updatedMonths.map({ $0.monthDate }))")
        
        self.service.pastMonthGenerator.months.clear()
        Array(updatedMonths.prefix(12)).forEach({
            self.service.pastMonthGenerator.months.append($0)
        })
        
        self.service.futureMonthGenerator.months.clear()
        Array(updatedMonths.suffix(12)).forEach({
            self.service.futureMonthGenerator.months.append($0)
        })
                
        collectionView.reloadData()
    }

    func deleteSectionsSafely(sectionsToDelete: IndexSet) {
        let numberOfSections = collectionView.numberOfSections
        print("deleteSectionsSafely sectionsToDelete \(sectionsToDelete), all - \(numberOfSections)")

        let validSections = sectionsToDelete.filter { $0 < numberOfSections }
        let validIndexSet = IndexSet(validSections)

        if !validIndexSet.isEmpty {
            collectionView.performBatchUpdates {
                collectionView.deleteSections(validIndexSet)
            } completion: { finished in
                print("Sections \(sectionsToDelete) deleted successfully")
            }
        } else {
            print("No valid sections to delete \(sectionsToDelete)")
        }
    }

    func insertFutureMonths() {
        var isAllowFetchNewMonth: Bool {
            guard let lastMonth = service.months.last?.monthDate else {
                return true
            }
            
            return service.currentMonthDate.yearsToDate(endDate: lastMonth) <= 2
        }
        print("isAllowFetchNewMonth - \(isAllowFetchNewMonth),last \(service.months.last?.monthDate), or \(service.pastMonthGenerator.months.last?.monthDate) and \(service.futureMonthGenerator.months.last?.monthDate)")
        guard isAllowFetchNewMonth,
              canInsertSections else { return }
        self.canInsertSections = false
        self.service.asyncGenerateFeatureDates(count: 12) { [weak self] monts in
            print("isAllowFetchNewMonth -new monts - \(monts.first?.monthDate) to \(monts.last?.monthDate)")
            guard let self else { return }
            if !self.months.isEmpty {
                CATransaction.begin()
                CATransaction.setCompletionBlock { [weak self] in
                    guard let self else { return }

                    //self.limitMonthDataAfterScrollToBottom(for: self.service.currentMonthDate)
                    self.canInsertSections.toggle()
                }
                self.collectionView.reloadData()
                self.limitMonthDataAfterScrollToBottom(for: self.service.currentMonthDate)
                CATransaction.commit()
            } else {
                self.canInsertSections.toggle()
            }
        }
    }
    
    // MARK: - Orientation methods
    open func checkOrientationChange() {
        if isLandscapeOrientation != UIDevice.current.orientation.isLandscape {
            self.isLandscapeOrientation = UIDevice.current.orientation.isLandscape
            self.updateFlowLayoutAfterChangingOrientation()
        }
    }
    
    open func updateFlowLayoutAfterChangingOrientation() {
        self.collectionViewLayout.isLandscapeOrientation = isLandscapeOrientation
        self.scrollToMonth(with: service.currentMonthDate, animated: false)
    }
}

// MARK: - UICollectionViewDataSource
extension ACCalendarDayCollectionView: UICollectionViewDataSource {
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        print("months.count - \(months.count)")
        print("months.count - \(months.first?.monthDate) and \(months.last?.monthDate)")
        print("months.counts - \(months.map({ $0.monthDate }))")

        return months.count
    }
    
    public func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        guard months.indices.contains(section) else { return 0 }
        return months[section].days.count
    }
    
    public func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard months.indices.contains(indexPath.section) else {
            return UICollectionViewCell()
        }

        let days = months[indexPath.section].days
        
        guard days.indices.contains(indexPath.item) else {
            return collectionView.dequeueReusableCell(
                withReuseIdentifier: ACCalendarDayCollectionViewCell.identifer,
                for: indexPath
            )
        }

        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ACCalendarDayCollectionViewCell.identifer,
            for: indexPath
        ) as? ACCalendarDayCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let day = days[indexPath.item]
        
        cell.day = day
        
        if showsOnlyCurrentDaysInMonth {
            cell.dayIsHidden = day.belongsToMonth != .current
        } else {
            cell.dayIsHidden = false
        }
        
        cell.daySelection = service.daySelected(day)
        cell.theme = theme
        cell.updateComponents()
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout methods
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
            view.theme = theme
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
        
        if insertionRules?.needsInsertFutureDates(scrollView) ?? false {
            self.insertFutureMonths()
        } else if insertionRules?.needsInsertPastDates(scrollView) ?? false {
            self.insertPastMonths()
        }
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.pageProvider.scrollViewDidEndScrollingAnimation(scrollView)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let day = months.element(at: indexPath.section)?.days.element(at: indexPath.item) else { return }
        self.service.daySelect(day)
        self.didSelectDates?(self.service.datesSelected)
        self.collectionView.reloadSections(IndexSet(integer: indexPath.section))
    }
}

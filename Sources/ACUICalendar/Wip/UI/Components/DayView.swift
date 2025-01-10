//
//  DayView.swift
//  ACUICalendar
//

import UIKit

open class DayView: UIView {
    
    private let viewModel: ViewModel
    
    public lazy var dayLabel: UILabel = {
        let result = UILabel()
        result.textAlignment = .center
        return result
    }()
    
    public lazy var daySelectionView: UIView = {
        let result = UIView()
        result.layer.cornerRadius = 20
        return result
    }()
    
    private init(viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setupComponents()
    }
    
    required public init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        let edgeInsets = viewModel.theme.dayEdgeInsets
        let insetBounds = bounds.inset(
            by: UIEdgeInsets(
                top: edgeInsets.top,
                left: edgeInsets.left,
                bottom: edgeInsets.bottom,
                right: edgeInsets.right)
        )
        
        dayLabel.frame = CGRect(
            x: edgeInsets.left,
            y: edgeInsets.top,
            width: insetBounds.width,
            height: insetBounds.height)
        
        daySelectionView.frame = self.bounds
    }
    
    private func setupComponents() {
        self.addSubview(daySelectionView)
        self.addSubview(dayLabel)
        self.isUserInteractionEnabled = viewModel.isEnabled
    }
    
    private func updateComponents(_ content: Content) {
        updateTheme()
        dayLabel.text = content.dayText
    }
    
    private func updateTheme() {
        daySelectionView.backgroundColor = viewModel.isSelected ? viewModel.theme.dayMiddleAtRangeBackgroundColor : viewModel.theme.dayNotSelectedBackgroundColor
        
        dayLabel.font = viewModel.theme.dayFont
        dayLabel.textAlignment = viewModel.theme.dayTextAlignment
        dayLabel.textColor = viewModel.isSelected ? viewModel.theme.dayCurrentMonthSelectedTextColor : viewModel.theme.dayCurrentMonthNotSelectedTextColor
    }
}

extension DayView {
    
    public struct ViewModel: Hashable {
        
        public var isSelected: Bool
        public var isEnabled: Bool
        public var theme: ACCalendarUITheme
        
        public init(isSelected: Bool, isEnabled: Bool, theme: ACCalendarUITheme) {
            self.isSelected = isSelected
            self.isEnabled = isEnabled
            self.theme = theme
        }
        
        public func hash(into hasher: inout Hasher) {
            hasher.combine(isSelected)
            hasher.combine(isEnabled)
            hasher.combine(theme)
        }
    }
    
    public struct Content: Equatable {
        public init(dayText: String) {
            self.dayText = dayText
        }
        
        public let dayText: String
    }
}

extension DayView: CalendarItemViewRepresentable {
    
    public static func createView(withViewModel viewModel: ViewModel) -> DayView {
        DayView(viewModel: viewModel)
    }
    
    public static func updateComponents(_ content: Content, on view: DayView) {
        view.updateComponents(content)
    }
}

//
//  DayOfWeekView.swift
//  ACUICalendar
//

import UIKit

open class DayOfWeekView: UIView {
    
    private let viewModel: ViewModel
    private let label: UILabel
    
    private init(viewModel: ViewModel) {
        self.viewModel = viewModel
        label = UILabel()
        super.init(frame: .zero)
        setupComponents()
    }
    
    required public init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        let edgeInsets = viewModel.theme.dayOfWeekEdgeInsets
        let insetBounds = bounds.inset(
            by: UIEdgeInsets(
                top: edgeInsets.top,
                left: edgeInsets.left,
                bottom: edgeInsets.bottom,
                right: edgeInsets.right)
        )
        
        label.frame = CGRect(
            x: edgeInsets.left,
            y: edgeInsets.top,
            width: insetBounds.width,
            height: insetBounds.height
        )
    }
    
    private func setupComponents() {
        isUserInteractionEnabled = false
        backgroundColor = viewModel.theme.backgroundColor
        addSubview(label)
    }
    
    private func updateComponents(_ content: Content) {
        label.text = content.dayOfWeekText
        updateTheme()
    }
    
    private func updateTheme() {
        self.backgroundColor = viewModel.theme.dayOfWeekBackgroundColor
        label.font = viewModel.theme.dayOfWeekFont
        label.textAlignment = viewModel.theme.dayOfWeekTextAlignment
        label.textColor = viewModel.theme.dayOfWeekTextColor
    }
}

extension DayOfWeekView {
    
    public struct Content: Equatable {
        
        public init(dayOfWeekText: String) {
            self.dayOfWeekText = dayOfWeekText
        }
        
        public let dayOfWeekText: String
    }
}

extension DayOfWeekView {
    
    public struct ViewModel: Hashable {
        
        public var theme: ACCalendarUITheme
        
        public init(theme: ACCalendarUITheme) {
            self.theme = theme
        }
        
        public func hash(into hasher: inout Hasher) {
            hasher.combine(theme)
        }
    }
}

extension DayOfWeekView: CalendarItemViewRepresentable {
    
    public static func createView(withViewModel viewModel: ViewModel) -> DayOfWeekView {
        DayOfWeekView(viewModel: viewModel)
    }
    
    public static func updateComponents(_ content: Content, on view: DayOfWeekView) {
        view.updateComponents(content)
    }
}

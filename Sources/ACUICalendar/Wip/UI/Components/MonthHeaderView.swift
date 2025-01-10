//
//  MonthHeaderView.swift
//  ACUICalendar
//

import UIKit

open class MonthHeaderView: UIView {
    
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
    
    private func setupComponents() {
        isUserInteractionEnabled = false
        
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        
        let edgeInsets = viewModel.theme.monthHeaderEdgeInsets
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor, constant: edgeInsets.top),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: edgeInsets.bottom),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: edgeInsets.left),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: edgeInsets.right),
        ])
    }
    
    private func updateComponents(_ content: Content) {
        updateTheme()
        label.text = content.monthText
    }
    
    private func updateTheme() {
        self.backgroundColor = viewModel.theme.monthHeaderBackgroundColor
        self.label.font = viewModel.theme.monthHeaderTextFont
        self.label.textColor = viewModel.theme.monthHeaderTextColor
        self.label.textAlignment = viewModel.theme.monthHeaderTextAlignment
    }
    
    public struct Content: Equatable {
        public init(monthText: String) {
            self.monthText = monthText
        }
        
        public let monthText: String
    }
}

extension MonthHeaderView {
    
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

extension MonthHeaderView: CalendarItemViewRepresentable {
    
    public static func createView(withViewModel viewModel: ViewModel) -> MonthHeaderView {
        MonthHeaderView(viewModel: viewModel)
    }
    
    public static func updateComponents(_ content: Content, on view: MonthHeaderView) {
        view.updateComponents(content)
    }
}

//
//  ViewController.swift
//  ACUICalendarDemo
//
//  Created by Дмитрий Поляков on 02.09.2022.
//

import Foundation
import UIKit
import ACUICalendar

class ViewController: UIViewController {
    
    // MARK: - Props
    lazy var datesButton: UIButton = {
        let result = UIButton(type: .system)
        result.setTitle("Select dates", for: .normal)
        result.addTarget(self, action: #selector(self.handleTapDatesButton), for: .touchUpInside)
        return result
    }()
    
    lazy var datesLabel = UILabel()
    
    lazy var selectionNamesView: UIStackView = {
        let result = UIStackView()
        result.axis = .horizontal
        result.distribution = .fillEqually
        
        return result
    }()
    
    lazy var positionSegmentControl = UISegmentedControl(items: ["Horizontal", "Vertical"])
    
    var service = ACCalendarService.default() {
        didSet { self.updateComponents() }
    }
    
    var selectionName: ACCalendarDateSelectionName = .single {
        didSet {
            switch self.selectionName {
            case .single:
                self.service.selection = ACCalendarSingleDateSelection(
                    calendar: self.service.calendar,
                    datesSelected: self.service.datesSelected
                )
            case .multi:
                self.service.selection = ACCalendarMultiDateSelection(
                    calendar: self.service.calendar,
                    datesSelected: self.service.datesSelected
                )
            case .range:
                self.service.selection = ACCalendarRangeDateSelection(
                    calendar: self.service.calendar,
                    datesSelected: self.service.datesSelected
                )
            default:
                break
            }
        }
    }
    
    var selectionNames: [ACCalendarDateSelectionName] = [.single, .multi, .range]
    
    var scrollDirection: UICollectionView.ScrollDirection = .horizontal
    
    var showsCurrentDaysInMonth = false
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = ACCalendarUITheme().backgroundColor
        let guide = self.view.safeAreaLayoutGuide
        
        let dateSelectStackView = UIStackView(arrangedSubviews: [self.datesLabel, self.datesButton])
        dateSelectStackView.axis = .horizontal
        dateSelectStackView.spacing = 16
        dateSelectStackView.distribution = .fillEqually
        
        let stackView = UIStackView(arrangedSubviews: [
            dateSelectStackView,
            makeTitleLabel("Selection type: "),
            selectionNamesView,
            makeTitleLabel("Position: "),
            positionSegmentControl,
            makeTitleLabel("Content visibility: "),
            makeTitleWithSwitch(
                text: "Shows only current days in month",
                isOn: showsCurrentDaysInMonth,
                onAction: { [weak self] (val) in
                    self?.showsCurrentDaysInMonth = val
            })
        ])
        
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.removeFromSuperview()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: guide.topAnchor, constant: 16),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: guide.bottomAnchor, constant: -16),
            stackView.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -16)
        ])
        
        self.positionSegmentControl.addTarget(self, action: #selector(positionSegmentChanged(_:)), for: .valueChanged)
        
        self.updateComponents()
    }
    
    func updateComponents() {
        var datesText: String = ""
        let datesSelectedTexts = self.service.datesSelected.map({ $0.toLocalString(withFormatType: .default, locale: .current) })
        
        switch self.selectionName {
        case .single:
            datesText = datesSelectedTexts.first ?? ""
        case .multi:
            datesText = datesSelectedTexts.joined(separator: ", ")
        case .range:
            if let first = datesSelectedTexts.first {
                datesText = first
                
                if let last = datesSelectedTexts.last, last != datesSelectedTexts.first {
                    datesText +=  " - " + last
                }
            }
        default:
            break
        }
        
        self.datesLabel.text = datesText.isEmpty ? "Not selected dates" : datesText
        
        let selectionNamesViews: [UIView] = self.selectionNames.map { name in
            let button = UIButton(type: .system)
            button.setTitle(name.identifer.capitalizingFirstLetter(), for: .normal)
            button.setTitleColor(name == selectionName ? .systemBlue : ACCalendarUITheme().weekDayTextColor, for: .normal)
            button.addTarget(self, action: #selector(self.handleTapSelectionNameView(_:)), for: .touchUpInside)
            return button
        }
        
        self.selectionNamesView.subviews.forEach({ $0.removeFromSuperview() })
        selectionNamesViews.forEach({ self.selectionNamesView.addArrangedSubview($0) })
        
        self.positionSegmentControl.selectedSegmentIndex = scrollDirection == .horizontal ? 0 : 1
    }
    
    @objc
    private func handleTapDatesButton() {
        let vc = CalendarViewController(
            service: self.service,
            height: scrollDirection == .horizontal ? .fix(400) : .fullscreen
        )
        let nc = UINavigationController(rootViewController: vc)
        vc.scrollDirection = scrollDirection
        vc.showsCurrentDaysInMonth = showsCurrentDaysInMonth
        vc.didTapDone = { [weak self, weak nc] service in
            self?.service = service
            nc?.dismiss(animated: true)
        }
        
        vc.didTapCancel = { [weak nc] in
            nc?.dismiss(animated: true)
        }
        vc.isModalInPresentation = true
        self.present(nc, animated: true)
    }
    
    @objc
    private func handleTapSelectionNameView(_ button: UIButton) {
        guard
            let index = self.selectionNamesView.subviews.firstIndex(of: button),
            let name = self.selectionNames.element(at: index)
        else { return }
        
        self.selectionName = name
        self.reloadButtonStyles()
    }
    
    private func reloadButtonStyles() {
        let index = selectionNames.firstIndex(of: selectionName) ?? 0
        let buttons = selectionNamesView.arrangedSubviews as? [UIButton] ?? []
        
        for (idx, button) in buttons.enumerated() {
            button.setTitleColor(idx == index ? .systemBlue : ACCalendarUITheme().monthSelectDateTextColor, for: .normal)
        }
    }
     
    @objc private
    func positionSegmentChanged(_ control: UISegmentedControl) {
        self.scrollDirection = {
            control.selectedSegmentIndex == 0 ? .horizontal : .vertical
        }()
    }
    
    // MARK: - Component fabrication
    
    private func makeTitleLabel(_ text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = ACCalendarUITheme().monthSelectDateTextColor
        return label
    }
    
    private func makeTitleWithSwitch(text: String, isOn: Bool, onAction: ((Bool) -> Void)?) -> UIView {
        let view = UIView()
        
        let label = UILabel()
        label.text = text
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = ACCalendarUITheme().monthSelectDateTextColor
        let switchControl = ActionSwitchControl(isOn: isOn, onAction: onAction)
        
        view.addSubview(label)
        view.addSubview(switchControl)
        label.translatesAutoresizingMaskIntoConstraints = false
        switchControl.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.topAnchor),
            label.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: switchControl.leadingAnchor),
            
            switchControl.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            switchControl.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        return view
    }
}


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
    
    var service = ACCalendarService() {
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
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .backgroundColor
        let guide = self.view.safeAreaLayoutGuide
        
        let dateSelectStackView = UIStackView(arrangedSubviews: [self.datesLabel, self.datesButton])
        dateSelectStackView.axis = .horizontal
        dateSelectStackView.spacing = 16
        dateSelectStackView.distribution = .fillEqually
        
        let stackView = UIStackView(arrangedSubviews: [dateSelectStackView, self.selectionNamesView, .init()])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.removeFromSuperview()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: guide.topAnchor, constant: 16),
            stackView.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: -16),
            stackView.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -16)
        ])
        
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
            button.setTitleColor(name == self.selectionName ? .black : .gray, for: .normal)
            button.addTarget(self, action: #selector(self.handleTapSelectionNameView(_:)), for: .touchUpInside)
            return button
        }
        
        self.selectionNamesView.subviews.forEach({ $0.removeFromSuperview() })
        selectionNamesViews.forEach({ self.selectionNamesView.addArrangedSubview($0) })
    }
    
    @objc
    private func handleTapDatesButton() {
        let vc = CalendarViewController(service: self.service)
        let nc = UINavigationController(rootViewController: vc)
        
        vc.didTapDone = { [weak self, weak nc] service in
            self?.service = service
            nc?.dismiss(animated: true)
        }
        
        vc.didTapCancel = { [weak nc] in
            nc?.dismiss(animated: true)
        }
        
        self.present(nc, animated: true)
    }
    
    @objc
    private func handleTapSelectionNameView(_ button: UIButton) {
        guard
            let index = self.selectionNamesView.subviews.firstIndex(of: button),
            let name = self.selectionNames.element(at: index)
        else { return }
        
        self.selectionName = name
    }
    
}

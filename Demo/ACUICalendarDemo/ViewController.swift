//
//  ViewController.swift
//  ACUICalendarDemo
//
//  Created by Дмитрий Поляков on 02.09.2022.
//

import Foundation
import UIKit

class ViewController: UIViewController {
    
    // MARK: - Props
    var service = ACCalendarService.default() {
        didSet { self.updateComponents() }
    }
    
    var datesSelected: [Date] {
        get { self.service.datesSelected }
        set { self.service.datesSelected = newValue }
    }
    
    lazy var datesButton: UIButton = {
        let result = UIButton(type: .system)
        result.addTarget(self, action: #selector(self.handleTapDatesButton), for: .touchUpInside)
        
        return result
    }()
    
    lazy var datesTextField: UITextField = {
        let result = UITextField()
        result.inputView = self.calendarView
        result.placeholder = "Select Dates"
        
        let toolbar = UIToolbar()
        toolbar.items = [
            UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.tapCancel)),
            .init(),
            UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.tapDone))
        ]
        toolbar.sizeToFit()
        result.inputAccessoryView = toolbar
        
        return result
    }()
    
    lazy var calendarView: ACCalendarView = {
        ACCalendarView(frame: .init(x: 0, y: 0, width: 0, height: 352))
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .backgroundColor
        let guide = self.view.safeAreaLayoutGuide
        
        let stackView = UIStackView(arrangedSubviews: [self.datesButton, self.datesTextField, .init()])
        stackView.axis = .vertical
        
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
        
        if let first = self.datesSelected.first {
            datesText = first.toLocalString(withFormatType: .default, locale: .current)
            
            if let last = self.datesSelected.last, last != self.datesSelected.first {
                datesText +=  " - " + last.toLocalString(withFormatType: .default, locale: .current)
            }
        }
        
        self.datesButton.setTitle(datesText.isEmpty ? "Select dates" : datesText, for: .normal)
        self.datesTextField.text = datesText
    }
    
    @objc
    private func handleTapDatesButton() {
        let vc = CalendarViewController(service: self.service)
        let nc = UINavigationController(rootViewController: vc)
        
        vc.didTapDone = { [weak self, weak nc] dates in
            self?.datesSelected = dates
            nc?.dismiss(animated: true)
        }
        
        vc.didTapCancel = { [weak nc] in
            nc?.dismiss(animated: true)
        }
        
        self.present(nc, animated: true)
    }
    
    @objc
    private func tapCancel() {
        self.datesTextField.resignFirstResponder()
    }
    
    @objc
    private func tapDone() {
        self.datesTextField.resignFirstResponder()
        self.service = self.calendarView.service
    }
    
}

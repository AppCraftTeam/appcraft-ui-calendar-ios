//
//  CalendarViewController.swift
//  ACUICalendarDemo
//
//  Created by Дмитрий Поляков on 23.08.2022.
//

import UIKit
import DPSwift
import ACUICalendar

class CalendarViewController: UIViewController {
    
    // MARK: - Init
    init(service: ACCalendarService) {
        self.service = service
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Props
    var service: ACCalendarService
    
    lazy var calendarView: ACCalendarView = {
        ACCalendarView(service: self.service)
    }()
    
    var didTapCancel: Closure?
    var didTapDone: ContextClosure<ACCalendarService>?

    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .backgroundColor
        
        let guide = self.view.safeAreaLayoutGuide
        
        self.calendarView.removeFromSuperview()
        self.calendarView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(self.calendarView)
        
        NSLayoutConstraint.activate([
            self.calendarView.topAnchor.constraint(equalTo: guide.topAnchor),
            self.calendarView.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            self.calendarView.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
            self.calendarView.heightAnchor.constraint(equalToConstant: 352)
        ])
        
        self.navigationItem.leftBarButtonItem = .init(title: "Cancel", style: .plain, target: self, action: #selector(self.handleTapCancel))
        self.navigationItem.rightBarButtonItem = .init(title: "Done", style: .plain, target: self, action: #selector(self.handleTapDone))
    }
    
    @objc
    private func handleTapCancel() {
        self.didTapCancel?()
    }
    
    @objc
    private func handleTapDone() {
        self.didTapDone?(self.calendarView.service)
    }

}



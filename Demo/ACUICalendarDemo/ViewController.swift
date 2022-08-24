//
//  ViewController.swift
//  ACUICalendarDemo
//
//  Created by Дмитрий Поляков on 23.08.2022.
//

import UIKit

class ViewController: UIViewController {
    
    let monthView = CalendarMonthView()
    
    override func loadView() {
        self.view = self.monthView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
//        var calendar = Calendar.current
//        calendar.firstWeekday = 2
//        
//        let date = Date()
//        
//        let month = calendar.monthDates(for: date)
//        let start = calendar.weekDatesOfStartOfMonthWithoutCurrentMonth(for: date)
//        let end = calendar.weekDatesOfEndOfMonthWithoutCurrentMonth(for: date)
//        
//        print("!!!", start, month, end)
    }


}



//
//  ViewController.swift
//  ACUICalendarDemo
//
//  Created by Дмитрий Поляков on 23.08.2022.
//

import UIKit

class ViewController: UIViewController {
    
    let monthView = ACCalendarView()
    
    override func loadView() {
        self.view = self.monthView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
    }


}



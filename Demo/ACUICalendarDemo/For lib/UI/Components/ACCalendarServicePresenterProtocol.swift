//
//  ACCalendarServicePresenterProtocol.swift
//  ACUICalendarDemo
//
//  Created by Дмитрий Поляков on 02.09.2022.
//

import Foundation

public protocol ACCalendarServicePresenterProtocol: AnyObject {
    var service: ACCalendarService? { get set }
    
    func setupServiceAndUpdateComponents(_ service: ACCalendarService)
    func updateComponents()
}

public extension ACCalendarServicePresenterProtocol {
    
    func setupServiceAndUpdateComponents(_ service: ACCalendarService) {
        self.service = service
        self.updateComponents()
    }
    
}

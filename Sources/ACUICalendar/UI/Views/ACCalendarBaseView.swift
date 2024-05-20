//
//  ACCalendarBaseView.swift
//  ACUICalendarDemo
//
//  Created by Дмитрий Поляков on 03.09.2022.
//

import Foundation
import UIKit

open class ACCalendarBaseView: UIView {
    
    // MARK: - Init
    public init(service: ACCalendarService) {
        self.service = service
        
        super.init(frame: .zero)
        
        self.setupComponents()
    }
    
    public override init(frame: CGRect) {
        self.service = ACCalendarService.default()
        
        super.init(frame: frame)
        
        self.setupComponents()
    }
    
    public required init?(coder: NSCoder) {
        self.service = ACCalendarService.default()
        
        super.init(coder: coder)
        
        self.setupComponents()
    }
    
    // MARK: - Props
    open var service: ACCalendarService {
        didSet { self.updateComponents() }
    }
    
    open var theme = ACCalendarUITheme() {
        didSet { self.updateComponents() }
    }
    
    // MARK: - Methods
    open func setupComponents() {}
    
    open func updateComponents() {}
    
}

//
//  ACCalendarArrowsView.swift
//  ACUICalendarDemo
//
//  Created by Дмитрий Поляков on 26.08.2022.
//

import Foundation
import UIKit
import DPSwift

open class ACCalendarArrowsView: UIView, ACCalendarServicePresenterProtocol {
    
    // MARK: - Init
    public init(service: ACCalendarService, theme: ACCalendarUITheme) {
        self.service = service
        self.theme = theme
        
        super.init(frame: .zero)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupComponents()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.setupComponents()
    }
    
    // MARK: - Props
    open lazy var leftArrowButton: UIButton = {
        let image = UIImage.ic_24_arrow_left?.withRenderingMode(.alwaysTemplate)
        
        let result = UIButton(type: .system)
        result.setImage(image, for: .normal)
        result.addTarget(self, action: #selector(self.buttonAction(_:)), for: .touchUpInside)
        
        return result
    }()
    
    open lazy var rightArrowButton: UIButton = {
        let image = UIImage.ic_24_arrow_right?.withRenderingMode(.alwaysTemplate)
        
        let result = UIButton(type: .system)
        result.setImage(image, for: .normal)
        result.addTarget(self, action: #selector(self.buttonAction(_:)), for: .touchUpInside)
        
        return result
    }()
    
    open lazy var stackView: UIStackView = {
        let result = UIStackView(arrangedSubviews: [self.leftArrowButton, self.rightArrowButton])
        result.axis = .horizontal
        result.spacing = 8
        result.distribution = .fillEqually
        
        return result
    }()
    
    open var service: ACCalendarService?
    
    open var theme = ACCalendarUITheme() {
        didSet { self.updateComponents() }
    }
    
    open var leftArrowIsEnabled: Bool {
        get { self.leftArrowButton.isEnabled }
        set { self.leftArrowButton.isEnabled = newValue }
    }
    
    open var rightArrowIsEnabled: Bool {
        get { self.rightArrowButton.isEnabled }
        set { self.rightArrowButton.isEnabled = newValue }
    }
    
    open var didTapLeftArrow: Closure?
    open var didTapRightArrow: Closure?
    
    // MARK: - Methods
    open func setupComponents() {
        self.tintColor = .black
        
        self.stackView.removeFromSuperview()
        self.stackView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(self.stackView)
        
        NSLayoutConstraint.activate([
            self.stackView.topAnchor.constraint(equalTo: self.topAnchor),
            self.stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            self.leftArrowButton.widthAnchor.constraint(equalToConstant: 24),
            self.leftArrowButton.heightAnchor.constraint(equalToConstant: 24),
            
            self.rightArrowButton.widthAnchor.constraint(equalToConstant: 24),
            self.rightArrowButton.heightAnchor.constraint(equalToConstant: 24)
        ])
        
        self.updateComponents()
    }
    
    open func updateComponents() {
        self.subviews.forEach({ $0.tintColor = self.theme.arrowsTintColor })
        self.leftArrowIsEnabled = self.service?.previousMonth() != nil
        self.rightArrowIsEnabled = self.service?.nextMonth() != nil
    }
    
    @objc
    open func buttonAction(_ button: UIButton) {
        switch button {
        case self.leftArrowButton:
            self.didTapLeftArrow?()
        case self.rightArrowButton:
            self.didTapRightArrow?()
        default:
            break
        }
    }
    
}

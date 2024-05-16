//
//  ACCalendarMonthSelectView.swift
//  ACUICalendarDemo
//
//  Created by Дмитрий Поляков on 26.08.2022.
//

import Foundation
import UIKit
import DPSwift

open class ACCalendarMonthSelectView: ACCalendarBaseView {
    
    // MARK: - Props
    open lazy var monthDateLabel: UILabel = {
        UILabel()
    }()
    
    open lazy var arrowImageView: UIImageView = {
        let image = UIImage.ic_18_arrow_right?.withRenderingMode(.alwaysTemplate)
        let result = UIImageView(image: image)
        result.contentMode = .scaleAspectFill
        
        return result
    }()
    
    open var isOn: Bool = false {
        didSet { self.updateComponents() }
    }
    
    open var didToggle: ContextClosure<Bool>?
    
    // MARK: - Methods
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        self.setHighlighted(true)
    }
    
    open override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        
        self.setHighlighted(true)
    }
    
    open override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        
        self.setHighlighted(false)
    }
    
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        self.setHighlighted(false)

        self.isOn.toggle()
        self.didToggle?(self.isOn)
    }
    
    open override func setupComponents() {
        self.monthDateLabel.removeFromSuperview()
        self.monthDateLabel.translatesAutoresizingMaskIntoConstraints = false

        self.arrowImageView.removeFromSuperview()
        self.arrowImageView.translatesAutoresizingMaskIntoConstraints = false

        self.addSubview(self.monthDateLabel)
        self.addSubview(self.arrowImageView)
        
        NSLayoutConstraint.activate([
            self.arrowImageView.widthAnchor.constraint(equalToConstant: 18),
            self.arrowImageView.heightAnchor.constraint(equalToConstant: 18),
            
            self.monthDateLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.monthDateLabel.topAnchor.constraint(equalTo: self.topAnchor),
            self.monthDateLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            self.arrowImageView.leadingAnchor.constraint(equalTo: self.monthDateLabel.trailingAnchor, constant: 2),
            self.arrowImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.arrowImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        
        self.updateComponents()
    }
    
    func updateMonthDateLabel() {
        let locale = self.service.calendar.locale ?? .current
        let monthDate = self.service.currentMonthDate
        
        let monthText = monthDate
            .toLocalString(withFormatType: .montLettersAndYear, locale: locale)
            .capitalizingFirstLetter()
        
        self.monthDateLabel.text = monthText
    }
    
    open override func updateComponents() {
        self.updateMonthDateLabel()
        self.monthDateLabel.font = self.theme.monthSelectDateFont
        self.monthDateLabel.textColor = self.theme.monthSelectDateTextColor
        self.arrowImageView.tintColor = self.theme.monthSelectArrowImageTintColor
        
        let arrowImageTransform: CGAffineTransform = self.isOn ? CGAffineTransform(rotationAngle: CGFloat.pi / 2) : .identity
        
        if self.arrowImageView.transform != arrowImageTransform {
            UIView.animate(withDuration: 0.25, delay: 0) { [weak self] in
                self?.arrowImageView.transform = arrowImageTransform
            }
        }
    }
    
    open func setHighlighted(_ highlighted: Bool) {
        self.alpha = highlighted ? 0.5 : 1.0
    }
    
}

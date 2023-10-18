//
//  ActionButton.swift
//  ACUICalendarDemo
//
//  Created by Damian on 12.09.2023.
//

import UIKit

class ActionSwitchControl: UISwitch {
    
    convenience init(isOn: Bool = false, onAction: ((Bool) -> Void)? = nil) {
        self.init(frame: .zero)
        self.onAction = onAction
        self.setOn(isOn, animated: false)
        self.setupAction()
    }
    
    var onAction: ((Bool) -> Void)? {
        didSet { self.setupAction() }
    }
    
    func setupAction() {
        if self.onAction == nil {
            self.removeTarget(self, action: #selector(handleAction), for: .valueChanged)
        } else {
            self.addTarget(self, action: #selector(handleAction), for: .valueChanged)
        }
    }
    
    @objc
    func handleAction() {
        self.onAction?(isOn)
    }
    
}
class ActionButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupComponents()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupComponents()
    }
    
    init(title: String = "", onAction: (() -> Void)? = nil) {
        super.init(frame: .zero)
        self.onAction = onAction
        self.setTitle(title, for: .normal)
        self.setupAction()
    }
    
    convenience init(
        title: String = "",
        type: UIButton.ButtonType = .system,
        onAction: (() -> Void)? = nil
    ) {
        self.init(type: type)
        self.setTitle(title, for: .normal)
        self.onAction = onAction
        self.setupAction()
    }
    
    var onAction: (() -> Void)? {
        didSet { self.setupAction() }
    }
    
    func setupComponents() {}
    
    func updateComponents() {}
        
    func setupAction() {
        if self.onAction == nil {
            self.removeTarget(self, action: #selector(handleAction), for: .touchUpInside)
        } else {
            self.addTarget(self, action: #selector(handleAction), for: .touchUpInside)
        }
    }
    
    @objc
    func handleAction() {
        self.onAction?()
    }
}

//
//  AppSlider.swift
//
//
//  Created by Damian on 23.05.2024.
//

import UIKit
import Foundation


class Slider: UISlider {
    
    var valueLabel = UILabel()
    
    private var thumbFrame: CGRect {
        var frame = thumbRect(forBounds: bounds, trackRect: trackRect(forBounds: bounds), value: value)
        frame.origin.y -= 20
        frame.size = .init(width: 30, height: 20)
        return frame
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.valueLabel.frame = thumbFrame
        self.valueLabel.text = Double(value).rounded().toInt.description
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupComponents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupComponents() {
        self.addSubview(valueLabel)
        self.valueLabel.font = .systemFont(ofSize: 12, weight: .regular)
        self.valueLabel.textAlignment = .center
    }
}

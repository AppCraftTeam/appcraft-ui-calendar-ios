//
//  UIColor+AssetColor.swift
//
//
//  Created by Damian on 18.10.2023.
//

import UIKit

extension UIColor {
    static func assetColor(name: String) -> UIColor {
        UIColor(named: name, in: Bundle.module, compatibleWith: nil) ?? .clear
    }
}

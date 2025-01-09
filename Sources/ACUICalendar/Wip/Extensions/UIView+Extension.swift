//
//  UIView+Extension.swift
//  ACUICalendar
//

import UIKit

extension UIView {
    
    static func performAction(isNeedAnimate: Bool, _ action: () -> Void) {
        isNeedAnimate ? action() : UIView.performWithoutAnimation(action)
    }
}

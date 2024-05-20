//
//  PortraitOrientationObserver.swift
//
//
//  Created by Damian on 20.05.2024.
//

import UIKit
import Foundation

protocol PortraitOrientationObserverListener {
    func deviceOrientationObserver(didChangeOrientation isPortrait: Bool)
}

class PortraitOrientationObserver: ProtoObserver<PortraitOrientationObserverListener> {
    
    override init() {
        super.init()
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(oridentationChanged),
            name: UIDevice.orientationDidChangeNotification,
            object: nil
        )
    }

    @objc
    private func oridentationChanged() {
        DispatchQueue.main.async {
            switch UIDevice.current.orientation {
            case .portrait:
                self.invoke({ $0.deviceOrientationObserver(didChangeOrientation: true) }, queue: .main)
            case .landscapeLeft, .landscapeRight:
                self.invoke({ $0.deviceOrientationObserver(didChangeOrientation: false) }, queue: .main)
            default:
                break
            }
        }
    }
}

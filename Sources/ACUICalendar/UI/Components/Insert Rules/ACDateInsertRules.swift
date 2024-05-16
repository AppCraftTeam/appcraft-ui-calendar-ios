//
//  ACDateInsertRules.swift
//  
//
//  Created by Damian on 16.05.2024.
//

import UIKit

public protocol ACDateInsertRules {
    func needsInsertPastDates(_ scrollView: UIScrollView) -> Bool
    func needsInsertFutureDates(_ scrollView: UIScrollView) -> Bool
}

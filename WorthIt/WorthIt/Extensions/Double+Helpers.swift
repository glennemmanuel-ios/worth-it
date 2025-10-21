//
//  Double+Helpers.swift
//  WorthIt
//
//  Created by Glen Emmanuel Solo on 10/21/25.
//

import Foundation

extension Double {
    
    func formatted(withDecimalPlaces: Int = 2) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale.current
        formatter.minimumFractionDigits = withDecimalPlaces
        formatter.maximumFractionDigits = withDecimalPlaces
        return formatter.string(from: NSNumber(value: self)) ?? "N/A"
    }
    
}

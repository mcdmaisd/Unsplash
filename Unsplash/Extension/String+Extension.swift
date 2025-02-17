//
//  String+Extension.swift
//  NShopping
//
//  Created by ilim on 2025-01-15.
//

import Foundation

extension String {
    func dateToString() -> String {
        let isoformatter = ISO8601DateFormatter()
        isoformatter.formatOptions = [.withInternetDateTime]
        
        guard let date = isoformatter.date(from: self) else { return Constants.failure}
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: Constants.locale)
        formatter.dateFormat = Constants.dateStringFormat
        
        return formatter.string(from: date)
    }
}

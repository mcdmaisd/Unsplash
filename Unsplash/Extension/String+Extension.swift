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
        
        guard let date = isoformatter.date(from: self) else { return "Fail"}
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy년 MM월 dd일 '게시됨'"
        
        return formatter.string(from: date)
    }
}

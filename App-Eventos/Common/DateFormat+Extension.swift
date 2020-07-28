//
//  DateFormat+Extension.swift
//  App-Eventos
//

import Foundation
import UIKit

extension Double {
    /// Returns a formatted date as dd MMM YY, hh:mm a
    /// - Returns: a `String` with formatted date
    func dateFormat() -> String {
        let date = Date(timeIntervalSince1970: self/1000)
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = "dd MMM YY, hh:mm a"
        return dayTimePeriodFormatter.string(from: date as Date)
    }
}

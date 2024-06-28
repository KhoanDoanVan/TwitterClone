//
//  TimeStamp.swift
//  IOS-TwitterClone
//
//  Created by Đoàn Văn Khoan on 17/04/2024.
//

import Foundation
import Firebase

extension Timestamp { // edit prospertise of the Timestamp Firebase
    func timestampString() -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [ .hour, .minute, .second, .weekOfMonth, .day]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .abbreviated
        return formatter.string(from: self.dateValue(), to: Date()) ?? ""
    }
}


extension Date {
    func formatted(date: DateFormatter.Style, time: DateFormatter.Style) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = date
        dateFormatter.timeStyle = time
        return dateFormatter.string(from: self)
    }
    
    func timeAgoSinceNow(date : Date) -> String {
            let calendar = Calendar.current
            let now = Date()
            let components = calendar.dateComponents([.second, .minute, .hour, .day, .weekOfYear, .month, .year], from: date, to: now)
            
            if let year = components.year, year > 0 {
                return "\(year)y"
            } else if let month = components.month, month > 0 {
                return "\(month)mo"
            } else if let weekOfYear = components.weekOfYear, weekOfYear > 0 {
                return "\(weekOfYear)w"
            } else if let day = components.day, day > 0 {
                return "\(day)d"
            } else if let hour = components.hour, hour > 0 {
                return "\(hour)h"
            } else if let minute = components.minute, minute > 0 {
                return "\(minute)m"
            } else if let second = components.second, second > 0 {
                return "\(second)s"
            } else {
                return "just now"
            }
        }
}

//
//  Date.swift
//  Task Tracker
//
//  Created by protel on 29.07.2020.
//  Copyright © 2020 Ahmet Onur Akman. All rights reserved.
//

import Foundation

extension Date {
    func compareToCurrentTime() -> Bool {
        return Date() >= self
    }
}

extension Date {
    func convertToString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM E, HH:mm"
        return formatter.string(from: self)
    }
}

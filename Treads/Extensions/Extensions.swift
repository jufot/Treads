//
//  Extensions.swift
//  Treads
//
//  Created by Jeremiah Ufot on 3/6/19.
//  Copyright © 2019 Jeremiah Ufot. All rights reserved.
//

import Foundation

extension Double {
    func metersToMiles(places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return ((self / 1609.34) * divisor).rounded() / divisor
    }
}

extension Int {
    func formatTimeDurationToString() -> String {
        let durationOfHours = self / 3600
        let durationOfMinutes = (self % 3600) / 60
        let durationOfSeconds = (self % 3600) % 60
        
        if durationOfSeconds < 0 {
            return "00:00:00"
        } else {
            if durationOfHours == 0 {
                return String(format: "%02d:%02d", durationOfMinutes, durationOfSeconds)
            } else {
                return String(format: "%02d:%02d:%02d", durationOfHours, durationOfMinutes, durationOfSeconds)
            }
        }
    }
}

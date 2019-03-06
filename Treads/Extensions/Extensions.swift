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

//
//  Double.swift
//  Rootz
//
//  Created by Adriano d'Alessandro on 28/02/24.
//

import Foundation

extension Double {
    var degreesToRadians: Double { return self * .pi / 180 }
    var radiansToDegrees: Double { return self * 180 / .pi }
}

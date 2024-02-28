//
//  CLLocationCoordinate2D.swift
//  Rootz
//
//  Created by Adriano d'Alessandro on 28/02/24.
//

import Foundation
import CoreLocation

extension CLLocationCoordinate2D {
    func direction(to target: CLLocationCoordinate2D) -> Double {
        let lat1 = self.latitude.degreesToRadians
        let lon1 = self.longitude.degreesToRadians
        let lat2 = target.latitude.degreesToRadians
        let lon2 = target.longitude.degreesToRadians
        let dLon = lon2 - lon1
        let y = sin(dLon) * cos(lat2)
        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon)
        var brng = atan2(y, x)
        brng = brng.radiansToDegrees
        return (brng + 360).truncatingRemainder(dividingBy: 360)
    }
}

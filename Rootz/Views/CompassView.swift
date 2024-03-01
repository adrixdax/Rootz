//
//  CompassView.swift
//  Rootz
//
//  Created by Adriano d'Alessandro on 01/03/24.
//

import Foundation
import SwiftUI
import MapKit

struct CompassView: View {
    var colorScheme: ColorScheme
    @ObservedObject var locationManager: LocationManager
    var selectedPlacemark: MKPlacemark?
    
    var body: some View {
        ZStack {
            let compassImageName = "\(colorScheme == .dark ? "DarkMode" : "LightMode")_InnerCompass"
            Image(uiImage: UIImage(named: compassImageName)!)
                .scaledToFit()
                .rotationEffect(Angle(degrees: self.locationManager.calculateHeadingToReferencePoint() ?? 0))
        }
        .onChange(of: selectedPlacemark) { _ in
            if let selectedPlacemark = selectedPlacemark {
                locationManager.setNewReferencePoint(referencePoint: selectedPlacemark.coordinate)
            }
        }
    }
}

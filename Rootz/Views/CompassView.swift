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
            ZStack{
                Image(uiImage: UIImage(named: "\(colorScheme == .dark ? "DarkMode" : "LightMode")_OuterCircle")!).scaledToFit()
            }
            ZStack{
                Image(uiImage: UIImage(named: "\(colorScheme == .dark ? "DarkMode" : "LightMode")_InnerCompass")!).scaledToFit().rotationEffect(Angle(degrees: self.locationManager.calculateHeadingToReferencePoint() ?? 0))
            }
            .onChange(of: selectedPlacemark) { _ in
                if let selectedPlacemark = selectedPlacemark {
                    locationManager.setNewReferencePoint(referencePoint: selectedPlacemark.coordinate)
                }
            }
        }
    }
}

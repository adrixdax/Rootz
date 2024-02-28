//
//  CompassMarkerView.swift
//  Rootz
//
//  Created by Adriano d'Alessandro on 28/02/24.
//
import SwiftUI

struct CompassMarkerView: View {
    let marker: Marker
    let compassDegrees: Double
    let headingToSelectedLocation: Double?

    var body: some View {
        VStack {
            Text(marker.degreeText())
                .fontWeight(.light)
                .rotationEffect(self.textAngle())
            
            Capsule()
                .frame(width: self.capsuleWidth(),
                       height: self.capsuleHeight())
                .foregroundColor(self.capsuleColor())
            
            Text(marker.label)
                .fontWeight(.bold)
                .rotationEffect(self.textAngle())
                .padding(.bottom, 180)
        }.rotationEffect(Angle(degrees: self.marker.degrees + (headingToSelectedLocation ?? 0)))
    }
    
    private func capsuleWidth() -> CGFloat {
        return self.marker.degrees == 0 ? 7 : 3
    }

    private func capsuleHeight() -> CGFloat {
        return self.marker.degrees == 0 ? 45 : 30
    }

    private func capsuleColor() -> Color {
        return self.marker.degrees == 0 ? .red : .gray
    }

    private func textAngle() -> Angle {
        return Angle(degrees: -self.compassDegrees - self.marker.degrees)
    }
}

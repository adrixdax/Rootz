//
//  LocationManager.swift
//  Rootz
//
//  Created by Adriano d'Alessandro on 28/02/24.
//
import Foundation
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private var locationManager = CLLocationManager()
    
    @Published var heading: Double = 0
    @Published var location: CLLocation?
    @Published var referencePoint: CLLocationCoordinate2D?
    
    override init() {
        super.init()
        setupLocationManager()
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.startUpdatingHeading()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        heading = newHeading.trueHeading
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.last
    }
    
    func calculateHeadingToReferencePoint() -> Double? {
        guard let userLocation = location, let referencePoint = referencePoint else {
            return nil
        }
        return userLocation.coordinate.direction(to: referencePoint)
    }
    
    func setNewReferencePoint(referencePoint: CLLocationCoordinate2D) {
        self.referencePoint = referencePoint
        if let heading = calculateHeadingToReferencePoint() {
            self.heading = heading
        }
    }
}

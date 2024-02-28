//
//  ContentView.swift
//  Rootz
//
//  Created by Adriano d'Alessandro on 27/02/24.
//
import SwiftUI
import CoreLocation
import MapKit

struct ContentView : View {
    @ObservedObject var compassHeading = CompassHeading()
    @EnvironmentObject private var locationManager : LocationManager
    @State private var searchText = ""
    @State private var selectedPlacemark: MKPlacemark?
    @State private var searchResults: [MKMapItem] = []

    var body: some View {
        VStack {
            HStack {
                TextField("Search", text: $searchText, onCommit: searchLocation)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button(action: {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }) {
                    Text("Search")
                }
            }
                .padding()
            Spacer()
            if (!searchResults.isEmpty) {
                List(searchResults, id: \.self) { result in
                    Text(result.name ?? "").onTapGesture {
                        self.selectedPlacemark = result.placemark
                        searchResults.removeAll()
                    }
                }
            }
            ZStack {
                ForEach(Marker.markers(), id: \.self) { marker in
                    CompassMarkerView(marker: marker,
                                      compassDegrees: self.compassHeading.degrees,
                                      headingToSelectedLocation: self.locationManager.calculateHeadingToReferencePoint() ?? 0)
                }
            }.onChange(of: selectedPlacemark) { _ in
                if let selectedPlacemark = selectedPlacemark {
                    locationManager.setNewReferencePoint(referencePoint: selectedPlacemark.coordinate) 
                }
            }
            .frame(width: 300,
                   height: 300)
            .rotationEffect(Angle(degrees: self.compassHeading.degrees))
            .statusBar(hidden: true)
            Spacer()
        }
    }
    
    func searchLocation() {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchText
        let search = MKLocalSearch(request: request)
        search.start { response, error in
            guard let response = response else {
                print("Error searching for locations: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            self.searchResults = response.mapItems
        }
    }
}

#Preview {
    ContentView()
}

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
    @State private var baseHeading : Double = 0
    @Environment(\.colorScheme) var colorScheme
    
    init(compassHeading: CompassHeading = CompassHeading(), searchText: String = "", selectedPlacemark: MKPlacemark? = nil, searchResults: [MKMapItem] = []) {
        self.compassHeading = compassHeading
        self.searchText = searchText
        self.selectedPlacemark = selectedPlacemark
        self.searchResults = searchResults
    }

    var body: some View {
        VStack(alignment: .center) {
            HStack(alignment: .top) {
                TextField("Search", text: $searchText, onCommit: searchLocation)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button(action: {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }) {
                    Text("Search")
                }
            }
            .padding()
            if (!searchResults.isEmpty) {
                List(searchResults, id: \.self) { result in
                    Text(result.name ?? "").onTapGesture {
                        self.selectedPlacemark = result.placemark
                        searchResults.removeAll()
                    }
                }
            }
            Spacer()
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
            .rotationEffect(Angle(degrees: self.compassHeading.degrees))
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

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
    @Environment(\.colorScheme) var colorScheme
    @State private var isSearching = false
    
    var body: some View {
        let backgroundColor: Color = colorScheme == .dark ?
        Color(red: 26/255, green: 57/255, blue: 87/255) :
        Color(red: 250/255, green: 232/255, blue: 209/255)
        ZStack {
            backgroundColor.ignoresSafeArea()
            VStack {
                SearchView(searchText: $searchText, searchAction: searchLocation)
                    .padding([.horizontal,.top])
                if (isSearching) {
                    ProgressView()
                } else {
                    if !searchResults.isEmpty {
                        SearchResultList(searchResults: searchResults, onSelect: { result in
                            self.selectedPlacemark = result.placemark
                            searchResults.removeAll()
                        })
                    }
                }
                Spacer()
                CompassView(colorScheme: colorScheme, locationManager: locationManager, selectedPlacemark: selectedPlacemark)
                    .rotationEffect(Angle(degrees: self.compassHeading.degrees))
                Spacer()
            }
        }
    }
    
    func searchLocation() {
        isSearching.toggle()
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchText
        let search = MKLocalSearch(request: request)
        search.start { response, error in
            guard let response = response else {
                print("Error searching for locations: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            self.searchResults = response.mapItems
            isSearching.toggle()
        }
    }
}

struct SearchResultList: View {
    var searchResults: [MKMapItem]
    var onSelect: (MKMapItem) -> Void
    
    var body: some View {
        List(searchResults, id: \.self) { result in
            Text(result.name ?? "")
                .onTapGesture {
                    self.onSelect(result)
                }
        }
    }
}

#Preview {
    ContentView()
}

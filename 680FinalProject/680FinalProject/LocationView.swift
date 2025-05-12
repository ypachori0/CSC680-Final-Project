//
//  locationView.swift
//  680FinalProject
//
//  Created by Michelle Nguyen on 5/9/25.
//

import SwiftUI
import MapKit

struct LocationView: View {
    // Sample data for planned spots and lodging
    @State private var locations: [Location] = [
        Location(name: "Lombard Street", latitude: 37.8023, longitude: -122.4187),
        Location(name: "Alcatraz Island", latitude: 37.8267, longitude: -122.4230),
        Location(name: "Golden Gate Bridge", latitude: 37.8199, longitude: -122.4783),
        Location(name: "Hotel California", latitude: 37.7749, longitude: -122.4194)
    ]
    
    // Region for the map
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )

    var body: some View {
        VStack {
            // Title and description
            Text("Planned Spots and Lodging")
                .font(.largeTitle)
                .bold()
                .padding()

            // Map view with annotations for each location
            Map(coordinateRegion: $region, annotationItems: locations) { location in
                // Updated MapAnnotation for each location
                MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)) {
                    VStack {
                        Image(systemName: "mappin.circle.fill")
                            .foregroundColor(.blue)
                            .font(.title)
                        Text(location.name)
                            .font(.caption)
                            .foregroundColor(.black)
                    }
                }
            }
            .frame(height: 400)
            .cornerRadius(20)
            .shadow(radius: 10)

            // List of locations
            List(locations) { location in
                HStack {
                    Text(location.name)
                        .font(.headline)
                    Spacer()
                    Text("Lat: \(location.latitude), Lon: \(location.longitude)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding()
            }
        }
        .padding()
    }
}

// Location model to hold the data
struct Location: Identifiable {
    var id = UUID()
    var name: String
    var latitude: Double
    var longitude: Double
}

#Preview {
    LocationView()
}

import SwiftUI

struct Location {
    let id = UUID()
    let name: String
    let district: String
    let latitude: Double
    let longitude: Double
    let iconName: String
}

struct LocationsView: View {
    @Environment(\.dismiss) private var dismiss
    
    private let locations: [Location] = [
        Location(name: "Colombo", district: "Western Province", latitude: 6.9271, longitude: 79.8612, iconName: "building.2.fill"),
        Location(name: "Gampaha", district: "Western Province", latitude: 7.0873, longitude: 79.9990, iconName: "building.fill"),
        Location(name: "Kandy", district: "Central Province", latitude: 7.2906, longitude: 80.6337, iconName: "mountain.2.fill"),
        Location(name: "Galle", district: "Southern Province", latitude: 6.0535, longitude: 80.2210, iconName: "water.waves"),
        Location(name: "Jaffna", district: "Northern Province", latitude: 9.6615, longitude: 80.0255, iconName: "sailboat.fill"),
        Location(name: "Kurunegala", district: "North Western Province", latitude: 7.4863, longitude: 80.3647, iconName: "tree.fill")
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: {
                    dismiss()
                }) {
                    ZStack {
                        Circle()
                            .fill(Color.white)
                            .frame(width: 40, height: 40)
                            .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
                        
                        Image(systemName: "arrow.left")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.black)
                    }
                }
                
                Spacer()
                
                Text("Locations")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.black)
                
                Spacer()
                
                Circle()
                    .fill(Color.clear)
                    .frame(width: 40, height: 40)
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)
            
            ScrollView {
                VStack(spacing: 0) {
                    ForEach(locations, id: \.id) { location in
                        LocationCard(location: location)
                        
                        if location.id != locations.last?.id {
                            Spacer()
                                .frame(height: 12)
                        }
                    }
                }
                .padding(.top, 20)
                .padding(.bottom, 20)
            }
        }
        .background(Color(.systemGroupedBackground))
    }
}

struct LocationCard: View {
    let location: Location
    
    private func openLocationInMaps() {
        let latitude = location.latitude
        let longitude = location.longitude
        
        let appleMapURL = URL(string: "http://maps.apple.com/?q=\(latitude),\(longitude)")!
        
        if UIApplication.shared.canOpenURL(appleMapURL) {
            UIApplication.shared.open(appleMapURL)
        } else {
            let googleMapURL = URL(string: "https://maps.google.com/?q=\(latitude),\(longitude)")!
            UIApplication.shared.open(googleMapURL)
        }
    }
    
    var body: some View {
        Button(action: {
            openLocationInMaps()
        }) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(Color.blue.opacity(0.1))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: location.iconName)
                        .font(.system(size: 20))
                        .foregroundColor(.blue)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(location.name)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.black)
                    
                    Text(location.district)
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                    
                    // Coordinates info
                    HStack(spacing: 4) {
                        Image(systemName: "location.fill")
                            .font(.system(size: 10))
                        Text("Lat: \(location.latitude, specifier: "%.4f"), Lng: \(location.longitude, specifier: "%.4f")")
                            .font(.system(size: 11))
                    }
                    .foregroundColor(.blue)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(6)
                }
                
                Spacer()
                
                VStack(spacing: 2) {
                    Image(systemName: "map.fill")
                        .font(.system(size: 16))
                        .foregroundColor(.blue)
                    
                    Text("Open")
                        .font(.system(size: 10, weight: .medium))
                        .foregroundColor(.blue)
                }
            }
            .padding(16)
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
        }
        .buttonStyle(PlainButtonStyle())
        .padding(.horizontal, 20)
    }
}

#Preview {
    LocationsView()
}

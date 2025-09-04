import SwiftUI
import MapKit

extension CLLocationCoordinate2D: Equatable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}

struct Service: Identifiable, Codable {
    let id = UUID()
    let category: String
    let title: String
    let description: String
    let iconName: String
    let backgroundColor: Color
    
    enum CodingKeys: String, CodingKey {
        case category, title, description, iconName
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        category = try container.decode(String.self, forKey: .category)
        title = try container.decode(String.self, forKey: .title)
        description = try container.decode(String.self, forKey: .description)
        iconName = try container.decode(String.self, forKey: .iconName)
        backgroundColor = .blue.opacity(0.3) // Default color
    }
    
    init(category: String, title: String, description: String, iconName: String, backgroundColor: Color) {
        self.category = category
        self.title = title
        self.description = description
        self.iconName = iconName
        self.backgroundColor = backgroundColor
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(category, forKey: .category)
        try container.encode(title, forKey: .title)
        try container.encode(description, forKey: .description)
        try container.encode(iconName, forKey: .iconName)
    }
}

// Home Visit Booking Request structure
struct HomeVisitBookingRequest: Codable {
    let patientId: String
    let patientName: String
    let contactNumber: String
    let services: [String]
    let visitDate: String
    let visitTime: String
    let address: String
    let city: String
    let postalCode: String
    let plusCode: String
    let latitude: Double
    let longitude: Double
    let cost: String
    let status: String
    let instructions: String
}

// Custom annotation for map pin
class CustomAnnotation: NSObject, MKAnnotation {
    let coordinate: CLLocationCoordinate2D
    let title: String?
    let subtitle: String?
    
    init(coordinate: CLLocationCoordinate2D, title: String?, subtitle: String?) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
    }
}

// Location Manager
class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    @Published var location: CLLocationCoordinate2D?
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func requestLocation() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        DispatchQueue.main.async {
            self.location = location.coordinate
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location error: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        DispatchQueue.main.async {
            self.authorizationStatus = status
            if status == .authorizedWhenInUse || status == .authorizedAlways {
                self.locationManager.requestLocation()
            }
        }
    }
}

// Map Selection View
struct MapSelectionView: View {
    @Binding var selectedLocation: CLLocationCoordinate2D?
    @Binding var selectedAddress: String
    @Binding var selectedCity: String
    @Binding var selectedPostalCode: String
    @Binding var plusCode: String
    @StateObject private var locationManager = LocationManager()
    @Environment(\.presentationMode) var presentationMode
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 6.9271, longitude: 79.8612), // Colombo default
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    @State private var annotation: CustomAnnotation?
    @State private var isLoadingAddress = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Instructions
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: "info.circle.fill")
                            .foregroundColor(.blue)
                            .font(.system(size: 16))
                        
                        Text("Tap on the map to pin your exact location")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.primary)
                        
                        Spacer()
                    }
                    
                    if isLoadingAddress {
                        HStack {
                            ProgressView()
                                .scaleEffect(0.8)
                            Text("Getting address details...")
                                .font(.system(size: 12))
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color(.systemGray6))
                
                // Map View
                MapView(
                    region: $region,
                    annotation: $annotation,
                    onTap: handleMapTap
                )
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                // Selected location info
                if let location = selectedLocation {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Image(systemName: "mappin.circle.fill")
                                .foregroundColor(.red)
                                .font(.system(size: 16))
                            
                            Text("Selected Location")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.primary)
                            
                            Spacer()
                        }
                        
                        if !selectedAddress.isEmpty {
                            Text(selectedAddress)
                                .font(.system(size: 13))
                                .foregroundColor(.secondary)
                                .lineLimit(2)
                        }
                        
                        HStack {
                            Text("Coordinates:")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.gray)
                            
                            Text("\(location.latitude, specifier: "%.6f"), \(location.longitude, specifier: "%.6f")")
                                .font(.system(size: 12))
                                .foregroundColor(.gray)
                        }
                        
                        if !plusCode.isEmpty {
                            HStack {
                                Text("Plus Code:")
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(.gray)
                                
                                Text(plusCode)
                                    .font(.system(size: 12))
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                    .padding(16)
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 16)
                }
            }
            .navigationTitle("Select Location")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Use Current Location") {
                        locationManager.requestLocation()
                    }
                    .disabled(locationManager.authorizationStatus != .authorizedWhenInUse &&
                             locationManager.authorizationStatus != .authorizedAlways)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .disabled(selectedLocation == nil)
                }
            }
        }
        .onAppear {
            if let location = selectedLocation {
                region.center = location
                annotation = CustomAnnotation(
                    coordinate: location,
                    title: "Selected Location",
                    subtitle: selectedAddress.isEmpty ? "Tap to select" : selectedAddress
                )
            }
        }
        .onChange(of: locationManager.location) { _, location in
            if let location = location {
                handleMapTap(at: location)
                region = MKCoordinateRegion(
                    center: location,
                    span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                )
            }
        }
    }
    
    private func handleMapTap(at coordinate: CLLocationCoordinate2D) {
        selectedLocation = coordinate
        annotation = CustomAnnotation(
            coordinate: coordinate,
            title: "Selected Location",
            subtitle: "Getting address..."
        )
        
        // Reverse geocoding to get address
        isLoadingAddress = true
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            DispatchQueue.main.async {
                isLoadingAddress = false
                
                if let placemark = placemarks?.first {
                    // Update address fields
                    var addressComponents: [String] = []
                    
                    if let streetNumber = placemark.subThoroughfare {
                        addressComponents.append(streetNumber)
                    }
                    if let streetName = placemark.thoroughfare {
                        addressComponents.append(streetName)
                    }
                    if let subLocality = placemark.subLocality {
                        addressComponents.append(subLocality)
                    }
                    
                    selectedAddress = addressComponents.joined(separator: " ")
                    selectedCity = placemark.locality ?? placemark.subAdministrativeArea ?? ""
                    selectedPostalCode = placemark.postalCode ?? ""
                    
                    // Generate Plus Code (simplified version)
                    plusCode = generatePlusCode(for: coordinate)
                    
                    // Update annotation subtitle
                    annotation = CustomAnnotation(
                        coordinate: coordinate,
                        title: "Selected Location",
                        subtitle: selectedAddress.isEmpty ? "Custom location" : selectedAddress
                    )
                }
            }
        }
    }
    
    // Simplified Plus Code generation (you might want to use Google's official library)
    private func generatePlusCode(for coordinate: CLLocationCoordinate2D) -> String {
        // This is a simplified version. For production, use Google's Plus Codes library
        let lat = coordinate.latitude
        let lng = coordinate.longitude
        
        // Basic encoding (this is not the actual Plus Codes algorithm)
        let latString = String(format: "%.6f", lat).replacingOccurrences(of: ".", with: "")
        let lngString = String(format: "%.6f", lng).replacingOccurrences(of: ".", with: "")
        
        let prefix = String(latString.prefix(4)) + String(lngString.prefix(4))
        return "\(prefix)+ Colombo, Sri Lanka" // Placeholder format
    }
}

// UIViewRepresentable for MapKit
struct MapView: UIViewRepresentable {
    @Binding var region: MKCoordinateRegion
    @Binding var annotation: CustomAnnotation?
    let onTap: (CLLocationCoordinate2D) -> Void
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.region = region
        mapView.mapType = .standard
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .none
        
        // Add tap gesture
        let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleTap(_:)))
        mapView.addGestureRecognizer(tapGesture)
        
        return mapView
    }
    
    func updateUIView(_ mapView: MKMapView, context: Context) {
        mapView.setRegion(region, animated: true)
        
        // Remove existing annotations
        mapView.removeAnnotations(mapView.annotations.filter { !($0 is MKUserLocation) })
        
        // Add new annotation if exists
        if let annotation = annotation {
            mapView.addAnnotation(annotation)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView
        
        init(_ parent: MapView) {
            self.parent = parent
        }
        
        @objc func handleTap(_ gesture: UITapGestureRecognizer) {
            let mapView = gesture.view as! MKMapView
            let location = gesture.location(in: mapView)
            let coordinate = mapView.convert(location, toCoordinateFrom: mapView)
            parent.onTap(coordinate)
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            guard annotation is CustomAnnotation else { return nil }
            
            let identifier = "CustomPin"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
            
            if annotationView == nil {
                annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView?.canShowCallout = true
                annotationView?.markerTintColor = .systemRed
                annotationView?.glyphImage = UIImage(systemName: "house.fill")
            } else {
                annotationView?.annotation = annotation
            }
            
            return annotationView
        }
    }
}

struct BookHomeVisitView: View {
    @State private var selectedServices: Set<UUID> = []
    @State private var selectedDate = ""
    @State private var selectedTime = ""
    @State private var streetAddress = ""
    @State private var city = ""
    @State private var postalCode = ""
    @State private var plusCode = ""
    @State private var instructions = ""
    @State private var showingDatePicker = false
    @State private var showingTimePicker = false
    @State private var showingMapSelection = false
    @State private var selectedLocation: CLLocationCoordinate2D?
    @State private var date = Date()
    @State private var isBooking = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    // Editable patient details
    @State private var editablePatientName = ""
    @State private var editableContactNumber = ""
    
    let onBackTapped: () -> Void
    
    // Patient details from UserDefaults
    private var patientId: String {
        return UserDefaults.standard.string(forKey: "id") ?? ""
    }
    
    private var storedPatientName: String {
        if let storedName = UserDefaults.standard.string(forKey: "name"), !storedName.isEmpty {
            return storedName
        }
        
        let email = UserDefaults.standard.string(forKey: "email") ?? ""
        if email.contains("@") {
            let username = String(email.split(separator: "@").first ?? "User")
            return username.replacingOccurrences(of: ".", with: " ")
                          .replacingOccurrences(of: "_", with: " ")
                          .capitalized
        }
        return email.capitalized
    }
    
    private var storedContactNumber: String {
        return UserDefaults.standard.string(forKey: "contactNumber") ?? ""
    }
    
    private let services = [
        Service(
            category: "Blood Test",
            title: "Comprehensive Blood Analysis",
            description: "Full panel blood test for overall health assessment including CBC, lipid profile, and glucose levels.",
            iconName: "testtube.2",
            backgroundColor: Color.red.opacity(0.1)
        ),
        Service(
            category: "ECG",
            title: "Electrocardiogram",
            description: "Heart activity monitoring for cardiac health assessment with detailed report.",
            iconName: "waveform.path.ecg",
            backgroundColor: Color.yellow.opacity(0.1)
        ),
        Service(
            category: "Nurse Visit",
            title: "Routine Health Check",
            description: "Basic health checkup by a registered nurse including vital signs and health consultation.",
            iconName: "stethoscope",
            backgroundColor: Color.orange.opacity(0.1)
        ),
        Service(
            category: "Physiotherapy",
            title: "Physical Therapy Session",
            description: "Professional physiotherapy session for rehabilitation and mobility improvement.",
            iconName: "figure.walk",
            backgroundColor: Color.green.opacity(0.1)
        )
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            headerView
            
            ScrollView {
                VStack(spacing: 20) {
                    patientDetailsSection
                    selectServicesSection
                    selectDateTimeSection
                    addressSection
                    instructionsSection
                    Spacer(minLength: 100)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
            }
            
            bookHomeVisitButton
        }
        .background(Color(.systemGroupedBackground))
        .onAppear {
            initializePatientDetails()
        }
        .sheet(isPresented: $showingDatePicker) {
            datePickerSheet
        }
        .sheet(isPresented: $showingTimePicker) {
            timePickerSheet
        }
        .sheet(isPresented: $showingMapSelection) {
            MapSelectionView(
                selectedLocation: $selectedLocation,
                selectedAddress: $streetAddress,
                selectedCity: $city,
                selectedPostalCode: $postalCode,
                plusCode: $plusCode
            )
        }
        .alert("Booking Status", isPresented: $showAlert) {
            Button("OK") {
                if alertMessage.contains("successfully") {
                    resetForm()
                }
            }
        } message: {
            Text(alertMessage)
        }
    }
    
    private var headerView: some View {
        HStack {
            Button(action: onBackTapped) {
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
            
            Text("Book Home Visit")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.black)
            
            Spacer()
            
            Circle()
                .fill(Color.clear)
                .frame(width: 40, height: 40)
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
        .padding(.bottom, 5)
        .background(Color(.systemGroupedBackground))
    }
    
    private var patientDetailsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Patient Information")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.black)
            
            VStack(spacing: 12) {
                patientInfoField(title: "Full Name", value: $editablePatientName, placeholder: "Enter your full name", icon: "person.fill")
                patientInfoField(title: "Contact Number", value: $editableContactNumber, placeholder: "Enter your contact number", icon: "phone.fill")
            }
            .padding(16)
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
        }
    }
    
    private func patientInfoField(title: String, value: Binding<String>, placeholder: String, icon: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(Color.blue.opacity(0.1))
                        .frame(width: 35, height: 35)
                    
                    Image(systemName: icon)
                        .font(.system(size: 14))
                        .foregroundColor(.blue)
                }
                
                Text(title)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.black)
                
                Spacer()
            }
            
            TextField(placeholder, text: value)
                .font(.system(size: 16))
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
                .background(Color(.systemGray6))
                .cornerRadius(8)
        }
    }
    
    private var selectServicesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Select Services")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.black)
                
                Spacer()
                
                if !selectedServices.isEmpty {
                    Text("\(selectedServices.count) selected")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.green)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.green.opacity(0.1))
                        .cornerRadius(8)
                }
            }
            
            VStack(spacing: 12) {
                ForEach(services) { service in
                    serviceCard(service: service)
                }
            }
        }
    }
    
    private func serviceCard(service: Service) -> some View {
        Button(action: {
            if selectedServices.contains(service.id) {
                selectedServices.remove(service.id)
            } else {
                selectedServices.insert(service.id)
            }
        }) {
            HStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(service.category)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.gray)
                    
                    Text(service.title)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.leading)
                    
                    Text(service.description)
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                }
                
                Spacer()
                
                VStack(spacing: 8) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(service.backgroundColor)
                            .frame(width: 60, height: 60)
                        
                        Image(systemName: service.iconName)
                            .font(.system(size: 20))
                            .foregroundColor(.primary)
                    }
                    
                    if selectedServices.contains(service.id) {
                        ZStack {
                            Circle()
                                .fill(Color.green)
                                .frame(width: 24, height: 24)
                            
                            Image(systemName: "checkmark")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(.white)
                        }
                    } else {
                        Circle()
                            .stroke(Color.gray.opacity(0.3), lineWidth: 2)
                            .frame(width: 24, height: 24)
                    }
                }
            }
            .padding(16)
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(selectedServices.contains(service.id) ? Color.green : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var selectDateTimeSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Select Date & Time")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.black)
            
            VStack(spacing: 12) {
                datePickerButton
                timePickerButton
            }
        }
    }
    
    private var datePickerButton: some View {
        Button(action: {
            showingDatePicker = true
        }) {
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(Color.orange.opacity(0.1))
                        .frame(width: 35, height: 35)
                    
                    Image(systemName: "calendar")
                        .font(.system(size: 14))
                        .foregroundColor(.orange)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Visit Date")
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                    
                    Text(selectedDate.isEmpty ? "Select Date" : selectedDate)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(selectedDate.isEmpty ? .gray : .black)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
            }
            .padding(16)
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
        }
    }
    
    private var timePickerButton: some View {
        Button(action: {
            showingTimePicker = true
        }) {
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(Color.purple.opacity(0.1))
                        .frame(width: 35, height: 35)
                    
                    Image(systemName: "clock")
                        .font(.system(size: 14))
                        .foregroundColor(.purple)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Visit Time")
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                    
                    Text(selectedTime.isEmpty ? "Select Time" : selectedTime)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(selectedTime.isEmpty ? .gray : .black)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
            }
            .padding(16)
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
        }
    }
    
    private var addressSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Service Address")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.black)
            
            VStack(spacing: 12) {
                // Map Selection Button
                Button(action: {
                    showingMapSelection = true
                }) {
                    HStack(spacing: 12) {
                        ZStack {
                            Circle()
                                .fill(Color.red.opacity(0.1))
                                .frame(width: 35, height: 35)
                            
                            Image(systemName: "map.fill")
                                .font(.system(size: 14))
                                .foregroundColor(.red)
                        }
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Pin Location on Map")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.black)
                            
                            Text(selectedLocation != nil ? "Location selected" : "Tap to select exact location")
                                .font(.system(size: 12))
                                .foregroundColor(selectedLocation != nil ? .green : .gray)
                        }
                        
                        Spacer()
                        
                        if selectedLocation != nil {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                                .font(.system(size: 16))
                        } else {
                            Image(systemName: "chevron.right")
                                .font(.system(size: 12))
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(16)
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(selectedLocation != nil ? Color.green : Color.clear, lineWidth: 2)
                    )
                }
                .buttonStyle(PlainButtonStyle())
                
                addressField(title: "Address", value: $streetAddress, placeholder: "Enter your address", icon: "house.fill")
                
                HStack(spacing: 12) {
                    VStack {
                        addressField(title: "City", value: $city, placeholder: "Enter city", icon: "building.2.fill")
                    }
                    
                    VStack {
                        addressField(title: "Postal Code", value: $postalCode, placeholder: "Enter postal code", icon: "map.fill")
                    }
                }
                
                if !plusCode.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack(spacing: 12) {
                            ZStack {
                                Circle()
                                    .fill(Color.blue.opacity(0.1))
                                    .frame(width: 30, height: 30)
                                
                                Image(systemName: "location.circle.fill")
                                    .font(.system(size: 12))
                                    .foregroundColor(.blue)
                            }
                            
                            Text("Plus Code (Auto-generated)")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.black)
                            
                            Spacer()
                        }
                        
                        Text(plusCode)
                            .font(.system(size: 14))
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                            .foregroundColor(.blue)
                    }
                }
            }
            .padding(16)
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
        }
    }
    
    private func addressField(title: String, value: Binding<String>, placeholder: String, icon: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(Color.green.opacity(0.1))
                        .frame(width: 30, height: 30)
                    
                    Image(systemName: icon)
                        .font(.system(size: 12))
                        .foregroundColor(.green)
                }
                
                Text(title)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.black)
                
                Spacer()
            }
            
            TextField(placeholder, text: value)
                .font(.system(size: 14))
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color(.systemGray6))
                .cornerRadius(8)
        }
    }
    
    private var instructionsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Special Instructions (Optional)")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.black)
            
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(Color.blue.opacity(0.1))
                            .frame(width: 35, height: 35)
                        
                        Image(systemName: "note.text")
                            .font(.system(size: 14))
                            .foregroundColor(.blue)
                    }
                    
                    Text("Additional Information")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.black)
                    
                    Spacer()
                }
                
                TextField("Any special requirements or notes for the healthcare provider...", text: $instructions, axis: .vertical)
                    .font(.system(size: 14))
                    .padding(.horizontal, 12)
                    .padding(.vertical, 10)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .lineLimit(3...6)
            }
            .padding(16)
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
        }
    }
    
    private var bookHomeVisitButton: some View {
        Button(action: bookHomeVisit) {
            HStack {
                if isBooking {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(0.8)
                } else if isBookingEnabled {
                    Image(systemName: "house.badge.plus")
                        .font(.system(size: 16, weight: .semibold))
                }
                
                Text(isBooking ? "Booking..." : "Confirm Home Visit")
                    .font(.system(size: 18, weight: .semibold))
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: isBookingEnabled && !isBooking ? [Color.green, Color.green.opacity(0.8)] : [Color.gray, Color.gray.opacity(0.8)]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(16)
        }
        .disabled(!isBookingEnabled || isBooking)
        .padding(.horizontal, 20)
        .padding(.bottom, 30)
    }
    
    private var datePickerSheet: some View {
        NavigationView {
            VStack {
                DatePicker("Select Date", selection: $date, in: Date()..., displayedComponents: .date)
                    .datePickerStyle(WheelDatePickerStyle())
                    .padding()
                
                Spacer()
            }
            .navigationTitle("Select Visit Date")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        let formatter = DateFormatter()
                        formatter.dateFormat = "yyyy-MM-dd"
                        selectedDate = formatter.string(from: date)
                        showingDatePicker = false
                    }
                }
            }
        }
        .presentationDetents([.medium])
    }
    
    private var timePickerSheet: some View {
        NavigationView {
            VStack {
                DatePicker("Select Time", selection: $date, displayedComponents: .hourAndMinute)
                    .datePickerStyle(WheelDatePickerStyle())
                    .padding()
                
                Spacer()
            }
            .navigationTitle("Select Visit Time")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        let formatter = DateFormatter()
                        formatter.dateFormat = "HH:mm"
                        selectedTime = formatter.string(from: date)
                        showingTimePicker = false
                    }
                }
            }
        }
        .presentationDetents([.medium])
    }
    
    private var isBookingEnabled: Bool {
        return !selectedServices.isEmpty &&
               !selectedDate.isEmpty &&
               !selectedTime.isEmpty &&
               !editablePatientName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
               !editableContactNumber.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
               !streetAddress.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
               !city.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
               !postalCode.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
               selectedLocation != nil
    }
    
    private func initializePatientDetails() {
        editablePatientName = storedPatientName
        editableContactNumber = storedContactNumber
    }
    
    private func resetForm() {
        selectedServices.removeAll()
        selectedDate = ""
        selectedTime = ""
        streetAddress = ""
        city = ""
        postalCode = ""
        plusCode = ""
        instructions = ""
        selectedLocation = nil
    }
    
    private func getSelectedServiceNames() -> [String] {
        return services.filter { selectedServices.contains($0.id) }
                      .map { $0.title }
    }
    
    private func prepareHomeVisitData() -> HomeVisitBookingRequest {
        return HomeVisitBookingRequest(
            patientId: patientId,
            patientName: editablePatientName.trimmingCharacters(in: .whitespacesAndNewlines),
            contactNumber: editableContactNumber.trimmingCharacters(in: .whitespacesAndNewlines),
            services: getSelectedServiceNames(),
            visitDate: selectedDate,
            visitTime: selectedTime,
            address: streetAddress.trimmingCharacters(in: .whitespacesAndNewlines),
            city: city.trimmingCharacters(in: .whitespacesAndNewlines),
            postalCode: postalCode.trimmingCharacters(in: .whitespacesAndNewlines),
            plusCode: plusCode.trimmingCharacters(in: .whitespacesAndNewlines),
            latitude: selectedLocation?.latitude ?? 0.0,
            longitude: selectedLocation?.longitude ?? 0.0,
            cost: "0",
            status: "Pending",
            instructions: instructions.trimmingCharacters(in: .whitespacesAndNewlines)
        )
    }
    
    
    private func bookHomeVisit() {
        guard let url = URL(string: "https://mediaccess.vercel.app/api/home-visit/add") else {
            alertMessage = "Invalid API endpoint"
            showAlert = true
            return
        }
        
        let homeVisitData = prepareHomeVisitData()
        
        isBooking = true
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData = try JSONEncoder().encode(homeVisitData)
            request.httpBody = jsonData
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                DispatchQueue.main.async {
                    isBooking = false
                    
                    if let error = error {
                        alertMessage = "Network error: \(error.localizedDescription)"
                        showAlert = true
                        return
                    }
                    
                    if let httpResponse = response as? HTTPURLResponse {
                        if httpResponse.statusCode == 200 || httpResponse.statusCode == 201 {
                            let servicesList = getSelectedServiceNames().joined(separator: ", ")
                            let locationInfo = selectedLocation != nil ? "\nLocation: \(String(format: "%.6f", selectedLocation!.latitude)), \(String(format: "%.6f", selectedLocation!.longitude))" : ""
                            let plusCodeInfo = !plusCode.isEmpty ? "\nPlus Code: \(plusCode)" : ""
                            
                            alertMessage = "🏠 Home Visit successfully booked!\n\nServices: \(servicesList)\nDate: \(selectedDate)\nTime: \(selectedTime)\nAddress: \(streetAddress), \(city)\(locationInfo)\(plusCodeInfo)\n\nYou will receive a confirmation call shortly."
                            showAlert = true
                            
                            // Update UserDefaults with the latest patient info
                            UserDefaults.standard.set(editablePatientName, forKey: "name")
                            UserDefaults.standard.set(editableContactNumber, forKey: "contactNumber")
                            
                        } else {
                            if let data = data,
                               let errorMessage = String(data: data, encoding: .utf8) {
                                alertMessage = "Booking failed: \(errorMessage)"
                            } else {
                                alertMessage = "Booking failed with status code: \(httpResponse.statusCode)"
                            }
                            showAlert = true
                        }
                    } else {
                        alertMessage = "Invalid response from server"
                        showAlert = true
                    }
                }
            }.resume()
            
        } catch {
            isBooking = false
            alertMessage = "Failed to prepare home visit data: \(error.localizedDescription)"
            showAlert = true
        }
    }
}


struct BookHomeVisitView_Previews: PreviewProvider {
    static var previews: some View {
        BookHomeVisitView(onBackTapped: {})
    }
}

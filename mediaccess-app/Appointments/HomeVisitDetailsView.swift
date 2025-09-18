import SwiftUI
import MapKit
import EventKit

struct HomeVisitDetailsView: View {
    let homeVisit: HomevisitDetail
    let onBackTapped: () -> Void
    
    @State private var showCalendarAlert = false
    @State private var showCancelAlert = false
    @State private var showRescheduleAlert = false
    @State private var showMapView = false
    @State private var showSuccessAlert = false
    @State private var showErrorAlert = false
    @State private var errorMessage = ""
    
    var body: some View {
        VStack(spacing: 0) {
            headerView
            
            ScrollView {
                VStack(spacing: 24) {
                    homeVisitOverviewCard
                    patientInformationCard
                    visitDetailsCard
                    servicesCard
                    statusCard
                    actionButtonsSection
                    Spacer(minLength: 100)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
            }
        }
        .background(Color(.systemGroupedBackground))
        .alert("Add to Calendar", isPresented: $showCalendarAlert) {
            Button("Add") {
                addToCalendar()
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Would you like to add this home visit to your calendar?")
        }
        .alert("Cancel Home Visit", isPresented: $showCancelAlert) {
            Button("Cancel Visit", role: .destructive) {
                cancelHomeVisit()
            }
            Button("Keep Visit", role: .cancel) { }
        } message: {
            Text("Are you sure you want to cancel this home visit? This action cannot be undone.")
        }
        .alert("Reschedule Home Visit", isPresented: $showRescheduleAlert) {
            Button("Reschedule") {
                rescheduleHomeVisit()
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Would you like to reschedule this home visit?")
        }
        .alert("Success", isPresented: $showSuccessAlert) {
            Button("OK") { }
        } message: {
            Text("Home visit has been added to your calendar successfully!")
        }
        .alert("Error", isPresented: $showErrorAlert) {
            Button("OK") { }
        } message: {
            Text("Failed to add home visit to calendar: \(errorMessage)")
        }
        .sheet(isPresented: $showMapView) {
            ViewMapView(homeVisit: homeVisit)
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
            
            Text("Home Visit Details")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.black)
            
            Spacer()
            
            Button(action: shareHomeVisit) {
                ZStack {
                    Circle()
                        .fill(Color.white)
                        .frame(width: 40, height: 40)
                        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
                    
                    Image(systemName: "square.and.arrow.up")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.black)
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
        .padding(.bottom, 5)
        .background(Color(.systemGroupedBackground))
    }
    
    private var homeVisitOverviewCard: some View {
        VStack(spacing: 16) {
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(Color.green.opacity(0.1))
                        .frame(width: 70, height: 70)
                    
                    Image(systemName: "house.fill")
                        .font(.system(size: 30))
                        .foregroundColor(.green)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(homeVisit.title)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.black)
                        .lineLimit(2)
                    
                    Text(homeVisit.address)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.gray)
                        .lineLimit(2)
                    
                    HStack(spacing: 8) {
                        HStack(spacing: 4) {
                            Image(systemName: "calendar")
                                .font(.system(size: 12))
                            Text(homeVisit.visitDate)
                                .font(.system(size: 14, weight: .medium))
                        }
                        
                        HStack(spacing: 4) {
                            Image(systemName: "clock")
                                .font(.system(size: 12))
                            Text(homeVisit.visitTime)
                                .font(.system(size: 14, weight: .medium))
                        }
                    }
                    .foregroundColor(.green)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.green.opacity(0.1))
                    .cornerRadius(6)
                }
                
                Spacer()
            }
        }
        .padding(20)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 2)
    }
    
    private var patientInformationCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Patient Information")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.black)
            
            VStack(spacing: 12) {
                patientDetailRow(
                    icon: "person.fill",
                    iconColor: .green,
                    title: "Patient Name",
                    value: homeVisit.patientName
                )
                
                patientDetailRow(
                    icon: "phone.fill",
                    iconColor: .blue,
                    title: "Contact Number",
                    value: homeVisit.contactNumber
                )
                
                patientDetailRow(
                    icon: "number.circle.fill",
                    iconColor: .purple,
                    title: "Patient ID",
                    value: homeVisit.patientId
                )
                
                patientDetailRow(
                    icon: "mappin.circle.fill",
                    iconColor: .red,
                    title: "City",
                    value: homeVisit.city
                )
            }
        }
        .padding(20)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 2)
    }
    
    private func patientDetailRow(icon: String, iconColor: Color, title: String, value: String) -> some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(iconColor.opacity(0.1))
                    .frame(width: 35, height: 35)
                
                Image(systemName: icon)
                    .font(.system(size: 14))
                    .foregroundColor(iconColor)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
                
                Text(value.isEmpty ? "Not provided" : value)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(value.isEmpty ? .gray.opacity(0.6) : .black)
            }
            
            Spacer()
        }
    }
    
    private var visitDetailsCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Visit Details")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.black)
            
            VStack(spacing: 12) {
                visitDetailRow(
                    icon: "calendar.badge.clock",
                    iconColor: .orange,
                    title: "Visit Date",
                    value: homeVisit.visitDate
                )
                
                visitDetailRow(
                    icon: "clock.fill",
                    iconColor: .purple,
                    title: "Visit Time",
                    value: homeVisit.visitTime
                )
                
                visitDetailRow(
                    icon: "location.fill",
                    iconColor: .red,
                    title: "Address",
                    value: homeVisit.address
                )
                
                if !homeVisit.plusCode.isEmpty {
                    visitDetailRow(
                        icon: "plus.square.fill",
                        iconColor: .blue,
                        title: "Plus Code",
                        value: homeVisit.plusCode
                    )
                }
                
                Button(action: {
                    showMapView = true
                }) {
                    HStack(spacing: 12) {
                        ZStack {
                            Circle()
                                .fill(Color.green.opacity(0.1))
                                .frame(width: 35, height: 35)
                            
                            Image(systemName: "map.fill")
                                .font(.system(size: 14))
                                .foregroundColor(.green)
                        }
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("View on Map")
                                .font(.system(size: 12))
                                .foregroundColor(.gray)
                            
                            Text("Open location")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.green)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .font(.system(size: 12))
                            .foregroundColor(.green)
                    }
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding(20)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 2)
    }
    
    private func visitDetailRow(icon: String, iconColor: Color, title: String, value: String) -> some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(iconColor.opacity(0.1))
                    .frame(width: 35, height: 35)
                
                Image(systemName: icon)
                    .font(.system(size: 14))
                    .foregroundColor(iconColor)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
                
                Text(value)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.black)
            }
            
            Spacer()
        }
    }
    
    private var servicesCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Services")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.black)
                
                Spacer()
                
                Text("LKR \(homeVisit.cost)")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.green)
            }
            
            VStack(spacing: 12) {
                ForEach(homeVisit.services, id: \.self) { service in
                    HStack(spacing: 12) {
                        ZStack {
                            Circle()
                                .fill(Color.blue.opacity(0.1))
                                .frame(width: 35, height: 35)
                            
                            Image(systemName: serviceIcon(for: service))
                                .font(.system(size: 14))
                                .foregroundColor(.blue)
                        }
                        
                        Text(service)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.black)
                        
                        Spacer()
                    }
                }
                
                if !homeVisit.instructions.isEmpty {
                    Divider()
                        .padding(.vertical, 4)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Image(systemName: "info.circle.fill")
                                .font(.system(size: 14))
                                .foregroundColor(.blue)
                            
                            Text("Instructions")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.black)
                        }
                        
                        Text(homeVisit.instructions)
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                            .lineSpacing(2)
                    }
                    .padding(.top, 4)
                }
            }
        }
        .padding(20)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 2)
    }
    
    private var statusCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Status & Timeline")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.black)
            
            VStack(spacing: 12) {
                HStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(statusColor.opacity(0.1))
                            .frame(width: 35, height: 35)
                        
                        Image(systemName: statusIcon)
                            .font(.system(size: 14))
                            .foregroundColor(statusColor)
                    }
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Current Status")
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                        
                        Text(homeVisit.status.capitalized)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(statusColor)
                    }
                    
                    Spacer()
                    
                    statusBadge
                }
                
                Divider()
                    .padding(.vertical, 4)
                
                timelineRow(
                    icon: "plus.circle.fill",
                    iconColor: .green,
                    title: "Created",
                    value: "\(homeVisit.createdDate) at \(homeVisit.createdTime)"
                )
            }
        }
        .padding(20)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 2)
    }
    
    private func timelineRow(icon: String, iconColor: Color, title: String, value: String) -> some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(iconColor.opacity(0.1))
                    .frame(width: 25, height: 25)
                
                Image(systemName: icon)
                    .font(.system(size: 12))
                    .foregroundColor(iconColor)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
                
                Text(value)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.black)
            }
            
            Spacer()
        }
    }
    
    private var statusBadge: some View {
        Text(homeVisit.status.uppercased())
            .font(.system(size: 10, weight: .bold))
            .foregroundColor(statusColor)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(statusColor.opacity(0.1))
            .cornerRadius(8)
    }
    
    private var statusColor: Color {
        switch homeVisit.status.lowercased() {
        case "confirmed":
            return .green
        case "pending":
            return .orange
        case "cancelled":
            return .red
        case "completed":
            return .blue
        default:
            return .gray
        }
    }
    
    private var statusIcon: String {
        switch homeVisit.status.lowercased() {
        case "confirmed":
            return "checkmark.circle.fill"
        case "pending":
            return "clock.fill"
        case "cancelled":
            return "xmark.circle.fill"
        case "completed":
            return "checkmark.seal.fill"
        default:
            return "questionmark.circle.fill"
        }
    }
    
    private var actionButtonsSection: some View {
        VStack(spacing: 12) {
            primaryActionButton
//            secondaryActionButtons
        }
    }
    
    private var primaryActionButton: some View {
        Button(action: {
            showCalendarAlert = true
        }) {
            HStack(spacing: 12) {
                Image(systemName: "calendar.badge.plus")
                    .font(.system(size: 16, weight: .semibold))
                
                Text("Add to Calendar")
                    .font(.system(size: 16, weight: .semibold))
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [Color.green, Color.green.opacity(0.8)]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(16)
        }
    }
    
    private var secondaryActionButtons: some View {
        HStack(spacing: 12) {
            Button(action: {
                showRescheduleAlert = true
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "clock.arrow.circlepath")
                        .font(.system(size: 14, weight: .medium))
                    
                    Text("Reschedule")
                        .font(.system(size: 14, weight: .medium))
                }
                .foregroundColor(.orange)
                .frame(maxWidth: .infinity)
                .frame(height: 48)
                .background(Color.orange.opacity(0.1))
                .cornerRadius(12)
            }
            
            Button(action: {
                showCancelAlert = true
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "xmark.circle")
                        .font(.system(size: 14, weight: .medium))
                    
                    Text("Cancel")
                        .font(.system(size: 14, weight: .medium))
                }
                .foregroundColor(.red)
                .frame(maxWidth: .infinity)
                .frame(height: 48)
                .background(Color.red.opacity(0.1))
                .cornerRadius(12)
            }
        }
    }
    
    private func serviceIcon(for service: String) -> String {
        switch service.lowercased() {
        case "blood test":
            return "drop.fill"
        case "ecg":
            return "heart.fill"
        case "nurse visit":
            return "person.fill.badge.plus"
        case "vaccination":
            return "syringe.fill"
        case "physiotherapy":
            return "figure.walk"
        default:
            return "stethoscope"
        }
    }
    
    // This function asks permission to add events to the phone's calendar
    private func addToCalendar() {
        let eventStore = EKEventStore()
        
        eventStore.requestAccess(to: .event) { granted, error in
            DispatchQueue.main.async {
                if granted && error == nil {
                    self.createCalendarEvent(eventStore: eventStore)
                } else {
                    self.displayErrorAlert(message: error?.localizedDescription ?? "Calendar access denied")
                }
            }
        }
    }
    
    // This function creates a new event in the phone's calendar
    private func createCalendarEvent(eventStore: EKEventStore) {
        let event = EKEvent(eventStore: eventStore)
        
        event.title = "🏠 \(homeVisit.title)"
        event.notes = """
        Patient: \(homeVisit.patientName)
        Services: \(homeVisit.services.joined(separator: ", "))
        Address: \(homeVisit.address)
        City: \(homeVisit.city)
        Contact: \(homeVisit.contactNumber)
        Cost: LKR \(homeVisit.cost)
        Patient ID: \(homeVisit.patientId)
        Status: \(homeVisit.status.capitalized)
        
        Instructions: \(homeVisit.instructions.isEmpty ? "None" : homeVisit.instructions)
        """
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm" 
        
        guard let visitDate = dateFormatter.date(from: homeVisit.visitDate),
              let visitTime = timeFormatter.date(from: homeVisit.visitTime) else {
            displayErrorAlert(message: "Failed to parse visit date or time")
            return
        }
        
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: visitDate)
        let timeComponents = calendar.dateComponents([.hour, .minute], from: visitTime)
        
        var combinedComponents = DateComponents()
        combinedComponents.year = dateComponents.year
        combinedComponents.month = dateComponents.month
        combinedComponents.day = dateComponents.day
        combinedComponents.hour = timeComponents.hour
        combinedComponents.minute = timeComponents.minute
        
        guard let startDate = calendar.date(from: combinedComponents) else {
            displayErrorAlert(message: "Failed to create start date")
            return
        }
        
        event.startDate = startDate
        event.endDate = startDate.addingTimeInterval(7200)
        
        event.calendar = eventStore.defaultCalendarForNewEvents
        
        let structuredLocation = EKStructuredLocation(title: homeVisit.address)
        structuredLocation.geoLocation = CLLocation(
            latitude: homeVisit.latitude,
            longitude: homeVisit.longitude
        )
        event.structuredLocation = structuredLocation
        
        let alarm = EKAlarm(relativeOffset: -30 * 60)
        event.addAlarm(alarm)
        
        do {
            try eventStore.save(event, span: .thisEvent)
            displaySuccessAlert()
        } catch {
            displayErrorAlert(message: error.localizedDescription)
        }
    }
    
    private func displaySuccessAlert() {
        showSuccessAlert = true
    }
    
    private func displayErrorAlert(message: String) {
        errorMessage = message
        showErrorAlert = true
    }
    
    private func rescheduleHomeVisit() {
        print("Rescheduling home visit: \(homeVisit.id)")
    }
    
    private func cancelHomeVisit() {
        print("Cancelling home visit: \(homeVisit.id)")
    }
    
    private func shareHomeVisit() {
        let shareText = """
        🏠 Home Visit Details
        
        Patient: \(homeVisit.patientName)
        Services: \(homeVisit.services.joined(separator: ", "))
        Date: \(homeVisit.visitDate)
        Time: \(homeVisit.visitTime)
        Address: \(homeVisit.address)
        Cost: LKR \(homeVisit.cost)
        Status: \(homeVisit.status.capitalized)
        
        Visit ID: \(homeVisit.id)
        """
        
        let activityViewController = UIActivityViewController(
            activityItems: [shareText],
            applicationActivities: nil
        )
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController?.present(activityViewController, animated: true, completion: nil)
        }
    }
}

struct ViewMapView: View {
    let homeVisit: HomevisitDetail
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            Map(coordinateRegion: .constant(
                MKCoordinateRegion(
                    center: CLLocationCoordinate2D(
                        latitude: Double(homeVisit.latitude) ?? 0.0,
                        longitude: Double(homeVisit.longitude) ?? 0.0
                    ),
                    span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                )
            ), annotationItems: [homeVisit]) { visit in
                MapPin(coordinate: CLLocationCoordinate2D(
                    latitude: Double(visit.latitude) ?? 0.0,
                    longitude: Double(visit.longitude) ?? 0.0
                ), tint: .green)
            }
            .navigationTitle("Visit Location")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct HomeVisitDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        HomeVisitDetailsView(
            homeVisit: HomevisitDetail(
                address: "123 Health St, Apt 4B",
                city: "Colombo",
                contactNumber: "+94771234567",
                cost: "5000",
                createdDate: "2024-12-20",
                createdTime: "14:30",
                instructions: "Please ensure the patient is ready for the blood test.",
                latitude: 6.9271,
                longitude: 79.8612,
                patientId: "PAT001",
                patientName: "John Doe",
                plusCode: "7C4X+2G Colombo",
                services: ["Blood Test", "ECG"],
                status: "confirmed",
                visitDate: "2024-12-25",
                visitTime: "10:00"
            ),
            onBackTapped: {}
        )
    }
}

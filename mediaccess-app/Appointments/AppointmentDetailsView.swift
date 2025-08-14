import SwiftUI
import MapKit

struct AppointmentDetailsView: View {
    let appointment: AppointmentDetail
    let onBackTapped: () -> Void
    
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )
    
    @State private var showCalendarAlert = false
    @State private var showCancelAlert = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Button(action: {
                    onBackTapped()
                }) {
                    Image(systemName: "arrow.left")
                        .font(.title2)
                        .foregroundColor(.black)
                }
                
                Spacer()
                
                Text("Appointment Details")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.black)
                
                Spacer()
                
                // Invisible button for balance
                Button(action: {}) {
                    Image(systemName: "arrow.left")
                        .font(.title2)
                        .opacity(0)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 10)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Appointment Section
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Appointment")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.black)
                        
                        HStack(spacing: 12) {
                            Image(systemName: "calendar")
                                .font(.system(size: 20))
                                .foregroundColor(.blue)
                                .frame(width: 24, height: 24)
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text(appointment.title)
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.black)
                                
                                Text(appointment.doctor)
                                    .font(.system(size: 14))
                                    .foregroundColor(.gray)
                            }
                            
                            Spacer()
                        }
                    }
                    
                    // Location Section
                    VStack(alignment: .leading, spacing: 16) {
                        HStack(spacing: 12) {
                            Image(systemName: "location")
                                .font(.system(size: 20))
                                .foregroundColor(.blue)
                                .frame(width: 24, height: 24)
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Location")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.black)
                                
                                Text(appointment.location)
                                    .font(.system(size: 14))
                                    .foregroundColor(.gray)
                            }
                            
                            Spacer()
                        }
                        
                        // Map View
                        Map(coordinateRegion: $region, annotationItems: [appointment]) { location in
                            MapPin(coordinate: location.coordinate, tint: .blue)
                        }
                        .frame(height: 200)
                        .cornerRadius(12)
                        .onAppear {
                            region = MKCoordinateRegion(
                                center: appointment.coordinate,
                                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                            )
                        }
                    }
                    
                    // Instructions Section
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Instructions")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.black)
                        
                        Text(appointment.instructions)
                            .font(.system(size: 15))
                            .foregroundColor(.black)
                            .lineSpacing(4)
                    }
                    
                    // Action Buttons
                    VStack(spacing: 12) {
                        Button(action: {
                            showCalendarAlert = true
                        }) {
                            Text("Add to Calendar")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                                .background(Color.blue)
                                .cornerRadius(12)
                        }
                        
                        Button(action: {
                            showCancelAlert = true
                        }) {
                            Text("Cancel")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(12)
                        }
                    }
                    
                    Spacer(minLength: 100)
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
            }
        }
        .background(Color.white)
        .alert("Add to Calendar", isPresented: $showCalendarAlert) {
            Button("Add") {
                addToCalendar()
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Would you like to add this appointment to your calendar?")
        }
        .alert("Cancel Appointment", isPresented: $showCancelAlert) {
            Button("Cancel Appointment", role: .destructive) {
                cancelAppointment()
            }
            Button("Keep Appointment", role: .cancel) { }
        } message: {
            Text("Are you sure you want to cancel this appointment?")
        }
    }
    
    private func addToCalendar() {
        // Implement calendar integration here
        print("Adding appointment to calendar: \(appointment.title)")
    }
    
    private func cancelAppointment() {
        // Implement appointment cancellation here
        print("Cancelling appointment: \(appointment.title)")
    }
}

// MARK: - Supporting Models
struct AppointmentDetail: Identifiable {
    let id = UUID()
    let title: String
    let doctor: String
    let location: String
    let coordinate: CLLocationCoordinate2D
    let instructions: String
    let dateTime: String
}

extension AppointmentDetail {
    static let sampleData = [
        AppointmentDetail(
            title: "General Checkup",
            doctor: "Dr. Amelia Harper",
            location: "123 Health Clinic, 456 Wellness Ave",
            coordinate: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
            instructions: "Please arrive 15 minutes early for registration. Bring your insurance card and a list of current medications.",
            dateTime: "10:00 AM"
        ),
        AppointmentDetail(
            title: "Cardiology Checkup",
            doctor: "Dr. Michael Chen",
            location: "456 Heart Center, 789 Medical Plaza",
            coordinate: CLLocationCoordinate2D(latitude: 37.7849, longitude: -122.4094),
            instructions: "Please fast for 12 hours before the appointment. Bring previous test results if available.",
            dateTime: "2:30 PM"
        ),
        AppointmentDetail(
            title: "Rehabilitation Session",
            doctor: "Physical Therapy",
            location: "789 Wellness Center, 123 Therapy Street",
            coordinate: CLLocationCoordinate2D(latitude: 37.7649, longitude: -122.4294),
            instructions: "Please wear comfortable workout clothes and bring a water bottle. Arrive 10 minutes early.",
            dateTime: "11:30 AM"
        )
    ]
}

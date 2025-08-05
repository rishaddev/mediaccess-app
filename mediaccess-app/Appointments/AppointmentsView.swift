import SwiftUI

struct AppointmentsView: View {
    let onBookAppointment: () -> Void
    let onBookHomeVisit: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            Text("Appointments")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.black)
                .padding(.top, 20)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Booking Options
                    VStack(spacing: 12) {
                        Button(action: {
                            onBookAppointment()
                        }) {
                            Text("Book In-Hospital Consultation")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                                .background(Color.blue)
                                .cornerRadius(12)
                        }
                        
                        Button(action: {
                            onBookHomeVisit()
                        }) {
                            Text("Book Home Visit")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(12)
                        }
                    }
                    
                    // Upcoming Appointments
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Upcoming Appointments")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.black)
                        
                        VStack(spacing: 12) {
                            AppointmentCard(
                                title: "General Consultation",
                                doctor: "Dr. Emily Carter",
                                time: "10:00 AM"
                            )
                            
                            AppointmentCard(
                                title: "Cardiology Checkup",
                                doctor: "Dr. Michael Chen",
                                time: "2:30 PM"
                            )
                            
                            AppointmentCard(
                                title: "Rehabilitation Session",
                                doctor: "Physical Therapy",
                                time: "11:30 AM"
                            )
                        }
                    }
                    
                    // Home Visits
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Home Visits")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.black)
                        
                        AppointmentCard(
                            title: "Nurse Visit",
                            doctor: "10 Aug 2025 | 10:00 AM",
                            time: ""
                        )
                    }
                    
                    Spacer(minLength: 100)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
    }
}


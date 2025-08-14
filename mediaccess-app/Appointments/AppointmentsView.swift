import SwiftUI
import MapKit

struct AppointmentsView: View {
    let onBookAppointment: () -> Void
    let onBookHomeVisit: () -> Void
    
    @State private var selectedAppointment: AppointmentDetail?
    @State private var selectedHomeVisit: HomeVisitDetail?
    @State private var showAppointmentDetails = false
    @State private var showHomeVisitDetails = false
    
    var body: some View {
        ZStack {
            // Main Appointments List
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
                                ForEach(AppointmentDetail.sampleData.prefix(3), id: \.id) { appointment in
                                    // Inline appointment card
                                    Button(action: {
                                        selectedAppointment = appointment
                                        withAnimation(.easeInOut(duration: 0.3)) {
                                            showAppointmentDetails = true
                                        }
                                    }) {
                                        HStack(spacing: 12) {
                                            VStack(alignment: .leading, spacing: 4) {
                                                Text(appointment.title)
                                                    .font(.system(size: 16, weight: .medium))
                                                    .foregroundColor(.black)
                                                
                                                Text(appointment.doctor)
                                                    .font(.system(size: 14))
                                                    .foregroundColor(.gray)
                                            }
                                            
                                            Spacer()
                                            
                                            if !appointment.dateTime.isEmpty {
                                                Text(appointment.dateTime)
                                                    .font(.system(size: 14, weight: .medium))
                                                    .foregroundColor(.blue)
                                            }
                                            
                                            Image(systemName: "chevron.right")
                                                .font(.system(size: 14))
                                                .foregroundColor(.gray)
                                        }
                                        .padding(16)
                                        .background(Color.gray.opacity(0.05))
                                        .cornerRadius(12)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                        }
                        
                        // Home Visits
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Home Visits")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(.black)
                            
                            VStack(spacing: 12) {
                                ForEach(HomeVisitDetail.sampleData, id: \.id) { homeVisit in
                                    // Inline home visit card
                                    Button(action: {
                                        selectedHomeVisit = homeVisit
                                        withAnimation(.easeInOut(duration: 0.3)) {
                                            showHomeVisitDetails = true
                                        }
                                    }) {
                                        HStack(spacing: 12) {
                                            VStack(alignment: .leading, spacing: 4) {
                                                Text(homeVisit.title)
                                                    .font(.system(size: 16, weight: .medium))
                                                    .foregroundColor(.black)
                                                
                                                Text(homeVisit.dateTime)
                                                    .font(.system(size: 14))
                                                    .foregroundColor(.gray)
                                            }
                                            
                                            Spacer()
                                            
                                            Image(systemName: "chevron.right")
                                                .font(.system(size: 14))
                                                .foregroundColor(.gray)
                                        }
                                        .padding(16)
                                        .background(Color.gray.opacity(0.05))
                                        .cornerRadius(12)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                        }
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.white)
            .opacity(showAppointmentDetails || showHomeVisitDetails ? 0 : 1)
            
            // Appointment Details Overlay
            if showAppointmentDetails, let appointment = selectedAppointment {
                AppointmentDetailsView(
                    appointment: appointment,
                    onBackTapped: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            showAppointmentDetails = false
                        }
                    }
                )
                .transition(.move(edge: .trailing))
            }
            
            // Home Visit Details Overlay
            if showHomeVisitDetails, let homeVisit = selectedHomeVisit {
                HomeVisitDetailsView(
                    homeVisit: homeVisit,
                    onBackTapped: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            showHomeVisitDetails = false
                        }
                    }
                )
                .transition(.move(edge: .trailing))
            }
        }
    }
}

struct AppointmentsView_Previews: PreviewProvider {
    static var previews: some View {
        AppointmentsView(
            onBookAppointment: {},
            onBookHomeVisit: {}
        )
    }
}

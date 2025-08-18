import SwiftUI
import MapKit

struct AppointmentsView: View {
    let onBookAppointment: () -> Void
    let onBookHomeVisit: () -> Void
    
    @State private var selectedAppointment: AppointmentDetail?
    @State private var selectedHomeVisit: HomeVisitDetail?
    @State private var showAppointmentDetails = false
    @State private var showHomeVisitDetails = false
    
    private var userEmail: String {
        return UserDefaults.standard.string(forKey: "userEmail") ?? "User"
    }
    
    private var displayName: String {
        if let storedName = UserDefaults.standard.string(forKey: "userName"), !storedName.isEmpty {
            return storedName
        }
        
        let email = userEmail
        if email.contains("@") {
            let username = String(email.split(separator: "@").first ?? "User")
            return username.replacingOccurrences(of: ".", with: " ")
                .replacingOccurrences(of: "_", with: " ")
                .capitalized
        }
        return email.capitalized
    }
    
    var body: some View {
        ZStack {
            // Main Appointments List
            VStack(spacing: 0) {
                // Header with Profile
                HStack {
                    // Profile Image
                    AsyncImage(url: URL(string: "https://via.placeholder.com/60x60")) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        ZStack {
                            Circle()
                                .fill(Color.blue.opacity(0.1))
                            Text(getInitials(from: displayName))
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.blue)
                        }
                    }
                    .frame(width: 60, height: 60)
                    .clipShape(Circle())
                    
                    Spacer()
                    
                    Text("Appointments")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.black)
                    
                    
                    Spacer()
                    
                    Button(action: {}) {
                        Image(systemName: "bell")
                            .font(.system(size: 14))
                            .foregroundColor(.black)
                    }
                    .padding(10)
                    .overlay(
                        Circle()
                            .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                    )
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 20)
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Booking Options
                        VStack(spacing: 12) {
                            Button(action: {
                                onBookAppointment()
                            }) {
                                HStack {
                                    ZStack {
                                        Circle()
                                            .fill(Color.white.opacity(0.3))
                                            .frame(width: 40, height: 40)
                                        
                                        Image(systemName: "stethoscope")
                                            .font(.system(size: 18))
                                            .foregroundColor(.white)
                                    }
                                    
                                    Text("Book In-Hospital Consultation")
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(.white)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 14))
                                        .foregroundColor(.white.opacity(0.7))
                                }
                                .padding(16)
                                .background(Color.blue)
                                .cornerRadius(12)
                            }
                            
                            Button(action: {
                                onBookHomeVisit()
                            }) {
                                HStack {
                                    ZStack {
                                        Circle()
                                            .fill(Color.white.opacity(0.3))
                                            .frame(width: 40, height: 40)
                                        
                                        Image(systemName: "house.fill")
                                            .font(.system(size: 18))
                                            .foregroundColor(.white)
                                    }
                                    
                                    Text("Book Home Visit")
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(.white)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 14))
                                        .foregroundColor(.white.opacity(0.7))
                                }
                                .padding(16)
                                .background(Color.green)
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                                )
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        // Upcoming Appointments
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Text("Upcoming Appointments")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(.black)
                                Spacer()
                                Button(action: {}) {
                                    Text("View all")
                                        .font(.system(size: 14))
                                        .foregroundColor(.blue)
                                }
                            }
                            .padding(.horizontal, 20)
                            
                            VStack(spacing: 12) {
                                ForEach(AppointmentDetail.sampleData.prefix(3), id: \.id) { appointment in
                                    Button(action: {
                                        selectedAppointment = appointment
                                        withAnimation(.easeInOut(duration: 0.3)) {
                                            showAppointmentDetails = true
                                        }
                                    }) {
                                        HStack(spacing: 12) {
                                            // Doctor Avatar
                                            ZStack {
                                                Circle()
                                                    .fill(Color.blue.opacity(0.1))
                                                    .frame(width: 50, height: 50)
                                                
                                                Image(systemName: "stethoscope")
                                                    .font(.system(size: 20))
                                                    .foregroundColor(.blue)
                                            }
                                            
                                            VStack(alignment: .leading, spacing: 4) {
                                                Text(appointment.title)
                                                    .font(.system(size: 16, weight: .medium))
                                                    .foregroundColor(.black)
                                                
                                                Text(appointment.doctor)
                                                    .font(.system(size: 14))
                                                    .foregroundColor(.gray)
                                                
                                                if !appointment.date.isEmpty {
                                                    HStack(spacing: 8) {
                                                        HStack(spacing: 4) {
                                                            Image(systemName: "calendar")
                                                                .font(.system(size: 10))
                                                            Text(appointment.date)
                                                                .font(.system(size: 12))
                                                        }
                                                        
                                                        HStack(spacing: 4) {
                                                            Image(systemName: "clock")
                                                                .font(.system(size: 10))
                                                            Text(appointment.time)
                                                                .font(.system(size: 12))
                                                        }
                                                    }
                                                    .foregroundColor(.blue)
                                                    .padding(8)
                                                    .background(Color.blue.opacity(0.1))
                                                    .cornerRadius(6)
                                                }
                                            }
                                            
                                            Spacer()
                                            
                                            Image(systemName: "chevron.right")
                                                .font(.system(size: 14))
                                                .foregroundColor(.gray)
                                        }
                                        .padding(16)
                                        .background(Color.white)
                                        .cornerRadius(12)
                                        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                        .padding(.top, 20)
                        
                        // Home Visits
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Text("Home Visits")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(.black)
                                Spacer()
                                Button(action: {}) {
                                    Text("View all")
                                        .font(.system(size: 14))
                                        .foregroundColor(.green)
                                }
                            }
                            .padding(.horizontal, 20)
                            
                            VStack(spacing: 12) {
                                ForEach(HomeVisitDetail.sampleData, id: \.id) { homeVisit in
                                    Button(action: {
                                        selectedHomeVisit = homeVisit
                                        withAnimation(.easeInOut(duration: 0.3)) {
                                            showHomeVisitDetails = true
                                        }
                                    }) {
                                        HStack(spacing: 12) {
                                            // Home Visit Icon
                                            ZStack {
                                                Circle()
                                                    .fill(Color.green.opacity(0.1))
                                                    .frame(width: 50, height: 50)
                                                
                                                Image(systemName: "house.fill")
                                                    .font(.system(size: 20))
                                                    .foregroundColor(.green)
                                            }
                                            
                                            VStack(alignment: .leading, spacing: 4) {
                                                Text(homeVisit.title)
                                                    .font(.system(size: 16, weight: .medium))
                                                    .foregroundColor(.black)
                                                
                                                HStack(spacing: 8) {
                                                    HStack(spacing: 4) {
                                                        Image(systemName: "calendar")
                                                            .font(.system(size: 10))
                                                        Text(homeVisit.dateTime.components(separatedBy: " ").first ?? "")
                                                            .font(.system(size: 12))
                                                    }
                                                    
                                                    HStack(spacing: 4) {
                                                        Image(systemName: "clock")
                                                            .font(.system(size: 10))
                                                        Text(homeVisit.dateTime.components(separatedBy: " ").last ?? "")
                                                            .font(.system(size: 12))
                                                    }
                                                }
                                                .foregroundColor(.green)
                                                .padding(8)
                                                .background(Color.green.opacity(0.1))
                                                .cornerRadius(6)
                                            }
                                            
                                            Spacer()
                                            
                                            Image(systemName: "chevron.right")
                                                .font(.system(size: 14))
                                                .foregroundColor(.gray)
                                        }
                                        .padding(16)
                                        .background(Color.white)
                                        .cornerRadius(12)
                                        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                        .padding(.top, 20)
                        
                        // Quick Actions
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Text("Quick Actions")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(.black)
                                Spacer()
                            }
                            .padding(.horizontal, 20)
                            
                            HStack(spacing: 15) {
                                QuickActionView(icon: "calendar.badge.plus", title: "Schedule", subtitle: "New Appointment", color: .blue)
                                QuickActionView(icon: "clock.arrow.circlepath", title: "Reschedule", subtitle: "Existing Appointment", color: .orange)
                                QuickActionView(icon: "xmark.circle", title: "Cancel", subtitle: "Appointment", color: .red)
                            }
                            .padding(.horizontal, 20)
                        }
                        
                        Spacer(minLength: 100)
                    }
                }
            }
            .background(Color(.systemGroupedBackground))
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
    
    // Helper function to get initials from name
    private func getInitials(from name: String) -> String {
        let components = name.components(separatedBy: " ")
        let initials = components.compactMap { $0.first }.map { String($0) }
        return initials.prefix(2).joined().uppercased()
    }
}

struct QuickActionView: View {
    let icon: String
    let title: String
    let subtitle: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(color.opacity(0.1))
                    .frame(width: 50, height: 50)
                
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(color)
            }
            
            VStack(spacing: 2) {
                Text(title)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.black)
                
                Text(subtitle)
                    .font(.system(size: 10))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}

struct AppointmentCardView: View {
    let appointment: AppointmentDetail
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                // Doctor Avatar
                ZStack {
                    Circle()
                        .fill(Color.blue.opacity(0.1))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: "stethoscope")
                        .font(.system(size: 20))
                        .foregroundColor(.blue)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(appointment.title)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.black)
                    
                    Text(appointment.doctor)
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                    
                    if !appointment.date.isEmpty {
                        HStack(spacing: 8) {
                            HStack(spacing: 4) {
                                Image(systemName: "calendar")
                                    .font(.system(size: 10))
                                Text(appointment.date)
                                    .font(.system(size: 12))
                            }
                            
                            HStack(spacing: 4) {
                                Image(systemName: "clock")
                                    .font(.system(size: 10))
                                Text(appointment.time)
                                    .font(.system(size: 12))
                            }
                        }
                        .foregroundColor(.blue)
                        .padding(8)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(6)
                    }
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }
            .padding(16)
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct HomeVisitCardView: View {
    let homeVisit: HomeVisitDetail
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                // Home Visit Icon
                ZStack {
                    Circle()
                        .fill(Color.green.opacity(0.1))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: "house.fill")
                        .font(.system(size: 20))
                        .foregroundColor(.green)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(homeVisit.title)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.black)
                    
                    HStack(spacing: 8) {
                        HStack(spacing: 4) {
                            Image(systemName: "calendar")
                                .font(.system(size: 10))
                            Text(homeVisit.dateTime.components(separatedBy: " ").first ?? "")
                                .font(.system(size: 12))
                        }
                        
                        HStack(spacing: 4) {
                            Image(systemName: "clock")
                                .font(.system(size: 10))
                            Text(homeVisit.dateTime.components(separatedBy: " ").last ?? "")
                                .font(.system(size: 12))
                        }
                    }
                    .foregroundColor(.green)
                    .padding(8)
                    .background(Color.green.opacity(0.1))
                    .cornerRadius(6)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }
            .padding(16)
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
        }
        .buttonStyle(PlainButtonStyle())
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

import SwiftUI
import MapKit

struct AppointmentDetail: Codable, Identifiable {
        let id = UUID()
    let appointmentDate: String
    let appointmentTime: String
    let contactNumber: String
    let createdDate: String
    let createdTime: String
    let dob: String
    let doctorName: String
    let patientId: String
    let patientName: String
    let speciality: String
    let status: String
    
    // Computed properties for UI compatibility
    var title: String {
        return "Consultation - \(speciality)"
    }
    
    var doctor: String {
        return doctorName
    }
    
    var date: String {
        return appointmentDate
    }
    
    var time: String {
        return appointmentTime
    }
    
//    var id: String {
//        return "\(patientId)-\(appointmentDate)-\(appointmentTime)-\(doctorName)"
//    }
}

struct AppointmentsView: View {
    @State private var appointments: [AppointmentDetail] = []
    @State private var isLoadingAppointments = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    
    let onBookAppointment: () -> Void
    let onBookHomeVisit: () -> Void
    
    @State private var selectedAppointment: AppointmentDetail?
    @State private var selectedHomeVisit: HomeVisitDetail?
    @State private var showAppointmentDetails = false
    @State private var showHomeVisitDetails = false
    
    
    var body: some View {
        ZStack {
            mainContent
            detailsOverlays
        }
    }
    
    // 3. Add these computed properties to break down the complex view
    private var mainContent: some View {
        VStack(spacing: 0) {
            headerSection
            scrollContent
        }
        .background(Color(.systemGroupedBackground))
        .opacity(showAppointmentDetails || showHomeVisitDetails ? 0 : 1)
    }
    
    private var headerSection: some View {
        HStack {
            Text("Appointments")
                .font(.system(size: 24, weight: .semibold))
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
    }
    
    private var scrollContent: some View {
        ScrollView {
            VStack(spacing: 20) {
                bookingOptionsSection
                upcomingAppointmentsSection
                homeVisitsSection
                quickActionsSection
                Spacer(minLength: 100)
            }
        }
    }
    
    private var bookingOptionsSection: some View {
        VStack(spacing: 12) {
            bookAppointmentButton
            bookHomeVisitButton
        }
        .padding(.horizontal, 20)
    }
    
    private var bookAppointmentButton: some View {
        Button(action: onBookAppointment) {
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
    }
    
    private var bookHomeVisitButton: some View {
        Button(action: onBookHomeVisit) {
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
        }
    }
    
    private var upcomingAppointmentsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            appointmentsHeader
            appointmentsList
        }
        .padding(.top, 20)
        .onAppear {
            fetchAppointments()
        }
        .alert("Error", isPresented: $showAlert) {
            Button("OK") { }
        } message: {
            Text(alertMessage)
        }
    }
    
    private var appointmentsHeader: some View {
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
    }
    
    private var appointmentsList: some View {
        VStack(spacing: 12) {
            if isLoadingAppointments {
                loadingView
            } else if appointments.isEmpty {
                emptyAppointmentsView
            } else {
                ForEach(appointments.prefix(3)) { appointment in
                    appointmentCard(appointment)
                }
            }
        }
        .padding(.horizontal, 20)
    }
    
    private var loadingView: some View {
        VStack(spacing: 16) {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                .scaleEffect(1.2)
            Text("Loading appointments...")
                .font(.system(size: 14))
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
        .background(Color.white)
        .cornerRadius(12)
    }
    
    private var emptyAppointmentsView: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(Color.gray.opacity(0.1))
                    .frame(width: 60, height: 60)
                
                Image(systemName: "calendar.badge.clock")
                    .font(.system(size: 24))
                    .foregroundColor(.gray)
            }
            
            Text("No appointments found")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.gray)
            
            Text("Book your first appointment")
                .font(.system(size: 14))
                .foregroundColor(.gray.opacity(0.7))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
        .background(Color.white)
        .cornerRadius(12)
    }
    
    private func appointmentCard(_ appointment: AppointmentDetail) -> some View {
        AppointmentCard(
            speciality: appointment.title, // Uses computed property: "Consultation - \(speciality)"
            doctorName: appointment.doctorName,
            appointmentDate: appointment.appointmentDate,
            appointmentTime: appointment.appointmentTime,
            onTapped: {
                // Simply pass the existing appointment - no need to recreate it
                selectedAppointment = appointment
                withAnimation(.easeInOut(duration: 0.3)) {
                    showAppointmentDetails = true
                }
            }
        )
    }
    
    
    private func appointmentCardContent(_ appointment: AppointmentDetail) -> some View {
        HStack(spacing: 12) {
            doctorAvatar
            appointmentInfo(appointment)
            Spacer()
            chevronIcon
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
    
    private var doctorAvatar: some View {
        ZStack {
            Circle()
                .fill(Color.blue.opacity(0.1))
                .frame(width: 50, height: 50)
            
            Image(systemName: "stethoscope")
                .font(.system(size: 20))
                .foregroundColor(.blue)
        }
    }
    
    private func appointmentInfo(_ appointment: AppointmentDetail) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Consultation - \(appointment.speciality)")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.black)
            
            Text(appointment.doctorName)
                .font(.system(size: 14))
                .foregroundColor(.gray)
            
            dateTimeInfo(appointment)
            statusBadge(appointment.status)
        }
    }
    
    private func dateTimeInfo(_ appointment: AppointmentDetail) -> some View {
        HStack(spacing: 8) {
            HStack(spacing: 4) {
                Image(systemName: "calendar")
                    .font(.system(size: 10))
                Text(appointment.appointmentDate)
                    .font(.system(size: 12))
            }
            
            HStack(spacing: 4) {
                Image(systemName: "clock")
                    .font(.system(size: 10))
                Text(appointment.appointmentTime)
                    .font(.system(size: 12))
            }
        }
        .foregroundColor(.blue)
        .padding(8)
        .background(Color.blue.opacity(0.1))
        .cornerRadius(6)
    }
    
    private func statusBadge(_ status: String) -> some View {
        Text(status.uppercased())
            .font(.system(size: 10, weight: .semibold))
            .foregroundColor(status.lowercased() == "pending" ? .orange : .green)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(
                (status.lowercased() == "pending" ? Color.orange : Color.green).opacity(0.1)
            )
            .cornerRadius(4)
    }
    
    private var chevronIcon: some View {
        Image(systemName: "chevron.right")
            .font(.system(size: 14))
            .foregroundColor(.gray)
    }
    
    // 4. Add the remaining sections (simplified)
    private var homeVisitsSection: some View {
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
                    HomeVisitCardView(homeVisit: homeVisit) {
                        selectedHomeVisit = homeVisit
                        withAnimation(.easeInOut(duration: 0.3)) {
                            showHomeVisitDetails = true
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
        }
        .padding(.top, 20)
    }
    
    private var quickActionsSection: some View {
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
    }
    
    private var detailsOverlays: some View {
        Group {
            if showAppointmentDetails, let AppointmentDetail = selectedAppointment {
                AppointmentDetailsView(
                    appointment: AppointmentDetail,
                    onBackTapped: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            showAppointmentDetails = false
                        }
                    }
                )
                .transition(.move(edge: .trailing))
            }
            
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
    
    private var patientId: String {
        return UserDefaults.standard.string(forKey: "id") ?? ""
    }
    
    private func fetchAppointments() {
        guard !patientId.isEmpty else {
            alertMessage = "Patient ID not found. Please log in again."
            showAlert = true
            return
        }
        
        guard let url = URL(string: "https://mediaccess.vercel.app/api/appointment/all?patientId=\(patientId)") else {
            alertMessage = "Invalid API endpoint"
            showAlert = true
            return
        }
        
        isLoadingAppointments = true
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                isLoadingAppointments = false
                
                if let error = error {
                    alertMessage = "Network error: \(error.localizedDescription)"
                    showAlert = true
                    return
                }
                
                guard let data = data else {
                    alertMessage = "No data received"
                    showAlert = true
                    return
                }
                
                do {
                    // Create wrapper struct to match API response
                    struct AppointmentsResponse: Codable {
                        let appointments: [AppointmentDetail]
                    }
                    
                    let response = try JSONDecoder().decode(AppointmentsResponse.self, from: data)
                    self.appointments = response.appointments
                    
                } catch {
                    print("Decoding error: \(error)")
                    alertMessage = "Failed to parse appointments data"
                    showAlert = true
                }
            }
        }.resume()
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
                ZStack {
                    Circle()
                        .fill(Color.blue.opacity(0.1))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: "stethoscope")
                        .font(.system(size: 20))
                        .foregroundColor(.blue)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(appointment.speciality)
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
                                Text(appointment.appointmentDate)
                                    .font(.system(size: 12))
                            }
                            
                            HStack(spacing: 4) {
                                Image(systemName: "clock")
                                    .font(.system(size: 10))
                                Text(appointment.appointmentTime)
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

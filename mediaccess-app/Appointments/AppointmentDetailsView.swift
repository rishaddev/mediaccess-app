import SwiftUI
import MapKit
import EventKit

struct AppointmentDetailsView: View {
    let appointment: AppointmentDetail
    let onBackTapped: () -> Void
    
    @State private var showCalendarAlert = false
    @State private var showCancelAlert = false
    @State private var showRescheduleAlert = false
    @State private var showSuccessAlert = false
    @State private var showErrorAlert = false
    @State private var errorMessage = ""
    
    var body: some View {
        VStack(spacing: 0) {
            headerView
            
            ScrollView {
                VStack(spacing: 24) {
                    appointmentOverviewCard
                    patientInformationCard
                    appointmentDetailsCard
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
            Text("Would you like to add this appointment to your calendar?")
        }
        .alert("Cancel Appointment", isPresented: $showCancelAlert) {
            Button("Cancel Appointment", role: .destructive) {
                cancelAppointment()
            }
            Button("Keep Appointment", role: .cancel) { }
        } message: {
            Text("Are you sure you want to cancel this appointment? This action cannot be undone.")
        }
        .alert("Reschedule Appointment", isPresented: $showRescheduleAlert) {
            Button("Reschedule") {
                rescheduleAppointment()
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Would you like to reschedule this appointment?")
        }
        .alert("Success", isPresented: $showSuccessAlert) {
            Button("OK") { }
        } message: {
            Text("Appointment has been added to your calendar successfully!")
        }
        .alert("Error", isPresented: $showErrorAlert) {
            Button("OK") { }
        } message: {
            Text("Failed to add appointment to calendar: \(errorMessage)")
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
            
            Text("Appointment Details")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.black)
            
            Spacer()
            
            // Share button
            Button(action: shareAppointment) {
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
    
    private var appointmentOverviewCard: some View {
        VStack(spacing: 16) {
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(Color.blue.opacity(0.1))
                        .frame(width: 70, height: 70)
                    
                    Image(systemName: "stethoscope")
                        .font(.system(size: 30))
                        .foregroundColor(.blue)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(appointment.title)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.black)
                        .lineLimit(2)
                    
                    Text(appointment.doctorName)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.gray)
                    
                    HStack(spacing: 8) {
                        HStack(spacing: 4) {
                            Image(systemName: "calendar")
                                .font(.system(size: 12))
                            Text(appointment.appointmentDate)
                                .font(.system(size: 14, weight: .medium))
                        }
                        
                        HStack(spacing: 4) {
                            Image(systemName: "clock")
                                .font(.system(size: 12))
                            Text(appointment.appointmentTime)
                                .font(.system(size: 14, weight: .medium))
                        }
                    }
                    .foregroundColor(.blue)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.blue.opacity(0.1))
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
                    iconColor: .blue,
                    title: "Patient Name",
                    value: appointment.patientName
                )
                
                patientDetailRow(
                    icon: "phone.fill",
                    iconColor: .green,
                    title: "Contact Number",
                    value: appointment.contactNumber
                )
                
                patientDetailRow(
                    icon: "calendar",
                    iconColor: .orange,
                    title: "Date of Birth",
                    value: appointment.dob
                )
                
                patientDetailRow(
                    icon: "number.circle.fill",
                    iconColor: .purple,
                    title: "Patient ID",
                    value: appointment.patientId
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
    
    private var appointmentDetailsCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Appointment Details")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.black)
            
            VStack(spacing: 12) {
                appointmentDetailRow(
                    icon: "stethoscope",
                    iconColor: .blue,
                    title: "Specialty",
                    value: appointment.speciality
                )
                
                appointmentDetailRow(
                    icon: "person.fill.badge.plus",
                    iconColor: .green,
                    title: "Doctor",
                    value: appointment.doctorName
                )
                
                appointmentDetailRow(
                    icon: "calendar.badge.clock",
                    iconColor: .orange,
                    title: "Appointment Date",
                    value: appointment.appointmentDate
                )
                
                appointmentDetailRow(
                    icon: "clock.fill",
                    iconColor: .purple,
                    title: "Appointment Time",
                    value: appointment.appointmentTime
                )
            }
        }
        .padding(20)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 2)
    }
    
    private func appointmentDetailRow(icon: String, iconColor: Color, title: String, value: String) -> some View {
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
                        
                        Text(appointment.status.capitalized)
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
                    value: "\(appointment.createdDate) at \(appointment.createdTime)"
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
        Text(appointment.status.uppercased())
            .font(.system(size: 10, weight: .bold))
            .foregroundColor(statusColor)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(statusColor.opacity(0.1))
            .cornerRadius(8)
    }
    
    private var statusColor: Color {
        switch appointment.status.lowercased() {
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
        switch appointment.status.lowercased() {
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
                    gradient: Gradient(colors: [Color.blue, Color.blue.opacity(0.8)]),
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
    
    private func createCalendarEvent(eventStore: EKEventStore) {
        let event = EKEvent(eventStore: eventStore)
        
        event.title = "\(appointment.title) - \(appointment.doctorName)"
        event.notes = """
        Patient: \(appointment.patientName)
        Doctor: \(appointment.doctorName)
        Specialty: \(appointment.speciality)
        Contact: \(appointment.contactNumber)
        Patient ID: \(appointment.patientId)
        Status: \(appointment.status.capitalized)
        """
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm" 
        
        guard let appointmentDate = dateFormatter.date(from: appointment.appointmentDate),
              let appointmentTime = timeFormatter.date(from: appointment.appointmentTime) else {
            displayErrorAlert(message: "Failed to parse appointment date or time")
            return
        }
        
        // Combine date and time
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: appointmentDate)
        let timeComponents = calendar.dateComponents([.hour, .minute], from: appointmentTime)
        
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
        event.endDate = startDate.addingTimeInterval(3600)
        
        event.calendar = eventStore.defaultCalendarForNewEvents
        
        let alarm = EKAlarm(relativeOffset: -15 * 60) 
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
    
    private func rescheduleAppointment() {
        print("Rescheduling appointment: \(appointment.id)")
    }
    
    private func cancelAppointment() {
        print("Cancelling appointment: \(appointment.id)")
    }
    
    private func shareAppointment() {
        let shareText = """
        📅 Appointment Details
        
        Patient: \(appointment.patientName)
        Doctor: \(appointment.doctorName)
        Specialty: \(appointment.speciality)
        Date: \(appointment.appointmentDate)
        Time: \(appointment.appointmentTime)
        Status: \(appointment.status.capitalized)
        
        Appointment ID: \(appointment.id)
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

struct AppointmentDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        AppointmentDetailsView(
            appointment: AppointmentDetail(
                appointmentDate: "2024-12-25",
                appointmentTime: "10:00",
                contactNumber: "+1234567890",
                createdDate: "2024-12-20",
                createdTime: "14:30",
                dob: "1990-01-01",
                doctorName: "Dr. Sarah Johnson",
                patientId: "PAT001",
                patientName: "John Doe",
                speciality: "Cardiology",
                status: "confirmed"
            ),
            onBackTapped: {}
        )
    }
}

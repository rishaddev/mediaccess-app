import SwiftUI

struct AllAppointmentsView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var appointments: [AppointmentDetail] = []
    @State private var isLoading = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var selectedAppointment: AppointmentDetail?
    @State private var showAppointmentDetails = false
    @State private var searchText = ""
    @State private var selectedFilter: AppointmentFilter = .all
    
    enum AppointmentFilter: String, CaseIterable {
        case all = "All"
        case pending = "Pending"
        case confirmed = "Confirmed"
        case completed = "Completed"
        case cancelled = "Cancelled"
    }
    
    var filteredAppointments: [AppointmentDetail] {
        var filtered = appointments
        
        if !searchText.isEmpty {
            filtered = filtered.filter { appointment in
                appointment.patientName.localizedCaseInsensitiveContains(searchText) ||
                appointment.doctorName.localizedCaseInsensitiveContains(searchText) ||
                appointment.speciality.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        if selectedFilter != .all {
            filtered = filtered.filter { appointment in
                appointment.status.lowercased() == selectedFilter.rawValue.lowercased()
            }
        }
        
        return filtered.sorted { appointment1, appointment2 in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
            
            let dateTime1 = dateFormatter.date(from: "\(appointment1.appointmentDate) \(appointment1.appointmentTime)") ?? Date.distantPast
            let dateTime2 = dateFormatter.date(from: "\(appointment2.appointmentDate) \(appointment2.appointmentTime)") ?? Date.distantPast
            
            return dateTime1 < dateTime2
        }
    }
    
    var body: some View {
        ZStack {
            mainContent
            
            if showAppointmentDetails, let appointmentDetail = selectedAppointment {
                AppointmentDetailsView(
                    appointment: appointmentDetail,
                    onBackTapped: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            showAppointmentDetails = false
                        }
                    }
                )
                .transition(.move(edge: .trailing))
            }
        }
    }
    
    private var mainContent: some View {
        VStack(spacing: 0) {
            headerView
            
            if !appointments.isEmpty {
                searchAndFilterView
            }
            
            contentView
        }
        .background(Color(.systemGroupedBackground))
        .opacity(showAppointmentDetails ? 0 : 1)
        .onAppear {
            fetchAllAppointments()
        }
        .alert("Error", isPresented: $showAlert) {
            Button("OK") { }
        } message: {
            Text(alertMessage)
        }
    }
    
    private var headerView: some View {
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
            
            Text("All Appointments")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.black)
            
            Spacer()
            
            Circle()
                .fill(Color.clear)
                .frame(width: 40, height: 40)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 15)
        .background(Color(.systemGroupedBackground))
    }
    
    private var searchAndFilterView: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                
                TextField("Search appointments...", text: $searchText)
                    .textFieldStyle(PlainTextFieldStyle())
                
                if !searchText.isEmpty {
                    Button(action: {
                        searchText = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding(12)
            .background(Color.white)
            .cornerRadius(10)
            .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(AppointmentFilter.allCases, id: \.self) { filter in
                        Button(action: {
                            selectedFilter = filter
                        }) {
                            Text(filter.rawValue)
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(selectedFilter == filter ? .white : .blue)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(
                                    selectedFilter == filter ? Color.blue : Color.blue.opacity(0.1)
                                )
                                .cornerRadius(20)
                        }
                    }
                }
                .padding(.horizontal, 20)
            }
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 16)
    }
    
    private var contentView: some View {
        Group {
            if isLoading {
                loadingView
            } else if appointments.isEmpty {
                emptyView
            } else if filteredAppointments.isEmpty {
                noResultsView
            } else {
                appointmentsList
            }
        }
    }
    
    private var loadingView: some View {
        VStack(spacing: 20) {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                .scaleEffect(1.5)
            
            Text("Loading all appointments...")
                .font(.system(size: 16))
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var emptyView: some View {
        VStack(spacing: 20) {
            ZStack {
                Circle()
                    .fill(Color.gray.opacity(0.1))
                    .frame(width: 80, height: 80)
                
                Image(systemName: "calendar.badge.clock")
                    .font(.system(size: 32))
                    .foregroundColor(.gray)
            }
            
            Text("No appointments found")
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(.black)
            
            Text("You haven't booked any appointments yet")
                .font(.system(size: 14))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal, 40)
    }
    
    private var noResultsView: some View {
        VStack(spacing: 20) {
            ZStack {
                Circle()
                    .fill(Color.gray.opacity(0.1))
                    .frame(width: 80, height: 80)
                
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 32))
                    .foregroundColor(.gray)
            }
            
            Text("No results found")
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(.black)
            
            Text("Try adjusting your search or filter criteria")
                .font(.system(size: 14))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal, 40)
    }
    
    private var appointmentsList: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(filteredAppointments) { appointment in
                    VStack(spacing: 8) {
                        AppointmentCard(
                            speciality: appointment.title,
                            doctorName: appointment.doctorName,
                            appointmentDate: appointment.appointmentDate,
                            appointmentTime: appointment.appointmentTime,
                            onTapped: {
                                selectedAppointment = appointment
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    showAppointmentDetails = true
                                }
                            }
                        )
                        
                        HStack {
                            if !appointment.patientName.isEmpty {
                                HStack(spacing: 4) {
                                    Image(systemName: "person.circle.fill")
                                        .font(.system(size: 12))
                                        .foregroundColor(.gray)
                                    Text("Patient: \(appointment.patientName)")
                                        .font(.system(size: 12))
                                        .foregroundColor(.gray)
                                }
                            }
                            
                            Spacer()
                            
                            Text(appointment.status.uppercased())
                                .font(.system(size: 10, weight: .semibold))
                                .foregroundColor(statusColor(for: appointment.status))
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(statusColor(for: appointment.status).opacity(0.1))
                                .cornerRadius(4)
                        }
                        .padding(.horizontal, 16)
                        .padding(.bottom, 4)
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 100)
        }
    }
    
    private func statusColor(for status: String) -> Color {
        switch status.lowercased() {
        case "pending":
            return .orange
        case "confirmed":
            return .blue
        case "completed":
            return .green
        case "cancelled":
            return .red
        default:
            return .gray
        }
    }
    
    private var patientId: String {
        return UserDefaults.standard.string(forKey: "id") ?? ""
    }
    
    private func fetchAllAppointments() {
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
        
        isLoading = true
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                isLoading = false
                
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



struct AllAppointmentsView_Previews: PreviewProvider {
    static var previews: some View {
        AllAppointmentsView()
    }
}

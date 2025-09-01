import SwiftUI

struct DashboardView: View {
    @State private var showingProfile = false
    @State private var showingHospitalInfo = false
    @State private var showBookAppointment = false
    @State private var showBookHomeVisit = false
    @State private var showServices = false
    @State private var showPlaceNewOrder = false
    
    @State private var showOrderTracking = false
    @State private var selectedOrder: PharmacyOrder?
    @State private var currentOrders: [PharmacyOrder] = []
    @State private var isLoadingOrders = false
    
    @State private var appointments: [AppointmentDetail] = []
    @State private var isLoadingAppointments = false
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    let onLogout: () -> Void
    
    private var email: String {
        return UserDefaults.standard.string(forKey: "email") ?? "User"
    }
    
    private var displayName: String {
        if let storedName = UserDefaults.standard.string(forKey: "name"), !storedName.isEmpty {
            return storedName
        }
        
        let email = email
        if email.contains("@") {
            let username = String(email.split(separator: "@").first ?? "User")
            return username.replacingOccurrences(of: ".", with: " ")
                .replacingOccurrences(of: "_", with: " ")
                .capitalized
        }
        return email.capitalized
    }
    
    private var upcomingAppointments: [AppointmentDetail] {
        let today = Calendar.current.startOfDay(for: Date())
        
        return appointments.filter { appointment in
            guard let appointmentDate = dateFromString(appointment.appointmentDate) else { return false }
            let appointmentDay = Calendar.current.startOfDay(for: appointmentDate)
            return appointmentDay >= today
        }.sorted { appointment1, appointment2 in
            guard let date1 = dateFromString(appointment1.appointmentDate),
                  let date2 = dateFromString(appointment2.appointmentDate) else { return false }
            
            if Calendar.current.isDate(date1, inSameDayAs: date2) {
                let time1 = timeFromString(appointment1.appointmentTime)
                let time2 = timeFromString(appointment2.appointmentTime)
                return time1 < time2
            }
            
            return date1 < date2
        }
    }
    
    private func dateFromString(_ dateString: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: dateString)
    }
    
    private func timeFromString(_ timeString: String) -> String {
        return timeString
    }
    
    var body: some View {
        ZStack {
            mainContent
            orderTrackingOverlay
        }
        .background(Color(.systemGroupedBackground))
        .fullScreenCover(isPresented: $showingProfile) {
            ProfileView(onLogout: onLogout)
        }
        .fullScreenCover(isPresented: $showingHospitalInfo) {
            HospitalInformationView()
        }
        .fullScreenCover(isPresented: $showBookAppointment) {
            BookAppointmentView(onBackTapped: { showBookAppointment = false })
        }
        .fullScreenCover(isPresented: $showBookHomeVisit) {
            BookHomeVisitView(onBackTapped: { showBookHomeVisit = false })
        }
        .fullScreenCover(isPresented: $showServices) {
            HospitalInformationView()
        }
        .fullScreenCover(isPresented: $showPlaceNewOrder) {
            PlaceNewOrderView()
        }
    }
    
    private func getInitials(from name: String) -> String {
        let components = name.components(separatedBy: " ")
        let initials = components.compactMap { $0.first }.map { String($0) }
        return initials.prefix(2).joined().uppercased()
    }
    
    private var mainContent: some View {
        NavigationStack {
            VStack(spacing: 0) {
                ScrollView {
                    VStack(spacing: 20) {
                        profileHeader
                        nextAppointmentSection
                        serviceIconsSection
                        currentOrdersSection
                        promoCardSection
                        Spacer(minLength: 100)
                    }
                }
            }
            .onAppear {
                fetchAppointments()
            }
        }
    }
    
    private var profileHeader: some View {
        HStack {
            Button(action: {
                showingProfile = true
            }) {
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
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text("Hi, \(displayName)")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.black)
                
                Text("How are you feeling today")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }
            
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
        .padding(.top, 20)
    }
    
    private var nextAppointmentSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Next Appointment")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.black)
                Spacer()
            }
            
            if isLoadingAppointments {
                VStack(spacing: 16) {
                    ProgressView()
                    Text("Loading appointments...")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 40)
                .background(Color.white)
                .cornerRadius(12)
            } else if let nextAppointment = upcomingAppointments.first {
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.blue)
                        .frame(height: 120)
                    
                    HStack {
                        AsyncImage(url: URL(string: "https://via.placeholder.com/80x80")) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        } placeholder: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.white.opacity(0.2))
                                Image(systemName: "stethoscope")
                                    .font(.system(size: 30))
                                    .foregroundColor(.white)
                            }
                        }
                        .frame(width: 100, height: 100)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        
                        VStack(alignment: .leading, spacing: 0) {
                            Text(nextAppointment.doctorName)
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.white)
                            
                            Text(nextAppointment.title)
                                .font(.system(size: 14))
                                .foregroundColor(.white.opacity(0.8))
                                .padding(.bottom, 20)
                            
                            HStack {
                                HStack(spacing: 4) {
                                    Image(systemName: "calendar")
                                        .font(.system(size: 12))
                                    Text(nextAppointment.appointmentDate)
                                        .font(.system(size: 12))
                                }
                                
                                HStack(spacing: 4) {
                                    Image(systemName: "clock")
                                        .font(.system(size: 10))
                                    Text(nextAppointment.appointmentTime)
                                        .font(.system(size: 12))
                                }
                            }
                            .foregroundColor(.white.opacity(0.9))
                            .padding(10)
                            .background(Color.white.opacity(0.3))
                            .cornerRadius(5)
                        }
                        
                        Spacer()
                    }
                    .padding(10)
                }
            } else {
                VStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(Color.gray.opacity(0.1))
                            .frame(width: 60, height: 60)
                        
                        Image(systemName: "calendar")
                            .font(.system(size: 24))
                            .foregroundColor(.gray)
                    }
                    
                    Text("No upcoming appointments")
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
        }
        .padding(.horizontal, 20)
    }
    
    private var serviceIconsSection: some View {
        HStack(spacing: 20) {
            Button(action: { showBookAppointment = true }) {
                ServiceIconView(icon: "stethoscope", title: "Appointment", color: .blue)
            }
            Button(action: { showBookHomeVisit = true }) {
                ServiceIconView(icon: "house.fill", title: "Home Visit", color: .blue)
            }
            Button(action: { showServices = true }) {
                ServiceIconView(icon: "cross.case.fill", title: "Services", color: .blue)
            }
            Button(action: { showPlaceNewOrder = true }) {
                ServiceIconView(icon: "pills.fill", title: "Pharmacy", color: .blue)
            }
        }
        .padding(.horizontal, 20)
    }
    
    private var promoCardSection: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.blue)
                .frame(height: 200)
            
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text("50% off On")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text("Your Next")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text("Appointment.")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text("Book Now!!!")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Text("Call 0112345678")
                        .font(.system(size: 14))
                        .foregroundColor(.white.opacity(0.9))
                }
                
                Spacer()
                
                AsyncImage(url: URL(string: "https://via.placeholder.com/120x160")) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.white.opacity(0.2))
                        Image(systemName: "person.crop.circle.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.white.opacity(0.7))
                    }
                }
                .frame(width: 120, height: 160)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .padding(20)
        }
        .padding(.horizontal, 20)
    }
    
    private var currentOrdersSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            currentOrdersHeader
            currentOrdersList
        }
        .onAppear {
            fetchPharmacyOrders()
        }
        .alert("Error", isPresented: $showAlert) {
            Button("OK") { }
        } message: {
            Text(alertMessage)
        }
    }
    
    private var currentOrdersHeader: some View {
        HStack {
            Text("Recent Orders")
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
    
    private var currentOrdersList: some View {
        VStack(spacing: 12) {
            if isLoadingOrders {
                loadingView
            } else if currentOrders.isEmpty {
                emptyOrdersView
            } else {
                let filteredOrders = currentOrders.filter {
                    $0.status == "Pending" || $0.status == "Processing" || $0.status == "Ready"
                }
                if filteredOrders.isEmpty {
                    emptyOrdersView
                } else {
                    ForEach(filteredOrders.prefix(3), id: \.id) { order in
                        Button(action: {
                            selectedOrder = order
                            withAnimation(.easeInOut(duration: 0.3)) {
                                showOrderTracking = true
                            }
                        }) {
                            PharmacyOrderCard(order: order)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
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
            Text("Loading orders...")
                .font(.system(size: 14))
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
        .background(Color.white)
        .cornerRadius(12)
    }
    
    private var emptyOrdersView: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(Color.gray.opacity(0.1))
                    .frame(width: 60, height: 60)
                
                Image(systemName: "pills.fill")
                    .font(.system(size: 24))
                    .foregroundColor(.gray)
            }
            
            Text("No current orders")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.gray)
            
            Text("Place your first order")
                .font(.system(size: 14))
                .foregroundColor(.gray.opacity(0.7))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
        .background(Color.white)
        .cornerRadius(12)
    }
    
    private var orderTrackingOverlay: some View {
        Group {
            if showOrderTracking, let order = selectedOrder {
                OrderTrackingView(
                    order: order,
                    onBackTapped: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            showOrderTracking = false
                        }
                    }
                )
                .transition(.move(edge: .trailing))
            }
        }
        
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

    
    
    private func fetchPharmacyOrders() {
        guard !patientId.isEmpty else {
            alertMessage = "Patient ID not found. Please log in again."
            showAlert = true
            return
        }
        
        guard let url = URL(string: "https://mediaccess.vercel.app/api/pharmacy-order/all?patientId=\(patientId)") else {
            alertMessage = "Invalid API endpoint"
            showAlert = true
            return
        }
        
        isLoadingOrders = true
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                isLoadingOrders = false
                
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
                    struct PharmacyOrdersResponse: Codable {
                        let pharmacyorders: [PharmacyOrder]
                    }
                    
                    let response = try JSONDecoder().decode(PharmacyOrdersResponse.self, from: data)
                    self.currentOrders = response.pharmacyorders
                    
                } catch {
                    print("Decoding error: \(error)")
                    alertMessage = "Failed to parse appointments data"
                    showAlert = true
                }
            }
        }.resume()
    }
}

struct ServiceIconView: View {
    let icon: String
    let title: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.blue.opacity(0.1))
                    .frame(width: 60, height: 60)
                
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundColor(color)
            }
            
            Text(title)
                .font(.system(size: 12))
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
    }
}

//#Preview {
//    DashboardView(onLogout: {})
//}

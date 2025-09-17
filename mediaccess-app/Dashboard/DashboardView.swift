import SwiftUI

struct DashboardView: View {
    @State private var showingProfile = false
    @State private var showingHospitalInfo = false
    @State private var showBookAppointment = false
    @State private var showBookHomeVisit = false
    @State private var showServices = false
    @State private var showPlaceNewOrder = false
    @State private var showingNotifications = false
    
    @State private var showOrderTracking = false
    @State private var selectedOrder: PharmacyOrder?
    @State private var currentOrders: [PharmacyOrder] = []
    @State private var isLoadingOrders = false
    
    @State private var appointments: [AppointmentDetail] = []
    @State private var isLoadingAppointments = false
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    @StateObject private var badgeManager = NotificationBadgeManager.shared
    
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
        .fullScreenCover(isPresented: $showingNotifications) {
            NotificationsView()
                .onDisappear {
                    badgeManager.fetchNotificationCount()
                }
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Medical Dashboard")
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
                .accessibilityLabel("Dashboard content")
                .accessibilityHint("Scroll to view all dashboard sections")
            }
            .onAppear {
                fetchAppointments()
                badgeManager.fetchNotificationCount()
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
            .accessibilityLabel("Profile picture for \(displayName)")
            .accessibilityHint("Double tap to open profile settings")
            .accessibilityAddTraits(.isButton)
            
            VStack(alignment: .leading, spacing: 2) {
                Text("Hi, \(displayName)")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.black)
                    .accessibilityLabel("Welcome message: Hi, \(displayName)")
                
                Text("How are you feeling today")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                    .accessibilityLabel("Greeting: How are you feeling today")
            }
            .accessibilityElement(children: .combine)
            
            Spacer()
            
            Button(action: {
                showingNotifications = true
            }) {
                ZStack {
                    Image(systemName: "bell")
                        .font(.system(size: 14))
                        .foregroundColor(.black)
                    
                    if badgeManager.notificationCount > 0 {
                        ZStack {
                            Circle()
                                .fill(Color.red)
                                .frame(width: 16, height: 16)
                            
                            Text("\(min(badgeManager.notificationCount, 99))")
                                .font(.system(size: 8, weight: .bold))
                                .foregroundColor(.white)
                        }
                        .offset(x: 8, y: -8)
                    }
                }
            }
            .padding(10)
            .overlay(
                Circle()
                    .stroke(Color.gray.opacity(0.5), lineWidth: 1)
            )
            .accessibilityLabel(badgeManager.notificationCount > 0 ? "Notifications (\(badgeManager.notificationCount) unread)" : "Notifications")
            .accessibilityHint("Double tap to view notifications")
            .accessibilityAddTraits(.isButton)
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
        .accessibilityElement(children: .contain)
    }
    
    private var nextAppointmentSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Next Appointment")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.black)
                Spacer()
            }
            .accessibilityAddTraits(.isHeader)
            
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
                .accessibilityElement(children: .combine)
                .accessibilityLabel("Loading appointments")
                .accessibilityValue("Please wait while appointments are being loaded")
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
                        .accessibilityLabel("Doctor image")
                        .accessibilityHidden(true)
                        
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
                .accessibilityElement(children: .combine)
                .accessibilityLabel("Next appointment: \(nextAppointment.doctorName), \(nextAppointment.title)")
                .accessibilityValue("Scheduled for \(formatDateForAccessibility(nextAppointment.appointmentDate)) at \(nextAppointment.appointmentTime)")
                .accessibilityAddTraits(.isButton)
                .accessibilityHint("Your upcoming medical appointment")
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
                    .accessibilityHidden(true)
                    
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
                .accessibilityElement(children: .combine)
                .accessibilityLabel("No upcoming appointments")
                .accessibilityHint("Book your first appointment using the appointment button below")
            }
        }
        .padding(.horizontal, 20)
        .accessibilityElement(children: .contain)
    }
    
    private func formatDateForAccessibility(_ dateString: String) -> String {
        guard let date = dateFromString(dateString) else { return dateString }
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter.string(from: date)
    }
    
    private var serviceIconsSection: some View {
        HStack(spacing: 20) {
            Button(action: { showBookAppointment = true }) {
                ServiceIconView(icon: "stethoscope", title: "Appointment", color: .blue)
            }
            .accessibilityLabel("Book Appointment")
            .accessibilityHint("Double tap to schedule a new medical appointment")
            .accessibilityAddTraits(.isButton)
            
            Button(action: { showBookHomeVisit = true }) {
                ServiceIconView(icon: "house.fill", title: "Home Visit", color: .blue)
            }
            .accessibilityLabel("Book Home Visit")
            .accessibilityHint("Double tap to schedule a home visit from medical staff")
            .accessibilityAddTraits(.isButton)
            
            Button(action: { showServices = true }) {
                ServiceIconView(icon: "cross.case.fill", title: "Services", color: .blue)
            }
            .accessibilityLabel("Medical Services")
            .accessibilityHint("Double tap to view available medical services")
            .accessibilityAddTraits(.isButton)
            
            Button(action: { showPlaceNewOrder = true }) {
                ServiceIconView(icon: "pills.fill", title: "Pharmacy", color: .blue)
            }
            .accessibilityLabel("Pharmacy Orders")
            .accessibilityHint("Double tap to place a new pharmacy order")
            .accessibilityAddTraits(.isButton)
        }
        .padding(.horizontal, 20)
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Medical services")
        .accessibilityHint("Four service options available")
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
                .accessibilityElement(children: .combine)
                .accessibilityLabel("Special offer: 50% off on your next appointment. Book now!")
                .accessibilityValue("Call 0112345678 to book")
                
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
                .accessibilityHidden(true)
            }
            .padding(20)
        }
        .padding(.horizontal, 20)
        .accessibilityElement(children: .contain)
        .accessibilityAddTraits(.isButton)
        .accessibilityHint("Promotional offer for discounted appointments")
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
        .accessibilityElement(children: .contain)
    }
    
    private var currentOrdersHeader: some View {
        HStack {
            Text("Recent Orders")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.black)
                .accessibilityAddTraits(.isHeader)
            Spacer()
            Button(action: {}) {
                Text("View all")
                    .font(.system(size: 14))
                    .foregroundColor(.blue)
            }
            .accessibilityLabel("View all orders")
            .accessibilityHint("Double tap to see complete order history")
            .accessibilityAddTraits(.isButton)
        }
        .padding(.horizontal, 20)
        .accessibilityElement(children: .contain)
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
                    ForEach(Array(filteredOrders.prefix(3).enumerated()), id: \.element.id) { index, order in
                        Button(action: {
                            selectedOrder = order
                            withAnimation(.easeInOut(duration: 0.3)) {
                                showOrderTracking = true
                            }
                        }) {
                            PharmacyOrderCard(order: order)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .accessibilityLabel("Order \(index + 1): Status \(order.status)")
                        .accessibilityHint("Double tap to view order details and tracking")
                        .accessibilityAddTraits(.isButton)
                    }
                }
            }
        }
        .padding(.horizontal, 20)
        .accessibilityElement(children: .contain)
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
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Loading orders")
        .accessibilityValue("Please wait while orders are being loaded")
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
            .accessibilityHidden(true)
            
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
        .accessibilityElement(children: .combine)
        .accessibilityLabel("No current orders")
        .accessibilityHint("Place your first pharmacy order using the pharmacy button above")
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
                .accessibilityLabel("Order tracking details")
                .accessibilityHint("Currently viewing detailed tracking information for your pharmacy order")
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
                    
                    if !response.appointments.isEmpty {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            UIAccessibility.post(notification: .announcement,
                                               argument: "Appointments loaded. \(response.appointments.count) appointments found.")
                        }
                    }
                    
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
                    
                    let activeOrders = response.pharmacyorders.filter {
                        $0.status == "Pending" || $0.status == "Processing" || $0.status == "Ready"
                    }
                    
                    if !activeOrders.isEmpty {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            UIAccessibility.post(notification: .announcement,
                                               argument: "Orders loaded. \(activeOrders.count) active orders found.")
                        }
                    }
                    
                } catch {
                    print("Decoding error: \(error)")
                    alertMessage = "Failed to parse orders data"
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
            .accessibilityHidden(true)
            
            Text(title)
                .font(.system(size: 12))
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(title)
    }
}

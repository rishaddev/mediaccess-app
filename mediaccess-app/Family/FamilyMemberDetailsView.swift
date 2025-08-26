import SwiftUI

struct FamilyMemberDetailsView: View {
    let member: FamilyMember
    let onBackTapped: () -> Void
    @State private var selectedTab = 0
    
    @State private var isLoadingData = true
    @State private var appointments: [MemberAppointment] = []
    @State private var homeVisits: [MemberHomeVisit] = []
    @State private var pharmacyOrders: [MemberPharmacyOrder] = []
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    static var memberDataCache: [String: (appointments: [MemberAppointment], homeVisits: [MemberHomeVisit], pharmacyOrders: [MemberPharmacyOrder])] = [:]
    
    var body: some View {
        VStack(spacing: 0) {
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
                
                Text("Family Member")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.black)
                
                Spacer()
                
                Color.clear
                    .frame(width: 40, height: 40)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 20)
            
            ScrollView {
                VStack(spacing: 24) {
                    ZStack {
                        LinearGradient(
                            gradient: Gradient(colors: [Color.blue.opacity(0.7), Color.blue.opacity(0.9)]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                        .frame(height: 200)
                        .cornerRadius(12)
                        
                        VStack(spacing: 16) {
                            Circle()
                                .fill(Color.white.opacity(0.2))
                                .frame(width: 100, height: 100)
                                .overlay(
                                    Circle()
                                        .fill(member.avatarColor)
                                        .frame(width: 90, height: 90)
                                        .overlay(
                                            Image(systemName: "person.fill")
                                                .font(.system(size: 35))
                                                .foregroundColor(.white.opacity(0.9))
                                        )
                                )
                            
                            VStack(spacing: 6) {
                                Text(member.name)
                                    .font(.system(size: 22, weight: .bold))
                                    .foregroundColor(.white)
                                
                                Text(member.relationship)
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.white.opacity(0.9))
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    VStack(spacing: 0) {
                        HStack(spacing: 0) {
                            TabButton(title: "Overview", isSelected: selectedTab == 0) {
                                selectedTab = 0
                            }
                            TabButton(title: "Visits", isSelected: selectedTab == 1) {
                                selectedTab = 1
                            }
                            TabButton(title: "Home Care", isSelected: selectedTab == 2) {
                                selectedTab = 2
                            }
                            TabButton(title: "Orders", isSelected: selectedTab == 3) {
                                selectedTab = 3
                            }
                        }
                        
                        HStack(spacing: 0) {
                            Rectangle()
                                .fill(selectedTab == 0 ? Color.blue : Color.clear)
                                .frame(height: 3)
                            Rectangle()
                                .fill(selectedTab == 1 ? Color.blue : Color.clear)
                                .frame(height: 3)
                            Rectangle()
                                .fill(selectedTab == 2 ? Color.blue : Color.clear)
                                .frame(height: 3)
                            Rectangle()
                                .fill(selectedTab == 3 ? Color.blue : Color.clear)
                                .frame(height: 3)
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    Group {
                        switch selectedTab {
                        case 0:
                            OverviewTabContent(
                                appointments: appointments,
                                homeVisits: homeVisits,
                                pharmacyOrders: pharmacyOrders,
                                isLoading: isLoadingData
                            )
                        case 1:
                            AppointmentsTabContent(appointments: appointments, isLoading: isLoadingData)
                        case 2:
                            HomeVisitsTabContent(homeVisits: homeVisits, isLoading: isLoadingData)
                        case 3:
                            PharmacyTabContent(pharmacyOrders: pharmacyOrders, isLoading: isLoadingData)
                        default:
                            OverviewTabContent(
                                appointments: appointments,
                                homeVisits: homeVisits,
                                pharmacyOrders: pharmacyOrders,
                                isLoading: isLoadingData
                            )
                        }
                    }
                    .animation(.easeInOut(duration: 0.2), value: selectedTab)
                    
                    Spacer(minLength: 100)
                }
            }
        }
        .background(Color(.systemGroupedBackground))
        .onAppear {
            fetchMemberData()
        }
        .alert("Error", isPresented: $showAlert) {
            Button("OK") { }
        } message: {
            Text(alertMessage)
        }
    }
    
    private func fetchMemberData() {
        guard !member.id.isEmpty else {
            alertMessage = "Member ID is missing"
            showAlert = true
            return
        }
        
        if let cached = Self.memberDataCache[member.id] {
            appointments = cached.appointments
            homeVisits = cached.homeVisits
            pharmacyOrders = cached.pharmacyOrders
            isLoadingData = false
            return
        }
        
        isLoadingData = true
        let group = DispatchGroup()
        var fetchedAppointments: [MemberAppointment] = []
        var fetchedHomeVisits: [MemberHomeVisit] = []
        var fetchedPharmacyOrders: [MemberPharmacyOrder] = []
        
        group.enter()
        let appointmentsURLString = "https://mediaccess.vercel.app/api/appointment/all?patientId=\(member.id)"
        guard let appointmentsURL = URL(string: appointmentsURLString) else {
            group.leave()
            DispatchQueue.main.async {
                self.alertMessage = "Invalid appointments URL"
                self.showAlert = true
            }
            return
        }
        
        URLSession.shared.dataTask(with: appointmentsURL) { data, response, error in
            defer { group.leave() }
            
            if let error = error {
                print("Appointments API Error: \(error)")
                return
            }
            
            guard let data = data else {
                print("No appointments data received")
                return
            }
            
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Appointments Response: \(jsonString)")
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                    if let appointmentsArray = json["appointments"] as? [[String: Any]] {
                        fetchedAppointments = appointmentsArray.compactMap { appointmentDict in
                            guard let id = appointmentDict["id"] as? String,
                                  let title = appointmentDict["title"] as? String,
                                  let doctor = appointmentDict["doctor"] as? String,
                                  let date = appointmentDict["date"] as? String else {
                                return nil
                            }
                            return MemberAppointment(id: UUID(), title: title, doctor: doctor, date: date)
                        }
                    } else if json["appointments"] is NSNull || json["appointments"] == nil {
                        fetchedAppointments = []
                    }
                }
            } catch {
                print("Error parsing appointments: \(error)")
            }
        }.resume()
        
        group.enter()
        let homeVisitsURLString = "https://mediaccess.vercel.app/api/home-visit/all?patientId=\(member.id)"
        guard let homeVisitsURL = URL(string: homeVisitsURLString) else {
            group.leave()
            return
        }
        
        URLSession.shared.dataTask(with: homeVisitsURL) { data, response, error in
            defer { group.leave() }
            
            if let error = error {
                print("Home visits API Error: \(error)")
                return
            }
            
            guard let data = data else {
                print("No home visits data received")
                return
            }
            
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Home Visits Response: \(jsonString)")
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                    if let visitsArray = json["homeVisits"] as? [[String: Any]] ?? json["visits"] as? [[String: Any]] {
                        fetchedHomeVisits = visitsArray.compactMap { visitDict in
                            guard let id = visitDict["id"] as? String,
                                  let title = visitDict["title"] as? String,
                                  let provider = visitDict["provider"] as? String,
                                  let date = visitDict["date"] as? String else {
                                return nil
                            }
                            return MemberHomeVisit(id: UUID(), title: title, provider: provider, date: date)
                        }
                    }
                }
            } catch {
                print("Error parsing home visits: \(error)")
            }
        }.resume()
        
        group.enter()
        let pharmacyOrdersURLString = "https://mediaccess.vercel.app/api/pharmacy-order/all?patientId=\(member.id)"
        guard let pharmacyOrdersURL = URL(string: pharmacyOrdersURLString) else {
            group.leave()
            return
        }
        
        URLSession.shared.dataTask(with: pharmacyOrdersURL) { data, response, error in
            defer { group.leave() }
            
            if let error = error {
                print("Pharmacy orders API Error: \(error)")
                return
            }
            
            guard let data = data else {
                print("No pharmacy orders data received")
                return
            }
            
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Pharmacy Orders Response: \(jsonString)")
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                    if let ordersArray = json["pharmacyorders"] as? [[String: Any]] ?? json["orders"] as? [[String: Any]] {
                        fetchedPharmacyOrders = ordersArray.compactMap { orderDict in
                            guard let id = orderDict["id"] as? String,
                                  let patientName = orderDict["patientName"] as? String,
                                  let orderNumber = orderDict["orderNumber"] as? String ?? orderDict["id"] as? String,
                                  let date = orderDict["orderDate"] as? String ?? orderDict["date"] as? String else {
                                return nil
                            }
                            return MemberPharmacyOrder(id: UUID(), title: "Order for \(patientName)", orderNumber: orderNumber, date: date)
                        }
                    }
                }
            } catch {
                print("Error parsing pharmacy orders: \(error)")
            }
        }.resume()
        
        group.notify(queue: .main) {
            self.appointments = fetchedAppointments
            self.homeVisits = fetchedHomeVisits
            self.pharmacyOrders = fetchedPharmacyOrders
            
            Self.memberDataCache[self.member.id] = (fetchedAppointments, fetchedHomeVisits, fetchedPharmacyOrders)
            
            self.isLoadingData = false
            
            print("Final counts - Appointments: \(fetchedAppointments.count), Home Visits: \(fetchedHomeVisits.count), Pharmacy Orders: \(fetchedPharmacyOrders.count)")
        }
    }
}

struct TabButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 14, weight: isSelected ? .semibold : .medium))
                .foregroundColor(isSelected ? .blue : .gray)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .minimumScaleFactor(0.8)
                .lineLimit(1)
        }
        .buttonStyle(PlainButtonStyle())
    }
}


struct OverviewTabContent: View {
    let appointments: [MemberAppointment]
    let homeVisits: [MemberHomeVisit]
    let pharmacyOrders: [MemberPharmacyOrder]
    let isLoading: Bool
    
    var body: some View {
        VStack(spacing: 24) {
            SectionCard(title: "Recent Appointments") {
                if isLoading {
                    VStack(spacing: 16) {
                        ProgressView()
                        Text("Loading appointments...")
                            .font(.body)
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 40)
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
                } else if appointments.isEmpty {
                    EmptyStateView(
                        icon: "calendar",
                        title: "No appointments found",
                        subtitle: "Schedule your first visit"
                    )
                } else {
                    VStack(spacing: 12) {
                        ForEach(appointments.prefix(3), id: \.id) { appointment in
                            AppointmentRow(
                                icon: "calendar",
                                title: appointment.title,
                                subtitle: appointment.doctor,
                                date: appointment.date,
                                isUpcoming: false
                            )
                        }
                    }
                }
            }
            
            if !homeVisits.isEmpty || isLoading {
                SectionCard(title: "Recent Home Visits") {
                    if isLoading {
                        VStack(spacing: 16) {
                            ProgressView()
                            Text("Loading home visits...")
                                .font(.body)
                                .foregroundColor(.gray)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 40)
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
                    } else {
                        VStack(spacing: 12) {
                            ForEach(homeVisits.prefix(2), id: \.id) { visit in
                                AppointmentRow(
                                    icon: "house.fill",
                                    title: visit.title,
                                    subtitle: visit.provider,
                                    date: visit.date,
                                    isUpcoming: false
                                )
                            }
                        }
                    }
                }
            }
            
            HStack(spacing: 12) {
                StatCard(
                    title: "Total Visits",
                    value: isLoading ? "..." : "\(appointments.count + homeVisits.count)",
                    icon: "chart.bar.fill",
                    color: .blue
                )
                
                StatCard(
                    title: "Orders",
                    value: isLoading ? "..." : "\(pharmacyOrders.count)",
                    icon: "pills.fill",
                    color: .green
                )
            }
            .padding(.horizontal, 20)
        }
    }
}

struct AppointmentsTabContent: View {
    let appointments: [MemberAppointment]
    let isLoading: Bool
    
    var body: some View {
        SectionCard(title: "All Appointments") {
            if isLoading {
                ProgressView("Loading appointments...")
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 40)
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
            } else if appointments.isEmpty {
                EmptyStateView(
                    icon: "calendar",
                    title: "No appointments found",
                    subtitle: "Book your first appointment"
                )
            } else {
                VStack(spacing: 12) {
                    ForEach(appointments, id: \.id) { appointment in
                        AppointmentRow(
                            icon: "calendar",
                            title: appointment.title,
                            subtitle: appointment.doctor,
                            date: appointment.date,
                            isUpcoming: false
                        )
                    }
                }
            }
        }
    }
}

struct HomeVisitsTabContent: View {
    let homeVisits: [MemberHomeVisit]
    let isLoading: Bool
    
    var body: some View {
        SectionCard(title: "All Home Visits") {
            if isLoading {
                ProgressView("Loading home visits...")
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 40)
            } else if homeVisits.isEmpty {
                EmptyStateView(
                    icon: "house",
                    title: "No home visits scheduled",
                    subtitle: "Request a home visit"
                )
            } else {
                VStack(spacing: 12) {
                    ForEach(homeVisits, id: \.id) { visit in
                        AppointmentRow(
                            icon: "house",
                            title: visit.title,
                            subtitle: visit.provider,
                            date: visit.date,
                            isUpcoming: false
                        )
                    }
                }
            }
        }
    }
}

struct PharmacyTabContent: View {
    let pharmacyOrders: [MemberPharmacyOrder]
    let isLoading: Bool
    
    var body: some View {
        SectionCard(title: "Pharmacy Orders") {
            if isLoading {
                ProgressView("Loading pharmacy orders...")
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 40)
            } else if pharmacyOrders.isEmpty {
                EmptyStateView(
                    icon: "pills",
                    title: "No pharmacy orders",
                    subtitle: "Place your first order"
                )
            } else {
                VStack(spacing: 12) {
                    ForEach(pharmacyOrders, id: \.id) { order in
                        AppointmentRow(
                            icon: "pills",
                            title: order.title,
                            subtitle: order.orderNumber,
                            date: order.date,
                            isUpcoming: false
                        )
                    }
                }
            }
        }
    }
}


struct SectionCard<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.black)
            
            content
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 20)
    }
}

struct AppointmentRow: View {
    let icon: String
    let title: String
    let subtitle: String
    let date: String
    let isUpcoming: Bool
    
    var body: some View {
        HStack(spacing: 16) {
            RoundedRectangle(cornerRadius: 10)
                .fill(isUpcoming ? Color.blue.opacity(0.1) : Color.gray.opacity(0.1))
                .frame(width: 44, height: 44)
                .overlay(
                    Image(systemName: icon)
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(isUpcoming ? .blue : .gray)
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.black)
                
                Text(subtitle)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            if !date.isEmpty {
                VStack(alignment: .trailing, spacing: 2) {
                    Text(date)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.gray)
                    
                    if isUpcoming {
                        Text("Upcoming")
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundColor(.blue)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 2)
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(8)
                    }
                }
            }
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}

struct EmptyStateView: View {
    let icon: String
    let title: String
    let subtitle: String
    
    var body: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(Color.gray.opacity(0.1))
                    .frame(width: 60, height: 60)
                
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundColor(.gray)
            }
            
            VStack(spacing: 4) {
                Text(title)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.gray)
                
                Text(subtitle)
                    .font(.system(size: 14))
                    .foregroundColor(.gray.opacity(0.7))
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(color)
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(value)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.black)
                
                Text(title)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}

struct MemberAppointment: Identifiable {
    let id: UUID
    let title: String
    let doctor: String
    let date: String
}

struct MemberHomeVisit: Identifiable {
    let id: UUID
    let title: String
    let provider: String
    let date: String
}

struct MemberPharmacyOrder: Identifiable {
    let id: UUID
    let title: String
    let orderNumber: String
    let date: String
}

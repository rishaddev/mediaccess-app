import SwiftUI

struct FamilyMember: Identifiable {
    let id: String
    let name: String
    let relationship: String
    let avatarColor: Color
    
    init(dependent: Dependent, color: Color = .blue.opacity(0.7)) {
        self.id = dependent.id
        self.name = dependent.name
        self.relationship = dependent.relationship
        self.avatarColor = color
    }
}

struct FamilyView: View {
    @State private var showAddMember = false
    @State private var showAppointmentDetails = false
    @State private var showLabReportDetails = false
    @State private var showMemberDetails = false
    @State private var selectedAppointment: PastAppointment?
    @State private var selectedLabReport: LabReport?
    @State private var selectedMember: FamilyMember?
    
    @State private var familyMembers: [FamilyMember] = []
    @State private var familyAppointments: [PastAppointment] = []
    @State private var isLoadingFamilyAppointments = false
    
    var body: some View {
        ZStack {
            mainContent
            overlaysContent
        }
        .onAppear {
            loadFamilyMembers()
//            fetchFamilyAppointments()
        }
        .onChange(of: showAddMember) { _, isShowing in
            if !isShowing {
                loadFamilyMembers()
            }
        }
    }
    
    private var mainContent: some View {
        VStack(spacing: 0) {
            headerSection
            scrollContent
        }
        .background(Color(.systemGroupedBackground))
        .opacity(showAddMember || showAppointmentDetails || showLabReportDetails || showMemberDetails ? 0 : 1)
    }
    
    private var headerSection: some View {
        HStack {
            Text("Family")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.black)
            
            Spacer()
            
            Button(action: {}) {
                ZStack {
                    Circle()
                        .fill(Color.white)
                        .frame(width: 40, height: 40)
                        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
                    
                    Image(systemName: "bell")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.black)
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 20)
    }
    
    private var scrollContent: some View {
        ScrollView {
            VStack(spacing: 24) {
                heroSection
                familyMembersSection
                pastAppointmentsSection
                Spacer(minLength: 100)
            }
            .padding(.top, 10)
        }
    }
    
    private var heroSection: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.blue.opacity(0.8), Color.blue]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(height: 140)
            
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Family Care Hub")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text("Manage health records for your loved ones")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white.opacity(0.9))
                        .lineLimit(2)
                }
                
                Spacer()
                
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.2))
                        .frame(width: 60, height: 60)
                    
                    Image(systemName: "heart.fill")
                        .font(.system(size: 24))
                        .foregroundColor(.white)
                }
            }
            .padding(.horizontal, 20)
        }
        .padding(.horizontal, 20)
    }
    
    private var familyMembersSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            familyMembersHeader
            familyMembersGrid
        }
    }
    
    private var familyMembersHeader: some View {
        HStack {
            Text("Family Members")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.black)
            
            Spacer()
            
            Text("\(familyMembers.count) member\(familyMembers.count == 1 ? "" : "s")")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.gray)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(12)
        }
        .padding(.horizontal, 20)
    }
    
    private var familyMembersGrid: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 16) {
                ForEach(familyMembers, id: \.id) { member in
                    Button(action: {
                        selectedMember = member
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                            showMemberDetails = true
                        }
                    }) {
                        modernFamilyMemberCard(member)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                
                modernAddMemberButton
            }
            .padding(.horizontal, 20)
        }
    }
    
    private func loadFamilyMembers() {
        if let dependentsData = UserDefaults.standard.data(forKey: "dependents"),
           let dependents = try? JSONDecoder().decode([Dependent].self, from: dependentsData) {
            let colors: [Color] = [.orange, .purple, .pink, .blue, .green, .red, .indigo, .teal]
            familyMembers = dependents.enumerated().map { index, dep in
                FamilyMember(dependent: dep, color: colors[index % colors.count])
            }
        } else {
            familyMembers = []
        }
    }
    
    private func modernFamilyMemberCard(_ member: FamilyMember) -> some View {
        VStack(spacing: 0) {
            // Top gradient section
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [member.avatarColor.opacity(0.8), member.avatarColor]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(height: 100)
                
                Circle()
                    .fill(Color.white.opacity(0.3))
                    .frame(width: 60, height: 60)
                    .overlay(
                        Image(systemName: "person.fill")
                            .font(.system(size: 24, weight: .medium))
                            .foregroundColor(.white)
                    )
            }
            .clipped()
            
            // Bottom info section
            VStack(spacing: 6) {
                Text(member.name)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.black)
                    .lineLimit(1)
                
                Text(member.relationship)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.gray)
                    .lineLimit(1)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 16)
            .frame(maxWidth: .infinity)
            .background(Color.white)
        }
        .frame(width: 140)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 4)
        .scaleEffect(1.0)
        .animation(.easeInOut(duration: 0.1), value: member.id)
    }
    
    private var modernAddMemberButton: some View {
        Button(action: {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                showAddMember = true
            }
        }) {
            VStack(spacing: 0) {
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.gray.opacity(0.1), Color.gray.opacity(0.2)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(height: 100)
                    
                    ZStack {
                        Circle()
                            .fill(Color.white)
                            .frame(width: 60, height: 60)
                            .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                        
                        Image(systemName: "plus")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.blue)
                    }
                }
                .clipped()
                
                VStack(spacing: 6) {
                    Text("Add Member")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.blue)
                    
                    Text("Invite family")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.gray)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 16)
                .frame(maxWidth: .infinity)
                .background(Color.white)
            }
            .frame(width: 140)
            .background(Color.white)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.blue.opacity(0.3), lineWidth: 1.5)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.blue.opacity(0.1), lineWidth: 3)
                    )
            )
            .shadow(color: .blue.opacity(0.1), radius: 8, x: 0, y: 4)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var pastAppointmentsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            pastAppointmentsHeader
            pastAppointmentsList
        }
    }
    
    private var pastAppointmentsHeader: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Recent Activity")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.black)
                
                Text("Family appointments & visits")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Button(action: {}) {
                HStack(spacing: 6) {
                    Text("View all")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.blue)
                    
                    Image(systemName: "arrow.right")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.blue)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color.blue.opacity(0.1))
                .cornerRadius(12)
            }
        }
        .padding(.horizontal, 20)
    }
    
    private var pastAppointmentsList: some View {
        VStack(spacing: 12) {
            if isLoadingFamilyAppointments {
                loadingAppointmentsView
            } else if familyAppointments.isEmpty {
                modernEmptyAppointmentsView
            } else {
                ForEach(familyAppointments.prefix(3), id: \.id) { appointment in
                    Button(action: {
                        selectedAppointment = appointment
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                            showAppointmentDetails = true
                        }
                    }) {
                        modernPastAppointmentCard(appointment)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
        .padding(.horizontal, 20)
    }
    
    private var loadingAppointmentsView: some View {
        VStack(spacing: 16) {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                .scaleEffect(1.2)
            
            Text("Loading family activities...")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 50)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
    
    private func modernPastAppointmentCard(_ appointment: PastAppointment) -> some View {
        HStack(spacing: 16) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.blue.opacity(0.2), Color.blue.opacity(0.4)]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 50, height: 50)
                
                Image(systemName: "calendar.badge.checkmark")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.blue)
            }
            
            VStack(alignment: .leading, spacing: 6) {
                Text(appointment.title)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.black)
                    .lineLimit(1)
                
                Text(appointment.doctor)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(.gray)
                    .lineLimit(1)
                
                HStack(spacing: 8) {
                    Image(systemName: "clock")
                        .font(.system(size: 12))
                        .foregroundColor(.blue)
                    
                    Text(appointment.date)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.blue)
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color.blue.opacity(0.1))
                .cornerRadius(8)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.gray.opacity(0.6))
        }
        .padding(20)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
    
    private var modernEmptyAppointmentsView: some View {
        VStack(spacing: 20) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.gray.opacity(0.1), Color.gray.opacity(0.2)]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 80, height: 80)
                
                Image(systemName: "calendar.badge.plus")
                    .font(.system(size: 32, weight: .medium))
                    .foregroundColor(.gray)
            }
            
            VStack(spacing: 8) {
                Text("No Recent Activity")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.black)
                
                Text("Family appointments and visits will appear here")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
            
            Button(action: {}) {
                HStack(spacing: 8) {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 16))
                        .foregroundColor(.blue)
                    
                    Text("Schedule Appointment")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.blue)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(Color.blue.opacity(0.1))
                .cornerRadius(12)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 50)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
    
    private func fetchFamilyAppointments() {
        isLoadingFamilyAppointments = true
        familyAppointments = []
        
        guard let dependentsData = UserDefaults.standard.data(forKey: "dependents"),
              let dependents = try? JSONDecoder().decode([Dependent].self, from: dependentsData) else {
            isLoadingFamilyAppointments = false
            return
        }
        
        let group = DispatchGroup()
        var allAppointments: [PastAppointment] = []
        
        for dependent in dependents {
            group.enter()
            let urlString = "https://mediaccess.vercel.app/api/appointment/all?patientId=\(dependent.id)"
            guard let url = URL(string: urlString) else {
                group.leave()
                continue
            }
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                defer { group.leave() }
                if let data = data {
                    do {
                        struct AppointmentDetail: Codable, Identifiable {
                            let id: String
                            let title: String
                            let doctor: String
                            let date: String
                        }
                        struct AppointmentsResponse: Codable {
                            let appointments: [AppointmentDetail]
                        }
                        let response = try JSONDecoder().decode(AppointmentsResponse.self, from: data)
                        let mapped = response.appointments.map {
                            PastAppointment(title: $0.title, doctor: $0.doctor, date: $0.date)
                        }
                        allAppointments.append(contentsOf: mapped)
                    } catch {
                    }
                }
            }.resume()
        }
        
        group.notify(queue: .main) {
            self.familyAppointments = allAppointments
            self.isLoadingFamilyAppointments = false
        }
    }
    
    private var overlaysContent: some View {
        ZStack {
            if showMemberDetails, let member = selectedMember {
                FamilyMemberDetailsView(
                    member: member,
                    onBackTapped: {
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                            showMemberDetails = false
                        }
                    }
                )
                .transition(.asymmetric(
                    insertion: .move(edge: .trailing),
                    removal: .move(edge: .trailing)
                ))
            }
            
            if showAddMember {
                AddFamilyMemberView(
                    onBackTapped: {
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                            showAddMember = false
                        }
                    }
                )
                .transition(.asymmetric(
                    insertion: .move(edge: .trailing),
                    removal: .move(edge: .trailing)
                ))
            }
            
            if showAppointmentDetails, let appointment = selectedAppointment {
                AppointmentDetailView(
                    appointment: appointment,
                    onBackTapped: {
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                            showAppointmentDetails = false
                        }
                    }
                )
                .transition(.asymmetric(
                    insertion: .move(edge: .trailing),
                    removal: .move(edge: .trailing)
                ))
            }
            
            if showLabReportDetails, let report = selectedLabReport {
                LabReportDetailView(
                    report: report,
                    onBackTapped: {
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                            showLabReportDetails = false
                        }
                    }
                )
                .transition(.asymmetric(
                    insertion: .move(edge: .trailing),
                    removal: .move(edge: .trailing)
                ))
            }
        }
    }
}

struct PastAppointment: Identifiable {
    let id = UUID()
    let title: String
    let doctor: String
    let date: String
    
    static let sampleData = [
        PastAppointment(title: "Annual Checkup", doctor: "Dr. Emily Clark", date: "Jan 15, 2024"),
        PastAppointment(title: "Vaccination", doctor: "Dr. Michael Brown", date: "Oct 22, 2023")
    ]
}

struct LabReport: Identifiable {
    let id = UUID()
    let title: String
    let type: String
    let date: String
    
    static let sampleData = [
        LabReport(title: "Routine Blood Work", type: "Blood Test", date: "Dec 5, 2023")
    ]
}

#Preview{
    FamilyView()
}

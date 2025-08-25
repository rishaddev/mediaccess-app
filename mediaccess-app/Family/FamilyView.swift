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
            fetchFamilyAppointments()
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
                familyMembersSection
                pastAppointmentsSection
                Spacer(minLength: 100)
            }
            .padding(.top, 10)
        }
    }
    
    private var familyMembersSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            familyMembersHeader
            familyMembersScrollView
        }
    }
    
    private var familyMembersHeader: some View {
        HStack {
            Text("Family Members")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.black)
        }
        .padding(.horizontal, 20)
    }
    
    private var familyMembersScrollView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(familyMembers, id: \.id) { member in
                    Button(action: {
                        selectedMember = member
                        withAnimation(.easeInOut(duration: 0.3)) {
                            showMemberDetails = true
                        }
                    }) {
                        familyMemberCard(member)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                
                addFamilyMemberButton
            }
            .padding(.horizontal, 20)
        }
    }
    
    private func loadFamilyMembers() {
        if let dependentsData = UserDefaults.standard.data(forKey: "dependents"),
           let dependents = try? JSONDecoder().decode([Dependent].self, from: dependentsData) {
            // Optionally assign different colors for each member
            let colors: [Color] = [.orange.opacity(0.7), .brown.opacity(0.7), .pink.opacity(0.7), .blue.opacity(0.7), .green.opacity(0.7)]
            familyMembers = dependents.enumerated().map { index, dep in
                FamilyMember(dependent: dep, color: colors[index % colors.count])
            }
        } else {
            familyMembers = []
        }
    }
    
    private func familyMemberCard(_ member: FamilyMember) -> some View {
        VStack(spacing: 12) {
            Circle()
                .fill(member.avatarColor)
                .frame(width: 80, height: 80)
                .overlay(
                    Image(systemName: "person.fill")
                        .font(.system(size: 30))
                        .foregroundColor(.white.opacity(0.8))
                )
                .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
            
            VStack(spacing: 2) {
                Text(member.name)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.black)
                    .lineLimit(1)
                
                Text(member.relationship)
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                    .lineLimit(1)
            }
        }
        .frame(width: 120)
        .padding(.vertical, 12)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
    
    private var addFamilyMemberButton: some View {
        Button(action: {
            showAddMember = true
        }) {
            VStack(spacing: 12) {
                Circle()
                    .fill(Color.blue.opacity(0.1))
                    .frame(width: 60, height: 60)
                    .overlay(
                        Image(systemName: "plus")
                            .font(.system(size: 24, weight: .medium))
                            .foregroundColor(.blue)
                    )
                    .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                
                Text("Add Member")
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(.blue)
                    .multilineTextAlignment(.center)
            }
            .frame(width: 100)
            .padding(.vertical, 12)
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
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
            Text("Past Appointments")
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
    
    private var pastAppointmentsList: some View {
        VStack(spacing: 12) {
            if isLoadingFamilyAppointments {
                ProgressView("Loading appointments...")
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 40)
            } else if familyAppointments.isEmpty {
                emptyAppointmentsView
            } else {
                ForEach(familyAppointments.prefix(3), id: \.id) { appointment in
                    Button(action: {
                        selectedAppointment = appointment
                        withAnimation(.easeInOut(duration: 0.3)) {
                            showAppointmentDetails = true
                        }
                    }) {
                        pastAppointmentCard(appointment)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
        .padding(.horizontal, 20)
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
                        // Ignore errors for individual dependents
                    }
                }
            }.resume()
        }
        
        group.notify(queue: .main) {
            self.familyAppointments = allAppointments
            self.isLoadingFamilyAppointments = false
        }
    }
    
    private func pastAppointmentCard(_ appointment: PastAppointment) -> some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(Color.blue.opacity(0.1))
                    .frame(width: 40, height: 40)
                
                Image(systemName: "calendar")
                    .font(.system(size: 18))
                    .foregroundColor(.blue)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(appointment.title)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.black)
                
                Text(appointment.doctor)
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                
                Text(appointment.date)
                    .font(.system(size: 12))
                    .foregroundColor(.blue)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.blue.opacity(0.1))
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
            
            Text("No past appointments")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.gray)
            
            Text("Your appointment history will appear here")
                .font(.system(size: 14))
                .foregroundColor(.gray.opacity(0.7))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
        .background(Color.white)
        .cornerRadius(12)
    }
    
    
    private var overlaysContent: some View {
        ZStack {
            if showMemberDetails, let member = selectedMember {
                FamilyMemberDetailsView(
                    member: member,
                    onBackTapped: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            showMemberDetails = false
                        }
                    }
                )
                .transition(.move(edge: .trailing))
            }
            
            // Add Member Form Overlay
            if showAddMember {
                AddFamilyMemberView(
                    onBackTapped: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            showAddMember = false
                        }
                    }
                )
                .transition(.move(edge: .trailing))
            }
            
            // Appointment Details Overlay
            if showAppointmentDetails, let appointment = selectedAppointment {
                AppointmentDetailView(
                    appointment: appointment,
                    onBackTapped: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            showAppointmentDetails = false
                        }
                    }
                )
                .transition(.move(edge: .trailing))
            }
            
            // Lab Report Details Overlay
            if showLabReportDetails, let report = selectedLabReport {
                LabReportDetailView(
                    report: report,
                    onBackTapped: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            showLabReportDetails = false
                        }
                    }
                )
                .transition(.move(edge: .trailing))
            }
        }
    }
}

// struct FamilyMember: Identifiable {
//     let id = UUID()
//     let name: String
//     let relationship: String
//     let avatarColor: Color

//     static let sampleData = [
//         FamilyMember(name: "Sophia Carter", relationship: "Wife", avatarColor: Color.orange.opacity(0.7)),
//         FamilyMember(name: "Ethan Carter", relationship: "Son", avatarColor: Color.brown.opacity(0.7)),
//         FamilyMember(name: "Olivia Carter", relationship: "Daughter", avatarColor: Color.pink.opacity(0.7))
//     ]
// }

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

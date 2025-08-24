import SwiftUI

struct FamilyView: View {
    @State private var showAddMember = false
    @State private var showAppointmentDetails = false
    @State private var showLabReportDetails = false
    @State private var showMemberDetails = false
    @State private var selectedAppointment: PastAppointment?
    @State private var selectedLabReport: LabReport?
    @State private var selectedMember: FamilyMember?
    
    var body: some View {
        ZStack {
            mainContent
            overlaysContent
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
                labReportsSection
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
            Spacer()
            Button(action: {}) {
                Text("Manage")
                    .font(.system(size: 14))
                    .foregroundColor(.blue)
            }
        }
        .padding(.horizontal, 20)
    }
    
    private var familyMembersScrollView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(FamilyMember.sampleData, id: \.id) { member in
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
                    .frame(width: 80, height: 80)
                    .overlay(
                        Image(systemName: "plus")
                            .font(.system(size: 24, weight: .medium))
                            .foregroundColor(.blue)
                    )
                    .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                
                Text("Add Member")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.blue)
                    .multilineTextAlignment(.center)
            }
            .frame(width: 100)
            .padding(.vertical, 12)
            .background(Color.white)
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
            if PastAppointment.sampleData.isEmpty {
                emptyAppointmentsView
            } else {
                ForEach(PastAppointment.sampleData.prefix(3), id: \.id) { appointment in
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
    
    private var labReportsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            labReportsHeader
            labReportsList
        }
    }
    
    private var labReportsHeader: some View {
        HStack {
            Text("Lab Reports")
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
    }
    
    private var labReportsList: some View {
        VStack(spacing: 12) {
            if LabReport.sampleData.isEmpty {
                emptyLabReportsView
            } else {
                ForEach(LabReport.sampleData.prefix(3), id: \.id) { report in
                    Button(action: {
                        selectedLabReport = report
                        withAnimation(.easeInOut(duration: 0.3)) {
                            showLabReportDetails = true
                        }
                    }) {
                        labReportCard(report)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
        .padding(.horizontal, 20)
    }
    
    private func labReportCard(_ report: LabReport) -> some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(Color.green.opacity(0.1))
                    .frame(width: 40, height: 40)
                
                Image(systemName: "doc.text")
                    .font(.system(size: 18))
                    .foregroundColor(.green)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(report.title)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.black)
                
                Text(report.type)
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                
                Text(report.date)
                    .font(.system(size: 12))
                    .foregroundColor(.green)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
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
    
    private var emptyLabReportsView: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(Color.gray.opacity(0.1))
                    .frame(width: 60, height: 60)
                
                Image(systemName: "doc.text")
                    .font(.system(size: 24))
                    .foregroundColor(.gray)
            }
            
            Text("No lab reports available")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.gray)
            
            Text("Lab results will be shown here")
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
            // Member Details Overlay
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

// MARK: - Data Models
struct FamilyMember: Identifiable {
    let id = UUID()
    let name: String
    let relationship: String
    let avatarColor: Color
    
    static let sampleData = [
        FamilyMember(name: "Sophia Carter", relationship: "Wife, 32", avatarColor: Color.orange.opacity(0.7)),
        FamilyMember(name: "Ethan Carter", relationship: "Son, 5", avatarColor: Color.brown.opacity(0.7)),
        FamilyMember(name: "Olivia Carter", relationship: "Daughter, 8", avatarColor: Color.pink.opacity(0.7))
    ]
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

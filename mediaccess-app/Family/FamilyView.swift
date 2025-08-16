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
            // Main Family View
            VStack(spacing: 0) {
                // Header
                HStack {
                    Button(action: {
                        // Handle back navigation - this will be handled by parent
                    }) {
                        Image(systemName: "arrow.left")
                            .font(.title2)
                            .foregroundColor(.black)
                    }
                    
                    Spacer()
                    
                    Text("Family")
                        .font(.headline)
                        .fontWeight(.medium)
                    
                    Spacer()
                    
                    // Empty space to center the title
                    Color.clear
                        .frame(width: 24, height: 24)
                }
                .padding(.horizontal)
                .padding(.top, 20)
                .padding(.bottom, 20)
                
                ScrollView {
                    VStack(spacing: 32) {
                        // Family Members Section
                        VStack(alignment: .leading, spacing: 20) {
                            HStack {
                                Text("Family Members")
                                    .font(.system(size: 28, weight: .semibold))
                                    .foregroundColor(.black)
                                Spacer()
                            }
                            .padding(.horizontal, 20)
                            
                            // Family members scroll view
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 16) {
                                    ForEach(FamilyMember.sampleData, id: \.id) { member in
                                        Button(action: {
                                            selectedMember = member
                                            withAnimation(.easeInOut(duration: 0.3)) {
                                                showMemberDetails = true
                                            }
                                        }) {
                                            VStack(spacing: 12) {
                                                // Profile picture
                                                Circle()
                                                    .fill(member.avatarColor)
                                                    .frame(width: 80, height: 80)
                                                    .overlay(
                                                        Image(systemName: "person.fill")
                                                            .font(.system(size: 30))
                                                            .foregroundColor(.white.opacity(0.8))
                                                    )
                                                
                                                VStack(spacing: 2) {
                                                    Text(member.name)
                                                        .font(.system(size: 16, weight: .medium))
                                                        .foregroundColor(.black)
                                                    
                                                    Text(member.relationship)
                                                        .font(.system(size: 14))
                                                        .foregroundColor(.gray)
                                                }
                                            }
                                            .frame(width: 120)
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                    }
                                    
                                    // Add Family Member Button
                                    Button(action: {
                                        showAddMember = true
                                    }) {
                                        VStack(spacing: 12) {
                                            Circle()
                                                .fill(Color.gray.opacity(0.1))
                                                .frame(width: 80, height: 80)
                                                .overlay(
                                                    Image(systemName: "plus")
                                                        .font(.system(size: 24, weight: .medium))
                                                        .foregroundColor(.black)
                                                )
                                            
                                            Text("Add Family Member")
                                                .font(.system(size: 14, weight: .medium))
                                                .foregroundColor(.black)
                                                .multilineTextAlignment(.center)
                                        }
                                        .frame(width: 100)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                                .padding(.horizontal, 20)
                            }
                        }
                        
                        // Past Appointments Section
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Text("Past Appointments")
                                    .font(.system(size: 20, weight: .semibold))
                                    .foregroundColor(.black)
                                Spacer()
                            }
                            .padding(.horizontal, 20)
                            
                            VStack(spacing: 12) {
                                ForEach(PastAppointment.sampleData, id: \.id) { appointment in
                                    Button(action: {
                                        selectedAppointment = appointment
                                        withAnimation(.easeInOut(duration: 0.3)) {
                                            showAppointmentDetails = true
                                        }
                                    }) {
                                        HStack(spacing: 16) {
                                            // Calendar icon
                                            RoundedRectangle(cornerRadius: 8)
                                                .fill(Color.gray.opacity(0.1))
                                                .frame(width: 40, height: 40)
                                                .overlay(
                                                    Image(systemName: "calendar")
                                                        .font(.system(size: 18))
                                                        .foregroundColor(.gray)
                                                )
                                            
                                            VStack(alignment: .leading, spacing: 2) {
                                                Text(appointment.title)
                                                    .font(.system(size: 16, weight: .medium))
                                                    .foregroundColor(.black)
                                                
                                                Text(appointment.doctor)
                                                    .font(.system(size: 14))
                                                    .foregroundColor(.gray)
                                            }
                                            
                                            Spacer()
                                            
                                            Text(appointment.date)
                                                .font(.system(size: 14, weight: .medium))
                                                .foregroundColor(.gray)
                                        }
                                        .padding(16)
                                        .background(Color.gray.opacity(0.05))
                                        .cornerRadius(12)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                        
                        // Lab Reports Section
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Text("Lab Reports")
                                    .font(.system(size: 20, weight: .semibold))
                                    .foregroundColor(.black)
                                Spacer()
                            }
                            .padding(.horizontal, 20)
                            
                            VStack(spacing: 12) {
                                ForEach(LabReport.sampleData, id: \.id) { report in
                                    Button(action: {
                                        selectedLabReport = report
                                        withAnimation(.easeInOut(duration: 0.3)) {
                                            showLabReportDetails = true
                                        }
                                    }) {
                                        HStack(spacing: 16) {
                                            // Document icon
                                            RoundedRectangle(cornerRadius: 8)
                                                .fill(Color.gray.opacity(0.1))
                                                .frame(width: 40, height: 40)
                                                .overlay(
                                                    Image(systemName: "doc.text")
                                                        .font(.system(size: 18))
                                                        .foregroundColor(.gray)
                                                )
                                            
                                            VStack(alignment: .leading, spacing: 2) {
                                                Text(report.title)
                                                    .font(.system(size: 16, weight: .medium))
                                                    .foregroundColor(.black)
                                                
                                                Text(report.type)
                                                    .font(.system(size: 14))
                                                    .foregroundColor(.gray)
                                            }
                                            
                                            Spacer()
                                            
                                            Text(report.date)
                                                .font(.system(size: 14, weight: .medium))
                                                .foregroundColor(.gray)
                                        }
                                        .padding(16)
                                        .background(Color.gray.opacity(0.05))
                                        .cornerRadius(12)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.top, 10)
                }
            }
            .background(Color.white)
            .opacity(showAddMember || showAppointmentDetails || showLabReportDetails || showMemberDetails ? 0 : 1)
            
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
//        .sheet(isPresented: $showAddMember) {
//            AddFamilyMemberView(onBackTapped: {
//                showAddMember = false
//            })
//        }
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

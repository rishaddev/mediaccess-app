import SwiftUI

struct FamilyMemberDetailsView: View {
    let member: FamilyMember
    let onBackTapped: () -> Void
    @State private var selectedTab = 0
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Button(action: onBackTapped) {
                    Image(systemName: "arrow.left")
                        .font(.title2)
                        .foregroundColor(.black)
                }
                
                Spacer()
                
                Text("Family Member Details")
                    .font(.headline)
                    .fontWeight(.medium)
                
                Spacer()
                
                Color.clear
                    .frame(width: 24, height: 24)
            }
            .padding(.horizontal)
            .padding(.top, 20)
            .padding(.bottom, 20)
            
            ScrollView {
                VStack(spacing: 24) {
                    // Profile Section
                    VStack(spacing: 16) {
                        // Profile picture
                        Circle()
                            .fill(member.avatarColor)
                            .frame(width: 120, height: 120)
                            .overlay(
                                Image(systemName: "person.fill")
                                    .font(.system(size: 40))
                                    .foregroundColor(.white.opacity(0.8))
                            )
                        
                        VStack(spacing: 8) {
                            Text(member.name)
                                .font(.system(size: 24, weight: .semibold))
                                .foregroundColor(.black)
                            
                            Text("Age: \(member.age)")
                                .font(.system(size: 16))
                                .foregroundColor(.gray)
                            
                            Text("Relation: \(member.relationshipType)")
                                .font(.system(size: 16))
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.top, 20)
                    
                    // Tab Navigation
                    VStack(spacing: 0) {
                        HStack(spacing: 0) {
                            TabButton(title: "Overview", isSelected: selectedTab == 0) {
                                selectedTab = 0
                            }
                            TabButton(title: "Appointments", isSelected: selectedTab == 1) {
                                selectedTab = 1
                            }
                            TabButton(title: "Home Visits", isSelected: selectedTab == 2) {
                                selectedTab = 2
                            }
                            TabButton(title: "Pharmacy", isSelected: selectedTab == 3) {
                                selectedTab = 3
                            }
                        }
                        
                        // Tab indicator line
                        HStack {
                            Rectangle()
                                .fill(selectedTab == 0 ? Color.black : Color.clear)
                                .frame(height: 2)
                            Rectangle()
                                .fill(selectedTab == 1 ? Color.black : Color.clear)
                                .frame(height: 2)
                            Rectangle()
                                .fill(selectedTab == 2 ? Color.black : Color.clear)
                                .frame(height: 2)
                            Rectangle()
                                .fill(selectedTab == 3 ? Color.black : Color.clear)
                                .frame(height: 2)
                        }
                    }
                    .padding(.horizontal, 12)
                    
                    // Tab Content
                    Group {
                        switch selectedTab {
                        case 0:
                            OverviewTabContent(member: member)
                        case 1:
                            AppointmentsTabContent(member: member)
                        case 2:
                            HomeVisitsTabContent(member: member)
                        case 3:
                            PharmacyTabContent(member: member)
                        default:
                            OverviewTabContent(member: member)
                        }
                    }
                    .animation(.easeInOut(duration: 0.2), value: selectedTab)
                    
                    Spacer(minLength: 100)
                }
            }
        }
        .background(Color.white)
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
                .foregroundColor(isSelected ? .black : .gray)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
        }
        
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Tab Content Views

struct OverviewTabContent: View {
    let member: FamilyMember
    
    var body: some View {
        VStack(spacing: 24) {
            // Upcoming Appointments
            SectionCard(title: "Upcoming Appointments") {
                VStack(spacing: 12) {
                    ForEach(member.upcomingAppointments, id: \.id) { appointment in
                        AppointmentRow(
                            icon: "calendar",
                            title: appointment.title,
                            subtitle: appointment.doctor,
                            date: appointment.date
                        )
                    }
                }
            }
            
            // Past Appointments
            SectionCard(title: "Past Appointments") {
                VStack(spacing: 12) {
                    ForEach(member.pastAppointments, id: \.id) { appointment in
                        AppointmentRow(
                            icon: "calendar",
                            title: appointment.title,
                            subtitle: appointment.doctor,
                            date: appointment.date
                        )
                    }
                }
            }
            
            // Scheduled Home Visits
            SectionCard(title: "Scheduled Home Visits") {
                VStack(spacing: 12) {
                    ForEach(member.homeVisits, id: \.id) { visit in
                        AppointmentRow(
                            icon: "house",
                            title: visit.title,
                            subtitle: visit.provider,
                            date: visit.date
                        )
                    }
                }
            }
            
            // Pharmacy Orders
            SectionCard(title: "Pharmacy Orders") {
                VStack(spacing: 12) {
                    ForEach(member.pharmacyOrders, id: \.id) { order in
                        AppointmentRow(
                            icon: "pills",
                            title: order.title,
                            subtitle: order.orderNumber,
                            date: order.date
                        )
                    }
                }
            }
        }
        .padding(.horizontal, 20)
    }
}

struct AppointmentsTabContent: View {
    let member: FamilyMember
    
    var body: some View {
        VStack(spacing: 24) {
            SectionCard(title: "All Appointments") {
                VStack(spacing: 12) {
                    ForEach(member.upcomingAppointments + member.pastAppointments, id: \.id) { appointment in
                        AppointmentRow(
                            icon: "calendar",
                            title: appointment.title,
                            subtitle: appointment.doctor,
                            date: appointment.date
                        )
                    }
                }
            }
        }
        .padding(.horizontal, 20)
    }
}

struct HomeVisitsTabContent: View {
    let member: FamilyMember
    
    var body: some View {
        VStack(spacing: 24) {
            SectionCard(title: "All Home Visits") {
                VStack(spacing: 12) {
                    ForEach(member.homeVisits, id: \.id) { visit in
                        AppointmentRow(
                            icon: "house",
                            title: visit.title,
                            subtitle: visit.provider,
                            date: visit.date
                        )
                    }
                }
            }
        }
        .padding(.horizontal, 20)
    }
}

struct PharmacyTabContent: View {
    let member: FamilyMember
    
    var body: some View {
        VStack(spacing: 24) {
            SectionCard(title: "All Orders") {
                VStack(spacing: 12) {
                    ForEach(member.pharmacyOrders, id: \.id) { order in
                        AppointmentRow(
                            icon: "pills",
                            title: order.title,
                            subtitle: order.orderNumber,
                            date: order.date
                        )
                    }
                }
            }
        }
        .padding(.horizontal, 20)
    }
}

// MARK: - Reusable Components

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
    }
}

struct AppointmentRow: View {
    let icon: String
    let title: String
    let subtitle: String
    let date: String
    
    var body: some View {
        HStack(spacing: 16) {
            // Icon
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.gray.opacity(0.1))
                .frame(width: 40, height: 40)
                .overlay(
                    Image(systemName: icon)
                        .font(.system(size: 18))
                        .foregroundColor(.gray)
                )
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.black)
                
                Text(subtitle)
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            if !date.isEmpty {
                Text(date)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.gray)
            }
        }
        .padding(12)
        .background(Color.gray.opacity(0.05))
        .cornerRadius(8)
    }
}

// MARK: - Extended Data Models

extension FamilyMember {
    var age: String {
        // Extract age from relationship string or return default
        let components = relationship.split(separator: ",")
        if components.count > 1 {
            return String(components[1].trimmingCharacters(in: .whitespaces))
        }
        return "32"
    }
    
    var relationshipType: String {
        // Extract relationship type from relationship string
        let components = relationship.split(separator: ",")
        return String(components[0])
    }
    
    var upcomingAppointments: [MemberAppointment] {
        return [
            MemberAppointment(id: UUID(), title: "Annual Checkup", doctor: "Dr. Emily Carter", date: "Jan 25, 2024")
        ]
    }
    
    var pastAppointments: [MemberAppointment] {
        return [
            MemberAppointment(id: UUID(), title: "Flu Shot", doctor: "Dr. Michael Brown", date: "Dec 15, 2023")
        ]
    }
    
    var homeVisits: [MemberHomeVisit] {
        return [
            MemberHomeVisit(id: UUID(), title: "Blood Pressure Check", provider: "Nurse Sarah Johnson", date: "Feb 10, 2024")
        ]
    }
    
    var pharmacyOrders: [MemberPharmacyOrder] {
        return [
            MemberPharmacyOrder(id: UUID(), title: "Medication Refill", orderNumber: "Order #12345", date: "Jan 20, 2024")
        ]
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

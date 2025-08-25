import SwiftUI

struct DashboardView: View {
    @State private var showingProfile = false
    @State private var showingHospitalInfo = false
    @State private var showBookAppointment = false
    @State private var showBookHomeVisit = false
    @State private var showServices = false
    @State private var showPlaceNewOrder = false
    
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
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                ScrollView {
                    VStack(spacing: 20) {
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
                        
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("Next Appointment")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.black)
                                Spacer()
                            }
                            
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
                                        Text("Dr. Mark Browns")
                                            .font(.system(size: 18, weight: .semibold))
                                            .foregroundColor(.white)
                                        
                                        Text("Dentist")
                                            .font(.system(size: 14))
                                            .foregroundColor(.white.opacity(0.8))
                                            .padding(.bottom, 20)
                                        
                                        
                                        HStack {
                                            HStack(spacing: 4) {
                                                Image(systemName: "calendar")
                                                    .font(.system(size: 12))
                                                Text("18 August 2025")
                                                    .font(.system(size: 12))
                                            }
                                            
                                            HStack(spacing: 4) {
                                                Image(systemName: "clock")
                                                    .font(.system(size: 12))
                                                Text("04:00 PM")
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
                        }
                        .padding(.horizontal, 20)
                        
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
                        
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("Recent Orders")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(.black)
                                Spacer()
                            }
                            .padding(.horizontal, 20)
                            
                            VStack(spacing: 12) {
                                OrderCardView(
                                    orderNumber: "PH01234",
                                    date: "18 August 2025",
                                    status: "Pending"
                                )
                                
                                OrderCardView(
                                    orderNumber: "PH03456",
                                    date: "17 August 2025",
                                    status: "Delivered"
                                )
                            }
                            .padding(.horizontal, 20)
                            
                        }
                        .padding(.top, 20)
                        
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
                        
                        Spacer(minLength: 100)
                    }
                }
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
                HospitalInformationView() // You will create this view
            }
            .fullScreenCover(isPresented: $showPlaceNewOrder) {
                PlaceNewOrderView()
            }
        }
    }
    
    private func getInitials(from name: String) -> String {
        let components = name.components(separatedBy: " ")
        let initials = components.compactMap { $0.first }.map { String($0) }
        return initials.prefix(2).joined().uppercased()
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
                    .fill(Color.white.opacity(0.6))
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

struct OrderCardView: View {
    let orderNumber: String
    let date: String
    let status: String
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Order No")
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
                
                Text(orderNumber)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.blue)
                Spacer().frame(height: 20)
                
                HStack(spacing: 12) {
                    HStack(spacing: 4) {
                        Image(systemName: "calendar")
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                        Text(date)
                            .font(.system(size: 12))
                    }
                    
                    HStack(spacing: 4) {
                        Image(systemName: "clock")
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                        Text(status)
                            .font(.system(size: 12))
                    }
                }
                .foregroundColor(.blue)
                .padding(10)
                .background(Color.blue.opacity(0.2))
                .cornerRadius(5)
            }
            
            Spacer()
            
            AsyncImage(url: URL(string: "https://via.placeholder.com/60x60")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.orange.opacity(0.1))
                    Image("pills")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 100)
                        .clipped()
                }
            }
            .frame(width: 100, height: 100)
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(12)
    }
}

#Preview {
    DashboardView(onLogout: {})
}

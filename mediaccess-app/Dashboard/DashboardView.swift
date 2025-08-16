import SwiftUI

struct DashboardView: View {
    @State private var showingProfile = false
    @State private var showingHospitalInfo = false
    
    // Logout function passed from parent
    let onLogout: () -> Void
    
    // Get user info from UserDefaults
    private var userEmail: String {
        return UserDefaults.standard.string(forKey: "userEmail") ?? "User"
    }
    
    // Convert email to display name
    private var displayName: String {
        let email = userEmail
        if email.contains("@") {
            // Extract name from email (part before @)
            let username = String(email.split(separator: "@").first ?? "User")
            // Capitalize first letter and replace dots/underscores with spaces
            return username.replacingOccurrences(of: ".", with: " ")
                          .replacingOccurrences(of: "_", with: " ")
                          .capitalized
        }
        return email.capitalized
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Header
                HStack {
                    // Profile Avatar - Now clickable
                    Button(action: {
                        showingProfile = true
                    }) {
                        // Show initials if no profile image
                        ZStack {
                            Circle()
                                .fill(Color.blue.opacity(0.1))
                                .frame(width: 40, height: 40)
                            
                            Text(getInitials(from: displayName))
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.blue)
                        }
                    }
                    
                    Spacer()
                    
                    Text("MediAccess")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                    HStack(spacing: 12) {
                        Button(action: {
                            showingHospitalInfo = true
                        }) {
                            Image(systemName: "house")
                                .font(.title3)
                                .foregroundColor(.black)
                        }
                        
                        Button(action: {}) {
                            Image(systemName: "bell")
                                .font(.title3)
                                .foregroundColor(.black)
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        // Welcome Message - Now dynamic
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Welcome back, \(displayName)")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.black)
                            
                            Text(userEmail)
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        
                        // Upcoming Appointments
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Upcoming Appointments")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.black)
                                .padding(.horizontal, 20)
                            
                            // Doctor Card
                            VStack(spacing: 12) {
                                // Placeholder for doctor image
                                ZStack {
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(Color.blue.opacity(0.1))
                                        .frame(width: 150, height: 150)
                                    
                                    VStack(spacing: 8) {
                                        Image(systemName: "stethoscope")
                                            .font(.system(size: 40))
                                            .foregroundColor(.blue)
                                        
                                        Text("Dr. Avatar")
                                            .font(.system(size: 12))
                                            .foregroundColor(.gray)
                                    }
                                }
                                
                                VStack(spacing: 4) {
                                    Text("Dr. Ethan Carter")
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(.black)
                                    
                                    Text("Today, 10:00 AM")
                                        .font(.system(size: 14))
                                        .foregroundColor(.gray)
                                    
                                    Text("General Practitioner")
                                        .font(.system(size: 14))
                                        .foregroundColor(.gray)
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                        
                        // Recent Pharmacy Orders
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Recent Pharmacy Orders")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.black)
                                .padding(.horizontal, 20)
                            
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Order #12345")
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(.black)
                                    
                                    Text("Delivered")
                                        .font(.system(size: 14))
                                        .foregroundColor(.green)
                                }
                                
                                Spacer()
                                
                                // Medicine bottle icon
                                ZStack {
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color.orange.opacity(0.1))
                                        .frame(width: 50, height: 50)
                                    
                                    Image(systemName: "pills.fill")
                                        .font(.system(size: 24))
                                        .foregroundColor(.orange)
                                }
                            }
                            .padding(16)
                            .background(Color.white)
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                            )
                            .padding(.horizontal, 20)
                        }
                        
                        // Family Profiles
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Family Profiles")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.black)
                                .padding(.horizontal, 20)
                            
                            VStack(spacing: 12) {
                                // Liam Profile
                                HStack {
                                    ZStack {
                                        Circle()
                                            .fill(Color.green.opacity(0.1))
                                            .frame(width: 50, height: 50)
                                        
                                        Text("LS")
                                            .font(.system(size: 16, weight: .semibold))
                                            .foregroundColor(.green)
                                    }
                                    
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("Liam Sharma")
                                            .font(.system(size: 16, weight: .medium))
                                            .foregroundColor(.black)
                                        
                                        Text("Next appointment: 2 weeks")
                                            .font(.system(size: 14))
                                            .foregroundColor(.gray)
                                    }
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 14))
                                        .foregroundColor(.gray)
                                }
                                .padding(16)
                                .background(Color.white)
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                                )
                                
                                // Current User Profile (dynamic)
                                HStack {
                                    ZStack {
                                        Circle()
                                            .fill(Color.blue.opacity(0.1))
                                            .frame(width: 50, height: 50)
                                        
                                        Text(getInitials(from: displayName))
                                            .font(.system(size: 16, weight: .semibold))
                                            .foregroundColor(.blue)
                                    }
                                    
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(displayName)
                                            .font(.system(size: 16, weight: .medium))
                                            .foregroundColor(.black)
                                        
                                        Text("Annual checkup due")
                                            .font(.system(size: 14))
                                            .foregroundColor(.gray)
                                    }
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 14))
                                        .foregroundColor(.gray)
                                }
                                .padding(16)
                                .background(Color.white)
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                                )
                            }
                            .padding(.horizontal, 20)
                        }
                        
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
        }
    }
    
    // Helper function to get initials from name
    private func getInitials(from name: String) -> String {
        let components = name.components(separatedBy: " ")
        let initials = components.compactMap { $0.first }.map { String($0) }
        return initials.prefix(2).joined().uppercased()
    }
}

#Preview {
    DashboardView(onLogout: {})
}

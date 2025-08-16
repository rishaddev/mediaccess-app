import SwiftUI

struct DashboardView: View {
    @State private var showingProfile = false
    @State private var showingHospitalInfo = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Header
                HStack {
                    // Profile Avatar - Now clickable
                    Button(action: {
                        showingProfile = true
                    }) {
                        Image("profile_avatar")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())
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
                        // Welcome Message
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Welcome back, Sophia Carter")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.black)
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
                                Image("doctor_avatar")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 150, height: 150)
                                    .clipShape(RoundedRectangle(cornerRadius: 16))
                                    .background(Color.white)
                                
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
                                        .foregroundColor(.gray)
                                }
                                
                                Spacer()
                                
                                Image("medicine_bottle")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 50, height: 50)
                                    .background(Color.orange.opacity(0.3))
                                    .cornerRadius(8)
                            }
                            .padding(10)
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.gray.opacity(0.2), lineWidth: 1))
                            .padding(.horizontal, 10)
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
                                    Image("liam_avatar")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 50, height: 50)
                                        .clipShape(Circle())
                                        .background(Color.gray.opacity(0.3))
                                        .cornerRadius(10)
                                    
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("Liam Sharma")
                                            .font(.system(size: 16, weight: .medium))
                                            .foregroundColor(.black)
                                        
                                        Text("Next appointment: 2 weeks")
                                            .font(.system(size: 14))
                                            .foregroundColor(.gray)
                                    }
                                    
                                    Spacer()
                                }
                                .padding(10)
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                                )
                                
                                // Sophia Profile
                                HStack {
                                    Image("sophia_avatar")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 50, height: 50)
                                        .clipShape(Circle())
                                        .background(Color.gray.opacity(0.3))
                                        .cornerRadius(10)
                                    
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("Sophia Sharma")
                                            .font(.system(size: 16, weight: .medium))
                                            .foregroundColor(.black)
                                        
                                        Text("Annual checkup due")
                                            .font(.system(size: 14))
                                            .foregroundColor(.gray)
                                    }
                                    
                                    Spacer()
                                }
                                .padding(10)
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                                )
                            }
                            .padding(.horizontal, 10)
                        }
                        
                        Spacer(minLength: 100)
                    }
                }
            }
            .background(Color.white)
            
            .fullScreenCover(isPresented: $showingProfile) {
                ProfileView()
            }
            .fullScreenCover(isPresented: $showingHospitalInfo) {
                HospitalInformationView()
            }
        }
    }
}

#Preview {
    DashboardView()
}

import SwiftUI

struct DashboardView: View {
    var body: some View {
        VStack(spacing: 0) {
                // Header
                HStack {
                    // Profile Avatar
                    Image("profile_avatar")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                    
                    Spacer()
                    
                    Text("MediAccess")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                    HStack(spacing: 12) {
                        Button(action: {}) {
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
                                    .frame(width: 120, height: 120)
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
                                    .cornerRadius(12)
                            }
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
                                    Image("liam_avatar")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 50, height: 50)
                                        .clipShape(Circle())
                                        .background(Color.gray.opacity(0.3))
                                    
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
                                
                                // Sophia Profile
                                HStack {
                                    Image("sophia_avatar")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 50, height: 50)
                                        .clipShape(Circle())
                                        .background(Color.gray.opacity(0.3))
                                    
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
                            }
                            .padding(.horizontal, 20)
                        }
                        
                        Spacer(minLength: 100)
                    }
                }
                
                // Bottom Tab Bar - Now handled by CustomNavigationBar
                // This section can be removed as navigation is handled by ContentView
            }
            .background(Color.white)
    }
}

struct TabBarItem: View {
    let icon: String
    let title: String
    let isSelected: Bool
    
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(isSelected ? .blue : .gray)
            
            Text(title)
                .font(.system(size: 12))
                .foregroundColor(isSelected ? .blue : .gray)
        }
        .frame(maxWidth: .infinity)
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}

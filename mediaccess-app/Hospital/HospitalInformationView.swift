import SwiftUI

struct HospitalInformationView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var showingCharges = false
    @State private var showingLocations = false
    @State private var showingHelpSupport = false
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: {
                    dismiss()
                }) {
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
                
                Text("Hospital Information")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.black)
                
                Spacer()
                
                Circle()
                    .fill(Color.clear)
                    .frame(width: 40, height: 40)
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)
            
            ScrollView {
                VStack(spacing: 0) {
                    HospitalInfoCard(
                        icon: "dollarsign.circle.fill",
                        title: "Hospital Charges",
                        subtitle: "View medical test prices",
                        action: {
                            showingCharges = true
                        }
                    )
                    
                    Spacer()
                        .frame(height: 12)
                    
                    HospitalInfoCard(
                        icon: "location.fill",
                        title: "Locations",
                        subtitle: "Find nearby hospitals",
                        action: {
                            showingLocations = true
                        }
                    )
                    
                    Spacer()
                        .frame(height: 12)
                    
                    HospitalInfoCard(
                        icon: "questionmark.circle.fill",
                        title: "Help & Support",
                        subtitle: "Get assistance and support",
                        action: {
                            showingHelpSupport = true
                        }
                    )
                }
                .padding(.top, 20)
                .padding(.bottom, 20)
            }
        }
        .background(Color(.systemGroupedBackground))
        .fullScreenCover(isPresented: $showingCharges) {
            HospitalChargesView()
        }
        .fullScreenCover(isPresented: $showingLocations) {
            LocationsView()
        }
        .fullScreenCover(isPresented: $showingHelpSupport) {
            HelpSupportView()
        }
    }
}

struct HospitalInfoCard: View {
    let icon: String
    let title: String
    let subtitle: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(Color.blue.opacity(0.1))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: icon)
                        .font(.system(size: 20))
                        .foregroundColor(.blue)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.black)
                    
                    Text(subtitle)
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
            .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
        }
        .buttonStyle(PlainButtonStyle())
        .padding(.horizontal, 20)
    }
}

#Preview {
    HospitalInformationView()
}

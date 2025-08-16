import SwiftUI

struct HospitalInformationView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var showingCharges = false
    @State private var showingLocations = false
    @State private var showingHelpSupport = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "arrow.left")
                        .font(.title2)
                        .foregroundColor(.black)
                }
                
                Spacer()
                
                Text("Hospital Information")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.black)
                
                Spacer()
                
                // Empty space to balance the header
                Image(systemName: "arrow.left")
                    .font(.title2)
                    .foregroundColor(.clear)
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)
            
            VStack(spacing: 0) {
                HospitalInfoRow(
                    icon: "dollarsign.circle",
                    title: "Hospital Charges",
                    action: {
                        showingCharges = true
                    }
                )
                
                Divider()
                    .padding(.leading, 70)
                
                HospitalInfoRow(
                    icon: "location",
                    title: "Locations",
                    action: {
                        showingLocations = true
                    }
                )
                
                Divider()
                    .padding(.leading, 70)
                
                HospitalInfoRow(
                    icon: "questionmark.circle",
                    title: "Help & Support",
                    action: {
                        showingHelpSupport = true
                    }
                )
            }
            .padding(.top, 30)
            
            Spacer()
        }
        .background(Color.white)
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

struct HospitalInfoRow: View {
    let icon: String
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(.black)
                    .frame(width: 30)
                
                Text(title)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.black)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

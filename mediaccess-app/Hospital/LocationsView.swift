import SwiftUI

struct LocationsView: View {
    @Environment(\.dismiss) private var dismiss
    
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
                
                Text("Locations")
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
            
            ScrollView {
                VStack(spacing: 24) {
                    LocationCard(locationName: "Colombo")
                    LocationCard(locationName: "Gampaha")
                }
                .padding(.top, 20)
            }
        }
        .background(Color.white)
    }
}

struct LocationCard: View {
    let locationName: String
    
    var body: some View {
        HStack(spacing: 16) {
            Text(locationName)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.black)
            
            Spacer()
            
            // Hospital Image
            Image("hospital_building")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 120, height: 80)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .background(Color.blue.opacity(0.2))
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    LocationsView()
}

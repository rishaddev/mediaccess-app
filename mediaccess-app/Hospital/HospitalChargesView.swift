import SwiftUI

struct HospitalChargesView: View {
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
                
                Text("Hospital Charges")
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
                VStack(spacing: 16) {
                    ForEach(0..<3, id: \.self) { index in
                        HStack(spacing: 16) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Test Name")
                                    .font(.system(size: 14))
                                    .foregroundColor(.gray)
                                
                                Text("$250")
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(.black)
                                
                                Text("Price")
                                    .font(.system(size: 14))
                                    .foregroundColor(.gray)
                            }
                            
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
                        .padding(.vertical, 12)
                        
                        if index < 2 {
                            Divider()
                                .padding(.horizontal, 20)
                        }
                    }
                }
                .padding(.top, 20)
            }
        }
        .background(Color.white)
    }
}

#Preview {
    HospitalChargesView()
}

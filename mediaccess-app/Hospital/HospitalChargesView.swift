import SwiftUI

struct HospitalCharge {
    let id = UUID()
    let testName: String
    let price: Double
    let iconName: String
    let category: String
}

struct HospitalChargesView: View {
    @Environment(\.dismiss) private var dismiss
    
    private let charges: [HospitalCharge] = [
        HospitalCharge(testName: "Blood Test", price: 85.00, iconName: "drop.fill", category: "Laboratory"),
        HospitalCharge(testName: "X-Ray Chest", price: 150.00, iconName: "xmark.seal.fill", category: "Radiology"),
        HospitalCharge(testName: "ECG", price: 120.00, iconName: "waveform.path.ecg", category: "Cardiology"),
        HospitalCharge(testName: "MRI Scan", price: 850.00, iconName: "brain.head.profile", category: "Radiology"),
        HospitalCharge(testName: "Ultrasound", price: 200.00, iconName: "dot.radiowaves.up.forward", category: "Radiology"),
        HospitalCharge(testName: "CT Scan", price: 650.00, iconName: "circle.dotted", category: "Radiology")
    ]
    
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
                
                Text("Hospital Charges")
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
                    ForEach(charges, id: \.id) { charge in
                        HStack(spacing: 16) {
                            ZStack {
                                Circle()
                                    .fill(Color.blue.opacity(0.1))
                                    .frame(width: 50, height: 50)
                                
                                Image(systemName: charge.iconName)
                                    .font(.system(size: 20))
                                    .foregroundColor(.blue)
                            }
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(charge.category)
                                    .font(.system(size: 12))
                                    .foregroundColor(.blue)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 2)
                                    .background(Color.blue.opacity(0.1))
                                    .cornerRadius(4)
                                
                                Text(charge.testName)
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.black)
                                
                                Text("Medical Test")
                                    .font(.system(size: 14))
                                    .foregroundColor(.gray)
                            }
                            
                            Spacer()
                            
                            VStack(alignment: .trailing, spacing: 4) {
                                Text("$\(charge.price, specifier: "%.2f")")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(.black)
                                
                                Text("Price")
                                    .font(.system(size: 12))
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding(16)
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
                        .padding(.horizontal, 20)
                        
                        if charge.id != charges.last?.id {
                            Spacer()
                                .frame(height: 12)
                        }
                    }
                }
                .padding(.top, 20)
                .padding(.bottom, 20)
            }
        }
        .background(Color(.systemGroupedBackground))
    }
}

#Preview {
    HospitalChargesView()
}

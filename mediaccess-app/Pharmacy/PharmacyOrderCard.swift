import SwiftUI

struct PharmacyOrderCard: View {
    let order: PharmacyOrder
    
    var body: some View {
        VStack(spacing: 0) {
            // Order Info
            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(order.status)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.blue)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(6)
                        
                        Spacer()
                    }
                    
                    Text("Order #")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.black)
                    
                    Text(order.id)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.gray)
                        .padding(.bottom, 10)
                    
                    Text("Order Date: \(order.orderDate)")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                    
                    if let name = order.patientName as String? {
                        Text("Customer: \(name)")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                    }
                }
                
                Spacer()
                
                // Medicine Image
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.orange.opacity(0.2))
                        .frame(width: 60, height: 60)
                    
                    Image(systemName: "pill")
                        .font(.system(size: 24))
                        .foregroundColor(.orange)
                }
            }
            .padding(16)
            
            // Status Bar
            VStack(spacing: 8) {
                HStack {
                    Text(order.status)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.black)
                    Spacer()
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
        }
        .background(Color.white)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
        )
    }
}

//struct PharmacyOrder: Identifiable {
//    let id = UUID()
//    let orderNumber: String
//    let orderDate: String
//    let status: OrderStatus
//    let progress: Double
//    let medicationName: String
//}

enum OrderStatus: String, CaseIterable {
    case pending = "Pending"
    case processing = "Processing"
    case ready = "Ready"
    case delivered = "Delivered"
    case dispatched = "Ready for Pickup"
    
    var color: Color {
        switch self {
        case .pending:
            return .orange
        case .processing:
            return .blue
        case .ready:
            return .purple
        case .delivered:
            return .green
        case .dispatched:
            return .blue
        }
    }
    
    var backgroundColor: Color {
        return color.opacity(0.1)
    }
}

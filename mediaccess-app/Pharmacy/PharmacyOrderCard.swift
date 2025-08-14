import SwiftUI

struct PharmacyOrderCard: View {
    let order: PharmacyOrder
    
    var body: some View {
        VStack(spacing: 0) {
            // Order Info
            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(order.status.rawValue)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(order.status.color)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(order.status.backgroundColor)
                            .cornerRadius(6)
                        
                        Spacer()
                    }
                    
                    Text("Order #\(order.orderNumber)")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.black)
                    
                    Text("Order Date: \(order.orderDate)")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
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
            
            // Progress Bar
            VStack(spacing: 8) {
                HStack {
                    Text(order.status.rawValue)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.black)
                    Spacer()
                }
                
                ProgressView(value: order.progress)
                    .progressViewStyle(LinearProgressViewStyle(tint: order.status.color))
                    .scaleEffect(x: 1, y: 2, anchor: .center)
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

// MARK: - Supporting Models
struct PharmacyOrder: Identifiable {
    let id = UUID()
    let orderNumber: String
    let orderDate: String
    let status: OrderStatus
    let progress: Double
    let medicationName: String
}

enum OrderStatus: String, CaseIterable {
    case inTransit = "In Transit"
    case delivered = "Delivered"
    case processing = "Processing"
    case readyForPickup = "Ready for Pickup"
    
    var color: Color {
        switch self {
        case .inTransit:
            return .blue
        case .delivered:
            return .green
        case .processing:
            return .orange
        case .readyForPickup:
            return .purple
        }
    }
    
    var backgroundColor: Color {
        return color.opacity(0.1)
    }
}

extension PharmacyOrder {
    static let sampleOrders = [
        PharmacyOrder(
            orderNumber: "12345",
            orderDate: "05/15/2024",
            status: .inTransit,
            progress: 0.7,
            medicationName: "Amoxicillin"
        ),
        PharmacyOrder(
            orderNumber: "67890",
            orderDate: "04/20/2024",
            status: .delivered,
            progress: 1.0,
            medicationName: "Lisinopril"
        )
    ]
}

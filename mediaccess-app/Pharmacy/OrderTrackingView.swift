import SwiftUI

struct OrderTrackingView: View {
    let order: PharmacyOrder
    let onBackTapped: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            headerSection
            scrollContent
        }
        .background(Color(.systemGroupedBackground))
    }
    
    private var headerSection: some View {
        HStack {
            Button(action: onBackTapped) {
                Image(systemName: "arrow.left")
                    .font(.system(size: 18))
                    .foregroundColor(.black)
            }
            
            Spacer()
            
            Text("Order Tracking")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.black)
            
            Spacer()
         
            Color.clear
                .frame(width: 24, height: 24)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 20)
    }
    
    private var scrollContent: some View {
        ScrollView {
            VStack(spacing: 20) {
                orderSummarySection
                orderStatusSection
                orderDetailsSection
                deliveryDetailsSection
                if !order.orderItems.isEmpty {
                    orderItemsSection
                }
                Spacer(minLength: 100)
            }
            .padding(.top, 10)
        }
    }
    
    private var orderSummarySection: some View {
        VStack(spacing: 16) {
            HStack(spacing: 16) {
                // Medicine Icon
                ZStack {
                    Circle()
                        .fill(Color.orange.opacity(0.1))
                        .frame(width: 80, height: 80)
                    
                    Image(systemName: "pills.fill")
                        .font(.system(size: 32))
                        .foregroundColor(.orange)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Pharmacy Order")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.black)
                    
                    Text("Order #\(order.id)")
                        .font(.system(size: 16))
                        .foregroundColor(.gray)
                    
                    Text("Ordered on \(order.orderDate)")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                    
                    // Status Badge
                    HStack {
                        Text(order.status.uppercased())
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(getStatusColor(order.status))
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(getStatusColor(order.status).opacity(0.1))
                            .cornerRadius(12)
                        
                        Spacer()
                    }
                }
                
                Spacer()
            }
        }
        .padding(20)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
        .padding(.horizontal, 20)
    }
    
    private var orderStatusSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Order Status")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.black)
                Spacer()
            }
            .padding(.horizontal, 20)
            
            VStack(spacing: 0) {
                OrderStatusItem(
                    title: "Order Placed",
                    subtitle: "Your order has been received",
                    isCompleted: true,
                    isLast: false
                )
                
                OrderStatusItem(
                    title: "Processing",
                    subtitle: "Preparing your medications",
                    isCompleted: order.status.lowercased() != "pending",
                    isLast: false
                )
                
                OrderStatusItem(
                    title: "Ready for Pickup/Dispatch",
                    subtitle: order.status.lowercased().contains("ready") ? "Ready for pickup" : "Being prepared for dispatch",
                    isCompleted: order.status.lowercased().contains("ready") || order.status.lowercased().contains("dispatched"),
                    isLast: false
                )
                
                OrderStatusItem(
                    title: "Delivered",
                    subtitle: order.status.lowercased().contains("delivered") ? "Successfully delivered" : "Awaiting delivery",
                    isCompleted: order.status.lowercased().contains("delivered"),
                    isLast: true
                )
            }
            .padding(20)
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
            .padding(.horizontal, 20)
        }
    }
    
    private var orderDetailsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Order Details")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.black)
                Spacer()
            }
            .padding(.horizontal, 20)
            
            VStack(spacing: 16) {
                // Patient Information
                OrderDetailRow(
                    icon: "person.fill",
                    iconColor: .blue,
                    title: "Patient Name",
                    value: order.patientName
                )
                
                OrderDetailRow(
                    icon: "phone.fill",
                    iconColor: .green,
                    title: "Contact Number",
                    value: order.contactNumber
                )
                
                OrderDetailRow(
                    icon: "location.fill",
                    iconColor: .red,
                    title: "Delivery Address",
                    value: order.address
                )
                
                if !order.notes.isEmpty {
                    OrderDetailRow(
                        icon: "note.text",
                        iconColor: .orange,
                        title: "Special Notes",
                        value: order.notes
                    )
                }
                
                OrderDetailRow(
                    icon: "calendar",
                    iconColor: .purple,
                    title: "Created Date",
                    value: "\(order.createdDate) at \(order.createdTime)"
                )
                
                if !order.price.isEmpty && order.price != "0" {
                    OrderDetailRow(
                        icon: "dollarsign.circle.fill",
                        iconColor: .green,
                        title: "Total Amount",
                        value: "Rs. \(order.price)"
                    )
                }
            }
            .padding(20)
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
            .padding(.horizontal, 20)
        }
    }
    
    private var deliveryDetailsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Delivery Information")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.black)
                Spacer()
            }
            .padding(.horizontal, 20)
            
            VStack(spacing: 16) {
                HStack(spacing: 16) {
                    ZStack {
                        Circle()
                            .fill(Color.blue.opacity(0.1))
                            .frame(width: 40, height: 40)
                        
                        Image(systemName: "clock.fill")
                            .font(.system(size: 18))
                            .foregroundColor(.blue)
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Estimated Delivery")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.black)
                        
                        Text(getEstimatedDelivery())
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                }
                
                if order.status.lowercased().contains("ready") {
                    HStack(spacing: 16) {
                        ZStack {
                            Circle()
                                .fill(Color.green.opacity(0.1))
                                .frame(width: 40, height: 40)
                            
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 18))
                                .foregroundColor(.green)
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Pickup Available")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.black)
                            
                            Text("Your order is ready for pickup at our pharmacy")
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                        }
                        
                        Spacer()
                    }
                }
            }
            .padding(20)
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
            .padding(.horizontal, 20)
        }
    }
    
    private var orderItemsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Order Items")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.black)
                Spacer()
            }
            .padding(.horizontal, 20)
            
            VStack(spacing: 12) {
                ForEach(Array(order.orderItems.enumerated()), id: \.offset) { index, item in
                    HStack(spacing: 12) {
                        ZStack {
                            Circle()
                                .fill(Color.orange.opacity(0.1))
                                .frame(width: 40, height: 40)
                            
                            Image(systemName: "pill.fill")
                                .font(.system(size: 16))
                                .foregroundColor(.orange)
                        }
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text(item)
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.black)
                            
                            Text("Item \(index + 1)")
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                        }
                        
                        Spacer()
                    }
                    .padding(16)
                    .background(Color.gray.opacity(0.05))
                    .cornerRadius(8)
                }
            }
            .padding(20)
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
            .padding(.horizontal, 20)
        }
    }
    
    private func getStatusColor(_ status: String) -> Color {
        switch status.lowercased() {
        case let s where s.contains("pending"):
            return .orange
        case let s where s.contains("processing"):
            return .blue
        case let s where s.contains("ready"):
            return .purple
        case let s where s.contains("delivered"):
            return .green
        case let s where s.contains("dispatched"):
            return .blue
        default:
            return .gray
        }
    }
    
    private func getEstimatedDelivery() -> String {
        switch order.status.lowercased() {
        case let s where s.contains("pending"):
            return "2-3 business days after confirmation"
        case let s where s.contains("processing"):
            return "1-2 business days"
        case let s where s.contains("ready"):
            return "Available for pickup now"
        case let s where s.contains("dispatched"):
            return "Today, within 4-6 hours"
        case let s where s.contains("delivered"):
            return "Delivered on \(order.orderDate)"
        default:
            return "Please contact pharmacy for details"
        }
    }
}

struct OrderStatusItem: View {
    let title: String
    let subtitle: String
    let isCompleted: Bool
    let isLast: Bool
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            VStack(spacing: 0) {
                // Status circle
                Circle()
                    .fill(isCompleted ? Color.blue : Color.clear)
                    .stroke(isCompleted ? Color.blue : Color.gray.opacity(0.3), lineWidth: 2)
                    .frame(width: 20, height: 20)
                    .overlay(
                        isCompleted ?
                        Image(systemName: "checkmark")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(.white)
                        : nil
                    )
                
                // Connecting line
                if !isLast {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 2, height: 40)
                }
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(isCompleted ? .black : .gray)
                
                Text(subtitle)
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }
            
            Spacer()
        }
        .padding(.bottom, isLast ? 0 : 8)
    }
}

struct OrderDetailRow: View {
    let icon: String
    let iconColor: Color
    let title: String
    let value: String
    
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(iconColor.opacity(0.1))
                    .frame(width: 35, height: 35)
                
                Image(systemName: icon)
                    .font(.system(size: 16))
                    .foregroundColor(iconColor)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                
                Text(value)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.black)
            }
            
            Spacer()
        }
    }
}

// MARK: - Updated PharmacyOrder Model

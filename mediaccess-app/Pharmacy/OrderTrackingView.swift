import SwiftUI

struct OrderTrackingView: View {
    let order: PharmacyOrder
    let onBackTapped: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            headerView
            
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
                .padding(.horizontal, 20)
                .padding(.top, 20)
            }
        }
        .background(Color(.systemGroupedBackground))
    }
    
    private var headerView: some View {
        HStack {
            Button(action: onBackTapped) {
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
            
            Text("Order Tracking")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.black)
            
            Spacer()
            
            Circle()
                .fill(Color.clear)
                .frame(width: 40, height: 40)
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
        .padding(.bottom, 5)
        .background(Color(.systemGroupedBackground))
    }
    
    private var orderSummarySection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Order Summary")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.black)
            
            VStack(spacing: 16) {
                HStack(spacing: 16) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.orange.opacity(0.1))
                            .frame(width: 80, height: 80)
                        
                        Image(systemName: "pills.fill")
                            .font(.system(size: 32))
                            .foregroundColor(.orange)
                    }
                    
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Pharmacy Order")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.black)
                        
                        Text("Order #\(order.id)")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.gray)
                        
                        Text("Ordered on \(order.orderDate)")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                        
                        HStack {
                            Text(order.status.uppercased())
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(.white)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(
                                    LinearGradient(
                                        gradient: Gradient(colors: [getStatusColor(order.status), getStatusColor(order.status).opacity(0.8)]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .cornerRadius(16)
                            
                            Spacer()
                        }
                    }
                    
                    Spacer()
                }
            }
            .padding(20)
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
        }
    }
    
    private var orderStatusSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Order Progress")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.black)
            
            VStack(spacing: 0) {
                OrderStatusItem(
                    title: "Order Placed",
                    subtitle: "Your order has been received",
                    icon: "checkmark.circle.fill",
                    isCompleted: true,
                    isLast: false
                )
                
                OrderStatusItem(
                    title: "Processing",
                    subtitle: "Preparing your medications",
                    icon: "gearshape.fill",
                    isCompleted: order.status.lowercased() != "pending",
                    isLast: false
                )
                
                OrderStatusItem(
                    title: "Ready for Pickup/Dispatch",
                    subtitle: order.status.lowercased().contains("ready") ? "Ready for pickup" : "Being prepared for dispatch",
                    icon: "box.fill",
                    isCompleted: order.status.lowercased().contains("ready") || order.status.lowercased().contains("dispatched"),
                    isLast: false
                )
                
                OrderStatusItem(
                    title: "Delivered",
                    subtitle: order.status.lowercased().contains("delivered") ? "Successfully delivered" : "Awaiting delivery",
                    icon: "house.fill",
                    isCompleted: order.status.lowercased().contains("delivered"),
                    isLast: true
                )
            }
            .padding(20)
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
        }
    }
    
    private var orderDetailsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Order Details")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.black)
            
            VStack(spacing: 16) {
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
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
        }
    }
    
    private var deliveryDetailsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Delivery Information")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.black)
            
            VStack(spacing: 16) {
                HStack(spacing: 16) {
                    ZStack {
                        Circle()
                            .fill(Color.blue.opacity(0.1))
                            .frame(width: 50, height: 50)
                        
                        Image(systemName: "clock.fill")
                            .font(.system(size: 20))
                            .foregroundColor(.blue)
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Estimated Delivery")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.black)
                        
                        Text(getEstimatedDelivery())
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                            .lineLimit(2)
                    }
                    
                    Spacer()
                }
                
                if order.status.lowercased().contains("ready") {
                    HStack(spacing: 16) {
                        ZStack {
                            Circle()
                                .fill(Color.green.opacity(0.1))
                                .frame(width: 50, height: 50)
                            
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 20))
                                .foregroundColor(.green)
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Pickup Available")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.black)
                            
                            Text("Your order is ready for pickup at our pharmacy")
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                                .lineLimit(2)
                        }
                        
                        Spacer()
                    }
                }
            }
            .padding(20)
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
        }
    }
    
    private var orderItemsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Order Items")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.black)
                
                Spacer()
                
                Text("\(order.orderItems.count) items")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.orange)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.orange.opacity(0.1))
                    .cornerRadius(8)
            }
            
            VStack(spacing: 12) {
                ForEach(Array(order.orderItems.enumerated()), id: \.offset) { index, item in
                    HStack(spacing: 16) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.orange.opacity(0.1))
                                .frame(width: 50, height: 50)
                            
                            Image(systemName: "pill.fill")
                                .font(.system(size: 18))
                                .foregroundColor(.orange)
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(item)
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.black)
                                .lineLimit(2)
                            
                            Text("Item \(index + 1)")
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 16))
                            .foregroundColor(.green)
                    }
                    .padding(16)
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
                }
            }
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
    let icon: String
    let isCompleted: Bool
    let isLast: Bool
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            VStack(spacing: 0) {
                // Status circle with icon
                ZStack {
                    Circle()
                        .fill(isCompleted ? Color.blue : Color.white)
                        .stroke(isCompleted ? Color.blue : Color.gray.opacity(0.3), lineWidth: 3)
                        .frame(width: 40, height: 40)
                    
                    if isCompleted {
                        Image(systemName: icon)
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                    } else {
                        Circle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 12, height: 12)
                    }
                }
                
                if !isLast {
                    Rectangle()
                        .fill(isCompleted ? Color.blue.opacity(0.3) : Color.gray.opacity(0.2))
                        .frame(width: 3, height: 50)
                }
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(isCompleted ? .black : .gray)
                
                Text(subtitle)
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                    .lineLimit(2)
                
                if isCompleted {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 12))
                            .foregroundColor(.green)
                        
                        Text("Completed")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.green)
                    }
                }
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
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(iconColor.opacity(0.1))
                    .frame(width: 45, height: 45)
                
                Image(systemName: icon)
                    .font(.system(size: 18))
                    .foregroundColor(iconColor)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.gray)
                
                Text(value)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.black)
                    .lineLimit(3)
            }
            
            Spacer()
        }
    }
}

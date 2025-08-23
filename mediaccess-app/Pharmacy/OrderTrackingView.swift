//import SwiftUI
//
//struct OrderTrackingView: View {
//    let order: PharmacyOrder
//    let onBackTapped: () -> Void
//    
//    var body: some View {
//        VStack(spacing: 0) {
//            
//            HStack {
//                Button(action: {
//                    onBackTapped()
//                }) {
//                    Image(systemName: "arrow.left")
//                        .font(.title2)
//                        .foregroundColor(.black)
//                }
//                
//                Spacer()
//                
//                Text("Order Tracking")
//                    .font(.headline)
//                    .fontWeight(.medium)
//                
//                Spacer()
//             
//                Color.clear
//                    .frame(width: 24, height: 24)
//            }
//            .padding(.horizontal)
//            .padding(.top, 20)
//            .padding(.bottom, 20)
//            
//            ScrollView {
//                VStack(spacing: 24) {
//                    // Prescription Details
//                    HStack(spacing: 16) {
//                        VStack(alignment: .leading, spacing: 4) {
//                            Text("Prescription")
//                                .font(.system(size: 14))
//                                .foregroundColor(.gray)
//                            
//                            Text(order.medicationName)
//                                .font(.system(size: 18, weight: .semibold))
//                                .foregroundColor(.black)
//                            
//                            Text("Order #\(order.orderNumber) • \(order.orderDate)")
//                                .font(.system(size: 14))
//                                .foregroundColor(.gray)
//                        }
//                        
//                        Spacer()
//                        
//                        // Medicine bottle image
//                        RoundedRectangle(cornerRadius: 12)
//                            .fill(Color.orange.opacity(0.7))
//                            .frame(width: 80, height: 60)
//                            .overlay(
//                                VStack(spacing: 2) {
//                                    RoundedRectangle(cornerRadius: 2)
//                                        .fill(Color.white)
//                                        .frame(width: 40, height: 35)
//                                        .overlay(
//                                            VStack(spacing: 1) {
//                                                Text("Rx")
//                                                    .font(.system(size: 10, weight: .bold))
//                                                    .foregroundColor(.orange)
//                                                Rectangle()
//                                                    .fill(Color.orange.opacity(0.3))
//                                                    .frame(height: 1)
//                                                Rectangle()
//                                                    .fill(Color.orange.opacity(0.3))
//                                                    .frame(height: 1)
//                                            }
//                                            .padding(4)
//                                        )
//                                    
//                                    RoundedRectangle(cornerRadius: 1)
//                                        .fill(Color.white.opacity(0.8))
//                                        .frame(width: 30, height: 4)
//                                }
//                            )
//                    }
//                    .padding(.horizontal, 20)
//                    
//                    // Order Status Section
//                    VStack(alignment: .leading, spacing: 20) {
//                        HStack {
//                            Text("Order Status")
//                                .font(.system(size: 20, weight: .semibold))
//                                .foregroundColor(.black)
//                            Spacer()
//                        }
//                        .padding(.horizontal, 20)
//                        
//                        VStack(spacing: 0) {
//                            // Status items based on current order status
//                            OrderStatusItem(
//                                title: "Placed",
//                                subtitle: "Order placed",
//                                isCompleted: true,
//                                isLast: false
//                            )
//                            
//                            OrderStatusItem(
//                                title: "Processing",
//                                subtitle: "Preparing your order",
//                                isCompleted: order.status != .processing ? true : order.progress > 0.3,
//                                isLast: false
//                            )
//                            
//                            OrderStatusItem(
//                                title: "Dispatched",
//                                subtitle: "On its way",
//                                isCompleted: order.status == .inTransit || order.status == .delivered || order.status == .readyForPickup,
//                                isLast: false
//                            )
//                            
//                            OrderStatusItem(
//                                title: "Delivered",
//                                subtitle: order.status == .delivered ? "Delivered" : order.status == .readyForPickup ? "Ready for pickup" : "Pending delivery",
//                                isCompleted: order.status == .delivered || order.status == .readyForPickup,
//                                isLast: true
//                            )
//                        }
//                        .padding(.horizontal, 20)
//                    }
//                    
//                    // Delivery Details Section
//                    VStack(alignment: .leading, spacing: 16) {
//                        HStack {
//                            Text("Delivery Details")
//                                .font(.system(size: 20, weight: .semibold))
//                                .foregroundColor(.black)
//                            Spacer()
//                        }
//                        .padding(.horizontal, 20)
//                        
//                        HStack(alignment: .top, spacing: 20) {
//                            VStack(alignment: .leading, spacing: 4) {
//                                Text("Estimated Delivery")
//                                    .font(.system(size: 14))
//                                    .foregroundColor(.gray)
//                                
//                                Text(getEstimatedDelivery())
//                                    .font(.system(size: 16, weight: .medium))
//                                    .foregroundColor(.black)
//                            }
//                            
//                            Spacer()
//                            
//                            VStack(alignment: .leading, spacing: 4) {
//                                Text("Current Status")
//                                    .font(.system(size: 14))
//                                    .foregroundColor(.gray)
//                                
//                                Text(order.status.rawValue)
//                                    .font(.system(size: 16, weight: .medium))
//                                    .foregroundColor(order.status.color)
//                            }
//                        }
//                        .padding(.horizontal, 20)
//                    }
//                    
//                    Spacer(minLength: 100)
//                }
//                .padding(.top, 10)
//            }
//        }
//        .background(Color.white)
//    }
//    
//    private func getEstimatedDelivery() -> String {
//        switch order.status {
//        case .processing:
//            return "2-3 business days"
//        case .inTransit:
//            return "Today, 4:00 PM - 6:00 PM"
//        case .delivered:
//            return "Delivered on \(order.orderDate)"
//        case .readyForPickup:
//            return "Available for pickup"
//        }
//    }
//}
//
//struct OrderStatusItem: View {
//    let title: String
//    let subtitle: String
//    let isCompleted: Bool
//    let isLast: Bool
//    
//    var body: some View {
//        HStack(alignment: .top, spacing: 12) {
//            VStack(spacing: 0) {
//                // Status circle
//                Circle()
//                    .fill(isCompleted ? Color.black : Color.clear)
//                    .stroke(Color.black, lineWidth: 2)
//                    .frame(width: 20, height: 20)
//                    .overlay(
//                        isCompleted ?
//                        Image(systemName: "checkmark")
//                            .font(.system(size: 10, weight: .bold))
//                            .foregroundColor(.white)
//                        : nil
//                    )
//                
//                // Connecting line
//                if !isLast {
//                    Rectangle()
//                        .fill(Color.gray.opacity(0.3))
//                        .frame(width: 2, height: 40)
//                }
//            }
//            
//            VStack(alignment: .leading, spacing: 2) {
//                Text(title)
//                    .font(.system(size: 16, weight: .medium))
//                    .foregroundColor(.black)
//                
//                Text(subtitle)
//                    .font(.system(size: 14))
//                    .foregroundColor(.gray)
//            }
//            
//            Spacer()
//        }
//        .padding(.bottom, isLast ? 0 : 8)
//    }
//}

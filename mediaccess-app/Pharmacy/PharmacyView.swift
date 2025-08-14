import SwiftUI

struct PharmacyView: View {
    @State private var showNewOrder = false
    @State private var showOrderHistory = false
    @State private var showOrderTracking = false
    @State private var selectedOrder: PharmacyOrder?
    
    var body: some View {
        ZStack {
            // Main Pharmacy View
            VStack(spacing: 0) {
                // Header
                Text("Pharmacy")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.black)
                    .padding(.top, 20)
                    .padding(.bottom, 10)
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Hero Section
                        ZStack {
                            // Background Image
                            Image("pharmacy_interior") // You'll need to add this image to your assets
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(height: 280)
                                .clipped()
    //                            .overlay(
    //                                // Dark overlay for text readability
    //                                Color.black.opacity(0.3)
    //                            )
                            
                            // If you don't have the image, use this placeholder
    //                        Rectangle()
    //                            .fill(
    //                                LinearGradient(
    //                                    gradient: Gradient(colors: [Color.gray.opacity(0.3), Color.gray.opacity(0.6)]),
    //                                    startPoint: .top,
    //                                    endPoint: .bottom
    //                                )
    //                            )
    //                            .frame(height: 280)
    //                            .overlay(
    //                                // Pharmacy shelves illustration
    //                                VStack {
    //                                    HStack {
    //                                        Rectangle()
    //                                            .fill(Color.white.opacity(0.2))
    //                                            .frame(width: 60, height: 120)
    //                                        Spacer()
    //                                        Rectangle()
    //                                            .fill(Color.white.opacity(0.2))
    //                                            .frame(width: 60, height: 120)
    //                                    }
    //                                    .padding(.horizontal, 40)
    //                                    Spacer()
    //                                }
    //                            )
                            
                            VStack(alignment: .leading, spacing: 16) {
                                Spacer()
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Your Health, Our Priority")
                                        .font(.system(size: 28, weight: .bold))
                                        .foregroundColor(.white)
                                        .multilineTextAlignment(.leading)
                                    
                                    Text("Order your prescriptions online for quick and easy refills.")
                                        .font(.system(size: 16))
                                        .foregroundColor(.white.opacity(0.9))
                                        .multilineTextAlignment(.leading)
                                }
                                
                                Spacer()
                            }
                            .padding(.horizontal, 20)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .cornerRadius(12)
                        .padding(.horizontal, 20)
                        
                        // Place New Order Button
                        Button(action: {
                            showNewOrder = true
                        }) {
                            HStack(spacing: 8) {
                                Image(systemName: "plus")
                                    .font(.system(size: 16, weight: .semibold))
                                Text("Place New Order")
                                    .font(.system(size: 16, weight: .semibold))
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(Color.blue)
                            .cornerRadius(12)
                        }
                        .padding(.horizontal, 20)
                        
                        // Current Orders Section
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Text("Current Orders")
                                    .font(.system(size: 20, weight: .semibold))
                                    .foregroundColor(.black)
                                Spacer()
                            }
                            .padding(.horizontal, 20)
                            
                            VStack(spacing: 16) {
                                ForEach(PharmacyOrder.sampleOrders, id: \.id) { order in
                                    Button(action: {
                                        selectedOrder = order
                                        withAnimation(.easeInOut(duration: 0.3)) {
                                            showOrderTracking = true
                                        }
                                    }) {
                                        PharmacyOrderCard(order: order)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                        
                        // Quick Actions Section
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Text("Quick Actions")
                                    .font(.system(size: 20, weight: .semibold))
                                    .foregroundColor(.black)
                                Spacer()
                            }
                            .padding(.horizontal, 20)
                            
                            VStack(spacing: 12) {
                                Button(action: {
                                    showOrderHistory = true
                                }) {
                                    HStack(spacing: 12) {
                                        Image(systemName: "clock.arrow.circlepath")
                                            .font(.system(size: 20))
                                            .foregroundColor(.blue)
                                            .frame(width: 24, height: 24)
                                        
                                        Text("Order History")
                                            .font(.system(size: 16, weight: .medium))
                                            .foregroundColor(.black)
                                        
                                        Spacer()
                                        
                                        Image(systemName: "chevron.right")
                                            .font(.system(size: 14))
                                            .foregroundColor(.gray)
                                    }
                                    .padding(16)
                                    .background(Color.gray.opacity(0.05))
                                    .cornerRadius(12)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                            .padding(.horizontal, 20)
                        }
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.top, 10)
                }
            }
            .background(Color.white)
            .opacity(showOrderTracking ? 0 : 1)
            
            // Order Tracking Details Overlay
            if showOrderTracking, let order = selectedOrder {
                OrderTrackingView(
                    order: order,
                    onBackTapped: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            showOrderTracking = false
                        }
                    }
                )
                .transition(.move(edge: .trailing))
            }
        }
        .sheet(isPresented: $showNewOrder) {
            PlaceNewOrderView()
        }
        .sheet(isPresented: $showOrderHistory) {
            OrderHistoryView()
        }
    }
}

struct PharmacyView_Previews: PreviewProvider {
    static var previews: some View {
        PharmacyView()
    }
}

import SwiftUI

struct PharmacyView: View {
    @State private var showNewOrder = false
    @State private var showOrderHistory = false
    @State private var showOrderTracking = false
    @State private var selectedOrder: PharmacyOrder?
    @State private var currentOrders: [PharmacyOrder] = PharmacyOrder.sampleOrders
    
    var body: some View {
        ZStack {
            mainContent
            orderTrackingOverlay
        }
        .sheet(isPresented: $showNewOrder) {
            PlaceNewOrderView { newOrder in
                // Handle the new order placement
                currentOrders.insert(newOrder, at: 0) // Add to beginning of list
                print("New pharmacy order placed: \(newOrder.id)")
            }
        }
        .sheet(isPresented: $showOrderHistory) {
            OrderHistoryView()
        }
    }
    
    private var mainContent: some View {
        VStack(spacing: 0) {
            headerSection
            scrollContent
        }
        .background(Color(.systemGroupedBackground))
        .opacity(showOrderTracking ? 0 : 1)
    }
    
    private var headerSection: some View {
        HStack {
            Text("Pharmacy")
                .font(.system(size: 24, weight: .semibold))
                .foregroundColor(.black)
            
            Spacer()
            
            Button(action: {}) {
                Image(systemName: "bell")
                    .font(.system(size: 14))
                    .foregroundColor(.black)
            }
            .padding(10)
            .overlay(
                Circle()
                    .stroke(Color.gray.opacity(0.5), lineWidth: 1)
            )
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 20)
    }
    
    private var scrollContent: some View {
        ScrollView {
            VStack(spacing: 20) {
                heroSection
                placeOrderSection
                currentOrdersSection
                quickActionsSection
                Spacer(minLength: 100)
            }
        }
    }
    
    private var heroSection: some View {
        ZStack {
            // Background Image
            Image("pharmacy_interior") // You'll need to add this image to your assets
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 200)
                .clipped()
            
            // If you don't have the image, use this placeholder
            Rectangle()
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.blue.opacity(0.7), Color.blue.opacity(0.9)]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(height: 200)
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Your Health, Our Priority")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.leading)
                
                Text("Order your prescriptions online for quick and easy refills.")
                    .font(.system(size: 16))
                    .foregroundColor(.white.opacity(0.9))
                    .multilineTextAlignment(.leading)
            }
            .padding(.horizontal, 20)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .cornerRadius(12)
        .padding(.horizontal, 20)
    }
    
    private var placeOrderSection: some View {
        Button(action: {
            showNewOrder = true
        }) {
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.3))
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: "plus")
                        .font(.system(size: 18))
                        .foregroundColor(.white)
                }
                
                Text("Place New Order")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundColor(.white.opacity(0.7))
            }
            .padding(16)
            .background(Color.blue)
            .cornerRadius(12)
        }
        .padding(.horizontal, 20)
    }
    
    private var currentOrdersSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            currentOrdersHeader
            currentOrdersList
        }
    }
    
    private var currentOrdersHeader: some View {
        HStack {
            Text("Current Orders")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.black)
            Spacer()
            Button(action: {}) {
                Text("View all")
                    .font(.system(size: 14))
                    .foregroundColor(.blue)
            }
        }
        .padding(.horizontal, 20)
    }
    
    private var currentOrdersList: some View {
        VStack(spacing: 12) {
            if currentOrders.isEmpty {
                emptyOrdersView
            } else {
                ForEach(currentOrders.prefix(3), id: \.id) { order in
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
        }
        .padding(.horizontal, 20)
    }
    
    private var emptyOrdersView: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(Color.gray.opacity(0.1))
                    .frame(width: 60, height: 60)
                
                Image(systemName: "pills.fill")
                    .font(.system(size: 24))
                    .foregroundColor(.gray)
            }
            
            Text("No current orders")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.gray)
            
            Text("Place your first order")
                .font(.system(size: 14))
                .foregroundColor(.gray.opacity(0.7))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
        .background(Color.white)
        .cornerRadius(12)
    }
    
    private var quickActionsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            quickActionsHeader
            quickActionsList
        }
    }
    
    private var quickActionsHeader: some View {
        HStack {
            Text("Quick Actions")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.black)
            Spacer()
        }
        .padding(.horizontal, 20)
    }
    
    private var quickActionsList: some View {
        VStack(spacing: 12) {
            Button(action: {
                showOrderHistory = true
            }) {
                HStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(Color.blue.opacity(0.1))
                            .frame(width: 40, height: 40)
                        
                        Image(systemName: "clock.arrow.circlepath")
                            .font(.system(size: 18))
                            .foregroundColor(.blue)
                    }
                    
                    Text("Order History")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                }
                .padding(16)
                .background(Color.white)
                .cornerRadius(12)
                .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(.horizontal, 20)
    }
    
    private var orderTrackingOverlay: some View {
        Group {
            if showOrderTracking, let order = selectedOrder {
                // OrderTrackingView(
                //     order: order,
                //     onBackTapped: {
                //         withAnimation(.easeInOut(duration: 0.3)) {
                //             showOrderTracking = false
                //         }
                //     }
                // )
                // .transition(.move(edge: .trailing))
            }
        }
    }
}

struct PharmacyView_Previews: PreviewProvider {
    static var previews: some View {
        PharmacyView()
    }
}

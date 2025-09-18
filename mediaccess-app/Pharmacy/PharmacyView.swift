import SwiftUI

struct PharmacyOrder: Identifiable, Codable {
    let id: String
    let patientId: String
    let patientName: String
    let contactNumber: String
    let address: String
    let notes: String
    let prescriptionImageData: String
    let orderDate: String
    let status: String
    let orderItems: [String]
    let price: String
    let createdDate: String
    let createdTime: String
    
    static let sampleOrders: [PharmacyOrder] = [
        PharmacyOrder(
            id: "PH001",
            patientId: "P123",
            patientName: "John Doe",
            contactNumber: "+94 77 123 4567",
            address: "123 Main Street, Colombo 07",
            notes: "Please deliver after 6 PM",
            prescriptionImageData: "",
            orderDate: "2024-01-15",
            status: "Processing",
            orderItems: ["Paracetamol 500mg", "Vitamin D3"],
            price: "1250.00",
            createdDate: "2024-01-15",
            createdTime: "14:30:00"
        ),
        PharmacyOrder(
            id: "PH002",
            patientId: "P124",
            patientName: "Jane Smith",
            contactNumber: "+94 71 987 6543",
            address: "456 Galle Road, Mount Lavinia",
            notes: "",
            prescriptionImageData: "",
            orderDate: "2024-01-14",
            status: "Ready for Pickup",
            orderItems: ["Amoxicillin 250mg"],
            price: "850.00",
            createdDate: "2024-01-14",
            createdTime: "09:15:00"
        )
    ]
}


struct PharmacyView: View {
    @State private var showNewOrder = false
    @State private var showOrderHistory = false
    @State private var showOrderTracking = false
    @State private var selectedOrder: PharmacyOrder?
    @State private var currentOrders: [PharmacyOrder] = []
    @State private var isLoadingOrders = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var showingNotifications = false
    @StateObject private var badgeManager = NotificationBadgeManager.shared

    
    var body: some View {
        ZStack {
            mainContent
            orderTrackingOverlay
        }
        .sheet(isPresented: $showNewOrder) {
            PlaceNewOrderView { newOrder in
                currentOrders.insert(newOrder, at: 0)
                print("New pharmacy order placed: \(newOrder.id)")
            }
        }
        .sheet(isPresented: $showOrderHistory) {
            OrderHistoryView()
        }
        .fullScreenCover(isPresented: $showingNotifications) {
            NotificationsView()
                .onDisappear {
                    badgeManager.fetchNotificationCount()
                }
        }
    }
    
    private var mainContent: some View {
        VStack(spacing: 0) {
            headerSection
            scrollContent
        }
        .background(Color(.systemGroupedBackground))
        .opacity(showOrderTracking ? 0 : 1)
        .onAppear {
            badgeManager.fetchNotificationCount()
        }
    }
    
    private var headerSection: some View {
        HStack {
            Text("Pharmacy")
                .font(.system(size: 24, weight: .semibold))
                .foregroundColor(.black)
            
            Spacer()
            
            Button(action: {
                showingNotifications = true
            }) {
                ZStack {
                    Image(systemName: "bell")
                        .font(.system(size: 14))
                        .foregroundColor(.black)
                    
                    // Notification badge
                    if badgeManager.notificationCount > 0 {
                        ZStack {
                            Circle()
                                .fill(Color.red)
                                .frame(width: 16, height: 16)
                            
                            Text("\(min(badgeManager.notificationCount, 99))")
                                .font(.system(size: 8, weight: .bold))
                                .foregroundColor(.white)
                        }
                        .offset(x: 8, y: -8)
                    }
                }
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
            Image("pharmacy_interior")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 200)
                .clipped()
            
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
        .onAppear {
            fetchPharmacyOrders()
        }
        .alert("Error", isPresented: $showAlert) {
            Button("OK") { }
        } message: {
            Text(alertMessage)
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
            if isLoadingOrders {
                loadingView
            } else if currentOrders.isEmpty {
                emptyOrdersView
            } else {
                let filteredOrders = currentOrders.filter {
                    $0.status == "Pending" || $0.status == "Processing" || $0.status == "Ready"
                }
                if filteredOrders.isEmpty {
                    emptyOrdersView
                } else {
                    ForEach(filteredOrders.prefix(3), id: \.id) { order in
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
        }
        .padding(.horizontal, 20)
    }
    
    private var loadingView: some View {
        VStack(spacing: 16) {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                .scaleEffect(1.2)
            Text("Loading orders...")
                .font(.system(size: 14))
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
        .background(Color.white)
        .cornerRadius(12)
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
        
    }
    
    // This function gets the patient's ID from the phone's memory
    private var patientId: String {
        return UserDefaults.standard.string(forKey: "id") ?? ""
    }
    
    // This function gets all medicine orders from the internet
    private func fetchPharmacyOrders() {
        guard !patientId.isEmpty else {
            alertMessage = "Patient ID not found. Please log in again."
            showAlert = true
            return
        }
        
        guard let url = URL(string: "https://mediaccess.vercel.app/api/pharmacy-order/all?patientId=\(patientId)") else {
            alertMessage = "Invalid API endpoint"
            showAlert = true
            return
        }
        
        isLoadingOrders = true
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                isLoadingOrders = false
                
                if let error = error {
                    alertMessage = "Network error: \(error.localizedDescription)"
                    showAlert = true
                    return
                }
                
                guard let data = data else {
                    alertMessage = "No data received"
                    showAlert = true
                    return
                }
                
                do {
                    struct PharmacyOrdersResponse: Codable {
                        let pharmacyorders: [PharmacyOrder]
                    }
                    
                    let response = try JSONDecoder().decode(PharmacyOrdersResponse.self, from: data)
                    self.currentOrders = response.pharmacyorders
                    
                } catch {
                    print("Decoding error: \(error)")
                    alertMessage = "Failed to parse appointments data"
                    showAlert = true
                }
            }
        }.resume()
    }
}

struct PharmacyView_Previews: PreviewProvider {
    static var previews: some View {
        PharmacyView()
    }
}

import SwiftUI

struct OrderHistoryView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var showOrderTracking = false
    @State private var selectedOrder: PharmacyOrder?
    @State private var currentOrders: [PharmacyOrder] = []
    @State private var isLoadingOrders = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        ZStack{
            mainContent
            orderTrackingOverlay
        }
    }
    
    private var mainContent: some View {
        NavigationView {
            VStack {
                ScrollView {
                    VStack(spacing: 24){
                        headerSection
                        currentOrdersSection
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
        }
    }
    
    private var headerSection: some View {
        HStack {
            Button("Cancel") {
                dismiss()
            }
            .foregroundColor(.blue)
            
            Spacer()
            
            Text("Order History")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.black)
            
            Spacer()
            
            Color.clear
                .frame(width: 50)
        }
    }
    
    private var currentOrdersSection: some View {
        VStack(alignment: .leading, spacing: 16) {
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
    
    private var patientId: String {
        return UserDefaults.standard.string(forKey: "id") ?? ""
    }
    
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

#Preview {
    OrderHistoryView()
}

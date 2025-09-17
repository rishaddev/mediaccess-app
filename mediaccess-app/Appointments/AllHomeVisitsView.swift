import SwiftUI

struct AllHomeVisitsView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var homeVisits: [HomevisitDetail] = []
    @State private var isLoading = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var selectedHomeVisit: HomevisitDetail?
    @State private var showHomeVisitDetails = false
    @State private var searchText = ""
    @State private var selectedFilter: HomeVisitFilter = .all
    
    enum HomeVisitFilter: String, CaseIterable {
        case all = "All"
        case pending = "Pending"
        case confirmed = "Confirmed"
        case completed = "Completed"
        case cancelled = "Cancelled"
    }
    
    var filteredHomeVisits: [HomevisitDetail] {
        var filtered = homeVisits
        
        if !searchText.isEmpty {
            filtered = filtered.filter { homeVisit in
                homeVisit.patientName.localizedCaseInsensitiveContains(searchText) ||
                homeVisit.address.localizedCaseInsensitiveContains(searchText) ||
                homeVisit.city.localizedCaseInsensitiveContains(searchText) ||
                homeVisit.services.joined(separator: " ").localizedCaseInsensitiveContains(searchText)
            }
        }
        
        if selectedFilter != .all {
            filtered = filtered.filter { homeVisit in
                homeVisit.status.lowercased() == selectedFilter.rawValue.lowercased()
            }
        }
        
        return filtered.sorted { homeVisit1, homeVisit2 in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
            
            let dateTime1 = dateFormatter.date(from: "\(homeVisit1.visitDate) \(homeVisit1.visitTime)") ?? Date.distantPast
            let dateTime2 = dateFormatter.date(from: "\(homeVisit2.visitDate) \(homeVisit2.visitTime)") ?? Date.distantPast
            
            return dateTime1 < dateTime2
        }
    }
    
    var body: some View {
        ZStack {
            mainContent
            
            if showHomeVisitDetails, let homeVisit = selectedHomeVisit {
                HomeVisitDetailsView(
                    homeVisit: homeVisit,
                    onBackTapped: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            showHomeVisitDetails = false
                        }
                    }
                )
                .transition(.move(edge: .trailing))
            }
        }
    }
    
    private var mainContent: some View {
        VStack(spacing: 0) {
            headerView
            
            if !homeVisits.isEmpty {
                searchAndFilterView
            }
            
            contentView
        }
        .background(Color(.systemGroupedBackground))
        .opacity(showHomeVisitDetails ? 0 : 1)
        .onAppear {
            fetchAllHomeVisits()
        }
        .alert("Error", isPresented: $showAlert) {
            Button("OK") { }
        } message: {
            Text(alertMessage)
        }
    }
    
    private var headerView: some View {
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
            
            Text("All Home Visits")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.black)
            
            Spacer()
            
            Circle()
                .fill(Color.clear)
                .frame(width: 40, height: 40)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 15)
        .background(Color(.systemGroupedBackground))
    }
    
    private var searchAndFilterView: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                
                TextField("Search home visits...", text: $searchText)
                    .textFieldStyle(PlainTextFieldStyle())
                
                if !searchText.isEmpty {
                    Button(action: {
                        searchText = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding(12)
            .background(Color.white)
            .cornerRadius(10)
            .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(HomeVisitFilter.allCases, id: \.self) { filter in
                        Button(action: {
                            selectedFilter = filter
                        }) {
                            Text(filter.rawValue)
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(selectedFilter == filter ? .white : .green)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(
                                    selectedFilter == filter ? Color.green : Color.green.opacity(0.1)
                                )
                                .cornerRadius(20)
                        }
                    }
                }
                .padding(.horizontal, 20)
            }
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 16)
    }
    
    private var contentView: some View {
        Group {
            if isLoading {
                loadingView
            } else if homeVisits.isEmpty {
                emptyView
            } else if filteredHomeVisits.isEmpty {
                noResultsView
            } else {
                homeVisitsList
            }
        }
    }
    
    private var loadingView: some View {
        VStack(spacing: 20) {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .green))
                .scaleEffect(1.5)
            
            Text("Loading all home visits...")
                .font(.system(size: 16))
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var emptyView: some View {
        VStack(spacing: 20) {
            ZStack {
                Circle()
                    .fill(Color.gray.opacity(0.1))
                    .frame(width: 80, height: 80)
                
                Image(systemName: "house.fill")
                    .font(.system(size: 32))
                    .foregroundColor(.gray)
            }
            
            Text("No home visits found")
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(.black)
            
            Text("You haven't booked any home visits yet")
                .font(.system(size: 14))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal, 40)
    }
    
    private var noResultsView: some View {
        VStack(spacing: 20) {
            ZStack {
                Circle()
                    .fill(Color.gray.opacity(0.1))
                    .frame(width: 80, height: 80)
                
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 32))
                    .foregroundColor(.gray)
            }
            
            Text("No results found")
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(.black)
            
            Text("Try adjusting your search or filter criteria")
                .font(.system(size: 14))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal, 40)
    }
    
    private var homeVisitsList: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(filteredHomeVisits) { homeVisit in
                    VStack(spacing: 8) {
                        HomeVisitCardView(homeVisit: homeVisit) {
                            selectedHomeVisit = homeVisit
                            withAnimation(.easeInOut(duration: 0.3)) {
                                showHomeVisitDetails = true
                            }
                        }
                        
                        HStack {
                            HStack(spacing: 4) {
                                Image(systemName: "person.circle.fill")
                                    .font(.system(size: 12))
                                    .foregroundColor(.gray)
                                Text("Patient: \(homeVisit.patientName)")
                                    .font(.system(size: 12))
                                    .foregroundColor(.gray)
                            }
                            
                            Spacer()
                            
                            if !homeVisit.cost.isEmpty {
                                HStack(spacing: 4) {
                                    Image(systemName: "dollarsign.circle.fill")
                                        .font(.system(size: 12))
                                        .foregroundColor(.green)
                                    Text("Cost: $\(homeVisit.cost)")
                                        .font(.system(size: 12, weight: .medium))
                                        .foregroundColor(.green)
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.bottom, 4)
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 100)
        }
    }
    
    private var patientId: String {
        return UserDefaults.standard.string(forKey: "id") ?? ""
    }
    
    private func fetchAllHomeVisits() {
        guard !patientId.isEmpty else {
            alertMessage = "Patient ID not found. Please log in again."
            showAlert = true
            return
        }
        
        guard let url = URL(string: "https://mediaccess.vercel.app/api/home-visit/all?patientId=\(patientId)") else {
            alertMessage = "Invalid home visit API endpoint"
            showAlert = true
            return
        }
        
        isLoading = true
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                isLoading = false
                
                if let error = error {
                    alertMessage = "Network error: \(error.localizedDescription)"
                    showAlert = true
                    return
                }
                
                guard let data = data else {
                    alertMessage = "No home visit data received"
                    showAlert = true
                    return
                }
                
                do {
                    struct HomeVisitsResponse: Codable {
                        let homevisits: [HomevisitDetail]
                        let count: Int
                        let message: String
                    }
                    
                    let response = try JSONDecoder().decode(HomeVisitsResponse.self, from: data)
                    self.homeVisits = response.homevisits
                    print("Successfully loaded \(response.count) home visits: \(response.message)")
                    
                } catch {
                    print("Home visit decoding error: \(error)")
                    if let responseString = String(data: data, encoding: .utf8) {
                        print("Raw response: \(responseString)")
                    }
                    alertMessage = "Failed to parse home visits data"
                    showAlert = true
                }
            }
        }.resume()
    }
}

struct AllHomeVisitsView_Previews: PreviewProvider {
    static var previews: some View {
        AllHomeVisitsView()
    }
}

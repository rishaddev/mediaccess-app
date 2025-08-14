import SwiftUI

struct HomeVisitDetailsView: View {
    let homeVisit: HomeVisitDetail
    let onBackTapped: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Button(action: {
                    onBackTapped()
                }) {
                    Image(systemName: "arrow.left")
                        .font(.title2)
                        .foregroundColor(.black)
                }
                
                Spacer()
                
                Text("Home Visit Details")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.black)
                
                Spacer()
                
                // Invisible button for balance
                Button(action: {}) {
                    Image(systemName: "arrow.left")
                        .font(.title2)
                        .opacity(0)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 10)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Visit Details Section
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Visit Details")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.black)
                        
                        VStack(spacing: 12) {
                            // Date & Time
                            HStack(spacing: 12) {
                                Image(systemName: "calendar")
                                    .font(.system(size: 20))
                                    .foregroundColor(.blue)
                                    .frame(width: 24, height: 24)
                                
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("Date & Time")
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(.black)
                                    
                                    Text(homeVisit.dateTime)
                                        .font(.system(size: 14))
                                        .foregroundColor(.gray)
                                }
                                
                                Spacer()
                            }
                            
                            // Address
                            HStack(spacing: 12) {
                                Image(systemName: "location")
                                    .font(.system(size: 20))
                                    .foregroundColor(.blue)
                                    .frame(width: 24, height: 24)
                                
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("Address")
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(.black)
                                    
                                    Text(homeVisit.address)
                                        .font(.system(size: 14))
                                        .foregroundColor(.gray)
                                }
                                
                                Spacer()
                            }
                        }
                    }
                    
                    // Services Section
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Services")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.black)
                        
                        VStack(spacing: 12) {
                            ForEach(homeVisit.services, id: \.self) { service in
                                HStack(spacing: 12) {
                                    Image(systemName: serviceIcon(for: service))
                                        .font(.system(size: 20))
                                        .foregroundColor(.blue)
                                        .frame(width: 24, height: 24)
                                    
                                    Text(service)
                                        .font(.system(size: 16))
                                        .foregroundColor(.black)
                                    
                                    Spacer()
                                }
                            }
                        }
                    }
                    
                    // Payment Section
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Payment")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.black)
                        
                        VStack(spacing: 12) {
                            // Total Cost
                            HStack(spacing: 12) {
                                Image(systemName: "dollarsign.circle")
                                    .font(.system(size: 20))
                                    .foregroundColor(.blue)
                                    .frame(width: 24, height: 24)
                                
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("Total Cost")
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(.black)
                                    
                                    Text("$\(String(format: "%.2f", homeVisit.totalCost))")
                                        .font(.system(size: 14))
                                        .foregroundColor(.gray)
                                }
                                
                                Spacer()
                            }
                            
                            // Status
                            HStack(spacing: 12) {
                                Image(systemName: "checkmark.circle")
                                    .font(.system(size: 20))
                                    .foregroundColor(.green)
                                    .frame(width: 24, height: 24)
                                
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("Status")
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(.black)
                                    
                                    Text(homeVisit.paymentStatus)
                                        .font(.system(size: 14))
                                        .foregroundColor(.green)
                                }
                                
                                Spacer()
                            }
                        }
                    }
                    
                    // Instructions Section
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Instructions")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.black)
                        
                        Text(homeVisit.instructions)
                            .font(.system(size: 15))
                            .foregroundColor(.black)
                            .lineSpacing(4)
                    }
                    
                    // Contact Section
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Contact")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.black)
                        
                        Button(action: {
                            // Handle phone call
                            if let url = URL(string: "tel://\(homeVisit.supportPhone)") {
                                UIApplication.shared.open(url)
                            }
                        }) {
                            HStack(spacing: 12) {
                                Image(systemName: "phone")
                                    .font(.system(size: 20))
                                    .foregroundColor(.blue)
                                    .frame(width: 24, height: 24)
                                
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("Support")
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(.black)
                                    
                                    Text(homeVisit.supportPhone)
                                        .font(.system(size: 14))
                                        .foregroundColor(.blue)
                                }
                                
                                Spacer()
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    
                    Spacer(minLength: 100)
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
            }
        }
        .background(Color.white)
    }
    
    private func serviceIcon(for service: String) -> String {
        switch service.lowercased() {
        case "blood test":
            return "drop"
        case "ecg":
            return "heart"
        case "nurse visit":
            return "person"
        default:
            return "stethoscope"
        }
    }
}

struct HomeVisitDetail: Identifiable {
    let id = UUID()
    let title: String
    let dateTime: String
    let address: String
    let services: [String]
    let totalCost: Double
    let paymentStatus: String
    let instructions: String
    let supportPhone: String
}

extension HomeVisitDetail {
    static let sampleData = [
        HomeVisitDetail(
            title: "Nurse Visit",
            dateTime: "Tue, Jul 25, 2024 • 10:00 AM",
            address: "123 Health St, Apt 4B, Cityville, CA 90210",
            services: ["Blood Test", "ECG", "Nurse Visit"],
            totalCost: 150.00,
            paymentStatus: "Paid",
            instructions: "Please ensure the patient is fasting for at least 12 hours before the blood test. Have a valid ID ready for verification.",
            supportPhone: "555-123-4567"
        )
    ]
}


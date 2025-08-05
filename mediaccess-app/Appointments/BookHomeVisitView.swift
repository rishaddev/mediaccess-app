import SwiftUI

struct Service {
    let id = UUID()
    let category: String
    let title: String
    let description: String
    let iconName: String
    let backgroundColor: Color
}

struct BookHomeVisitView: View {
    @State private var selectedService: Service?
    @State private var selectedDate = ""
    @State private var selectedTime = ""
    @State private var streetAddress = ""
    @State private var city = ""
    @State private var postalCode = ""
    @State private var showingDatePicker = false
    @State private var showingTimePicker = false
    @State private var date = Date()
    
    let onBackTapped: () -> Void
    
    private let services = [
        Service(
            category: "Blood Test",
            title: "Comprehensive Blood Analysis",
            description: "Full panel blood test for overall health assessment.",
            iconName: "testtube.2",
            backgroundColor: Color.red.opacity(0.3)
        ),
        Service(
            category: "ECG",
            title: "Electrocardiogram",
            description: "Heart activity monitoring for cardiac health.",
            iconName: "waveform.path.ecg",
            backgroundColor: Color.yellow.opacity(0.3)
        ),
        Service(
            category: "Nurse Visit",
            title: "Routine Health Check",
            description: "Basic health checkup by a registered nurse.",
            iconName: "stethoscope",
            backgroundColor: Color.orange.opacity(0.3)
        )
    ]
    
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
                
                Text("Book Home Visit")
                    .font(.system(size: 20, weight: .semibold))
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
            .padding(.top, 10)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Select Service
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Select Service")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.black)
                        
                        ForEach(services, id: \.id) { service in
                            Button(action: {
                                selectedService = service
                            }) {
                                HStack(spacing: 16) {
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text(service.category)
                                            .font(.system(size: 12, weight: .medium))
                                            .foregroundColor(.gray)
                                        
                                        Text(service.title)
                                            .font(.system(size: 16, weight: .semibold))
                                            .foregroundColor(.black)
                                        
                                        Text(service.description)
                                            .font(.system(size: 14))
                                            .foregroundColor(.gray)
                                            .multilineTextAlignment(.leading)
                                        
                                        Button(action: {
                                            selectedService = service
                                        }) {
                                            Text("Select")
                                                .font(.system(size: 14, weight: .medium))
                                                .foregroundColor(.blue)
                                                .padding(.horizontal, 16)
                                                .padding(.vertical, 8)
                                                .background(selectedService?.id == service.id ? Color.blue.opacity(0.1) : Color.clear)
                                                .cornerRadius(6)
                                        }
                                    }
                                    
                                    Spacer()
                                    
                                    // Service Icon
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(service.backgroundColor)
                                        .frame(width: 80, height: 80)
                                        .overlay(
                                            Image(systemName: service.iconName)
                                                .font(.title2)
                                                .foregroundColor(.black)
                                        )
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 16)
                                .background(Color.gray.opacity(0.05))
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(selectedService?.id == service.id ? Color.blue : Color.clear, lineWidth: 2)
                                )
                            }
                        }
                    }
                    
                    // Select Date & Time
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Select Date & Time")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.black)
                        
                        VStack(spacing: 12) {
                            // Date Selection
                            Button(action: {
                                showingDatePicker = true
                            }) {
                                HStack {
                                    Text(selectedDate.isEmpty ? "Select Date" : selectedDate)
                                        .foregroundColor(selectedDate.isEmpty ? .gray : .black)
                                    Spacer()
                                    Image(systemName: "chevron.down")
                                        .foregroundColor(.gray)
                                        .font(.system(size: 14))
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 16)
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(12)
                            }
                            
                            // Time Selection
                            Button(action: {
                                showingTimePicker = true
                            }) {
                                HStack {
                                    Text(selectedTime.isEmpty ? "Select Time" : selectedTime)
                                        .foregroundColor(selectedTime.isEmpty ? .gray : .black)
                                    Spacer()
                                    Image(systemName: "chevron.down")
                                        .foregroundColor(.gray)
                                        .font(.system(size: 14))
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 16)
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(12)
                            }
                        }
                    }
                    
                    // Enter Address
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Enter Address")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.black)
                        
                        VStack(spacing: 12) {
                            TextField("Street Address", text: $streetAddress)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 16)
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(12)
                                .font(.system(size: 16))
                            
                            TextField("City", text: $city)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 16)
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(12)
                                .font(.system(size: 16))
                            
                            TextField("Postal Code", text: $postalCode)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 16)
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(12)
                                .font(.system(size: 16))
                        }
                    }
                    
                    // Map Placeholder
                    VStack(alignment: .leading, spacing: 12) {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.blue.opacity(0.3))
                            .frame(height: 200)
                            .overlay(
                                VStack {
                                    Image(systemName: "map")
                                        .font(.system(size: 40))
                                        .foregroundColor(.blue)
                                    Text("Map View")
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(.blue)
                                }
                            )
                    }
                    
                    Spacer(minLength: 100)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
            }
            
            // Confirm Home Visit Button
            Button(action: {
                // Handle booking
                print("Confirming home visit...")
            }) {
                Text("Confirm Home Visit")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(Color.blue)
                    .cornerRadius(12)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
        .background(Color.white)
        .sheet(isPresented: $showingDatePicker) {
            DatePicker("Select Date", selection: $date, displayedComponents: .date)
                .datePickerStyle(WheelDatePickerStyle())
                .presentationDetents([.medium])
                .onDisappear {
                    let formatter = DateFormatter()
                    formatter.dateStyle = .medium
                    selectedDate = formatter.string(from: date)
                }
        }
        .sheet(isPresented: $showingTimePicker) {
            DatePicker("Select Time", selection: $date, displayedComponents: .hourAndMinute)
                .datePickerStyle(WheelDatePickerStyle())
                .presentationDetents([.medium])
                .onDisappear {
                    let formatter = DateFormatter()
                    formatter.timeStyle = .short
                    selectedTime = formatter.string(from: date)
                }
        }
    }
}

struct BookHomeVisitView_Previews: PreviewProvider {
    static var previews: some View {
        BookHomeVisitView(onBackTapped: {})
    }
}

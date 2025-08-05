import SwiftUI

struct Doctor {
    let id = UUID()
    let name: String
    let specialty: String
    let imageName: String
}

struct BookAppointmentView: View {
    @State private var selectedDepartment = ""
    @State private var selectedDoctor: Doctor?
    @State private var selectedDate = ""
    @State private var selectedTime = ""
    @State private var showingDatePicker = false
    @State private var showingTimePicker = false
    @State private var date = Date()
    
    let onBackTapped: () -> Void
    
    private let doctors = [
        Doctor(name: "Dr. Amelia Harper", specialty: "Cardiologist", imageName: "doctor_female"),
        Doctor(name: "Dr. Ethan Carter", specialty: "Cardiologist", imageName: "doctor_male")
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
                
                Text("Book Appointment")
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
                    // Select Department
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Select Department")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.black)
                        
                        TextField("Choose department", text: $selectedDepartment)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 16)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(12)
                            .font(.system(size: 16))
                    }
                    
                    // Choose a Doctor
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Choose a Doctor")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.black)
                        
                        ForEach(doctors, id: \.id) { doctor in
                            Button(action: {
                                selectedDoctor = doctor
                            }) {
                                HStack(spacing: 12) {
                                    // Doctor Avatar
                                    Circle()
                                        .fill(Color.teal.opacity(0.3))
                                        .frame(width: 60, height: 60)
                                        .overlay(
                                            Image(systemName: "person.fill")
                                                .font(.title2)
                                                .foregroundColor(.teal)
                                        )
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(doctor.name)
                                            .font(.system(size: 16, weight: .medium))
                                            .foregroundColor(.black)
                                        
                                        Text(doctor.specialty)
                                            .font(.system(size: 14))
                                            .foregroundColor(.gray)
                                    }
                                    
                                    Spacer()
                                    
                                    if selectedDoctor?.id == doctor.id {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundColor(.blue)
                                            .font(.title3)
                                    }
                                }
                                .padding(.vertical, 8)
                            }
                        }
                    }
                    
                    // Select Date & Time
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Select Date & Time")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.black)
                        
                        VStack(spacing: 12) {
                            // Date Picker
                            Button(action: {
                                showingDatePicker = true
                            }) {
                                HStack {
                                    Text(selectedDate.isEmpty ? "Select Date" : selectedDate)
                                        .foregroundColor(selectedDate.isEmpty ? .gray : .black)
                                    Spacer()
                                    Image(systemName: "calendar")
                                        .foregroundColor(.gray)
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 16)
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(12)
                            }
                            
                            // Time Picker
                            Button(action: {
                                showingTimePicker = true
                            }) {
                                HStack {
                                    Text(selectedTime.isEmpty ? "Select Time" : selectedTime)
                                        .foregroundColor(selectedTime.isEmpty ? .gray : .black)
                                    Spacer()
                                    Image(systemName: "clock")
                                        .foregroundColor(.gray)
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 16)
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(12)
                            }
                        }
                    }
                    
                    Spacer(minLength: 100)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
            }
            
            // Book Appointment Button
            Button(action: {
                // Handle booking
                print("Booking appointment...")
            }) {
                Text("Book Appointment")
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

struct BookAppointmentView_Previews: PreviewProvider {
    static var previews: some View {
        BookAppointmentView(onBackTapped: {})
    }
}

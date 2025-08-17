import SwiftUI

// Updated Doctor model to match API response
struct Doctor: Codable, Identifiable {
    let id: String
    let name: String
    let speciality: String // Note: "speciality" not "specialty"
    let email: String
    let imageURL: String
    let createdDate: String
    let createdTime: String
    
    // Custom coding keys to handle the field name difference
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case speciality
        case email
        case imageURL
        case createdDate
        case createdTime
    }
    
    // Computed property to maintain compatibility with existing UI code
    var specialty: String {
        return speciality
    }
}

struct BookAppointmentView: View {
    @State private var searchText = ""
    @State private var selectedDoctor: Doctor?
    @State private var selectedDate = ""
    @State private var selectedTime = ""
    @State private var showingDatePicker = false
    @State private var showingTimePicker = false
    @State private var date = Date()
    @State private var doctors: [Doctor] = []
    @State private var isLoading = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    let onBackTapped: () -> Void
    
    // Filtered doctors based on search text
    private var filteredDoctors: [Doctor] {
        if searchText.isEmpty {
            return doctors
        } else {
            return doctors.filter { doctor in
                doctor.name.localizedCaseInsensitiveContains(searchText) ||
                doctor.specialty.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            headerView
            
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    searchDoctorsSection
                    selectedDoctorSection
                    availableDoctorsSection
                    selectDateTimeSection
                    Spacer(minLength: 100)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
            }
            
            bookAppointmentButton
        }
        .background(Color.white)
        .onAppear {
            fetchDoctors()
        }
        .sheet(isPresented: $showingDatePicker) {
            datePickerSheet
        }
        .sheet(isPresented: $showingTimePicker) {
            timePickerSheet
        }
        .alert("Booking Status", isPresented: $showAlert) {
            Button("OK") { }
        } message: {
            Text(alertMessage)
        }
    }
    
    // MARK: - Header View
    private var headerView: some View {
        HStack {
            Button(action: onBackTapped) {
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
    }
    
    // MARK: - Search Doctors Section
    private var searchDoctorsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Search Doctors")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.black)
            
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                
                TextField("Search by name or specialty", text: $searchText)
                    .font(.system(size: 16))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(12)
        }
    }
    
    // MARK: - Selected Doctor Section
    @ViewBuilder
    private var selectedDoctorSection: some View {
        if let selectedDoctor = selectedDoctor {
            VStack(alignment: .leading, spacing: 12) {
                Text("Selected Doctor")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.black)
                
                selectedDoctorCard(doctor: selectedDoctor)
            }
        }
    }
    
    private func selectedDoctorCard(doctor: Doctor) -> some View {
        HStack(spacing: 12) {
            doctorImage(imageURL: doctor.imageURL)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(doctor.name)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.black)
                
                Text(doctor.specialty)
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                
                Text(doctor.email)
                    .font(.system(size: 12))
                    .foregroundColor(.blue)
            }
            
            Spacer()
            
            Button(action: {
                selectedDoctor = nil
            }) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.gray)
                    .font(.title3)
            }
        }
        .padding()
        .background(Color.blue.opacity(0.1))
        .cornerRadius(12)
    }
    
    // MARK: - Available Doctors Section
    private var availableDoctorsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Available Doctors")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.black)
            
            doctorsListContent
        }
    }
    
    @ViewBuilder
    private var doctorsListContent: some View {
        if isLoading {
            loadingView
        } else if filteredDoctors.isEmpty {
            emptyStateView
        } else {
            doctorsList
        }
    }
    
    private var loadingView: some View {
        HStack {
            Spacer()
            VStack(spacing: 16) {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                Text("Loading doctors...")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }
            Spacer()
        }
        .padding(.vertical, 40)
    }
    
    private var emptyStateView: some View {
        HStack {
            Spacer()
            VStack(spacing: 8) {
                Image(systemName: "person.slash")
                    .font(.title)
                    .foregroundColor(.gray)
                Text(searchText.isEmpty ? "No doctors available" : "No doctors found")
                    .font(.system(size: 16))
                    .foregroundColor(.gray)
            }
            Spacer()
        }
        .padding(.vertical, 40)
    }
    
    private var doctorsList: some View {
        ForEach(filteredDoctors) { doctor in
            doctorRow(doctor: doctor)
        }
    }
    
    private func doctorRow(doctor: Doctor) -> some View {
        Button(action: {
            selectedDoctor = doctor
        }) {
            HStack(spacing: 12) {
                doctorImage(imageURL: doctor.imageURL, showProgress: true)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(doctor.name)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.black)
                    
                    Text(doctor.specialty)
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                    
                    Text(doctor.email)
                        .font(.system(size: 12))
                        .foregroundColor(.blue)
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
    
    // MARK: - Doctor Image Helper
    private func doctorImage(imageURL: String, showProgress: Bool = false) -> some View {
        AsyncImage(url: URL(string: imageURL)) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
        } placeholder: {
            Circle()
                .fill(Color.teal.opacity(0.3))
                .overlay(
                    Group {
                        if showProgress {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .teal))
                                .scaleEffect(0.7)
                        } else {
                            Image(systemName: "person.fill")
                                .font(.title2)
                                .foregroundColor(.teal)
                        }
                    }
                )
        }
        .frame(width: 60, height: 60)
        .clipShape(Circle())
    }
    
    // MARK: - Select Date & Time Section
    private var selectDateTimeSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Select Date & Time")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.black)
            
            VStack(spacing: 12) {
                datePickerButton
                timePickerButton
            }
        }
    }
    
    private var datePickerButton: some View {
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
    }
    
    private var timePickerButton: some View {
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
    
    // MARK: - Book Appointment Button
    private var bookAppointmentButton: some View {
        Button(action: bookAppointment) {
            Text("Book Appointment")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(isBookingEnabled ? Color.blue : Color.gray)
                .cornerRadius(12)
        }
        .disabled(!isBookingEnabled)
        .padding(.horizontal, 20)
        .padding(.bottom, 20)
    }
    
    // MARK: - Sheet Views
    private var datePickerSheet: some View {
        DatePicker("Select Date", selection: $date, in: Date()..., displayedComponents: .date)
            .datePickerStyle(WheelDatePickerStyle())
            .presentationDetents([.medium])
            .onDisappear {
                let formatter = DateFormatter()
                formatter.dateStyle = .medium
                selectedDate = formatter.string(from: date)
            }
    }
    
    private var timePickerSheet: some View {
        DatePicker("Select Time", selection: $date, displayedComponents: .hourAndMinute)
            .datePickerStyle(WheelDatePickerStyle())
            .presentationDetents([.medium])
            .onDisappear {
                let formatter = DateFormatter()
                formatter.timeStyle = .short
                selectedTime = formatter.string(from: date)
            }
    }
    
    // MARK: - Helper Properties and Functions
    
    // Check if booking is enabled (all required fields are filled)
    private var isBookingEnabled: Bool {
        return selectedDoctor != nil && !selectedDate.isEmpty && !selectedTime.isEmpty
    }
    
    private func fetchDoctors() {
        guard let url = URL(string: "https://mediaccess.vercel.app/api/doctor/all") else {
            alertMessage = "Invalid API endpoint"
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
                    alertMessage = "No data received"
                    showAlert = true
                    return
                }
                
                do {
                    // Create a wrapper struct to match the API response
                    struct DoctorsResponse: Codable {
                        let allDoctors: [Doctor]
                    }
                    
                    let response = try JSONDecoder().decode(DoctorsResponse.self, from: data)
                    self.doctors = response.allDoctors
                    
                    print("Successfully loaded \(self.doctors.count) doctors") // Debug log
                    
                } catch {
                    print("Decoding error: \(error)") // Debug log
                    alertMessage = "Failed to parse doctors data: \(error.localizedDescription)"
                    showAlert = true
                }
            }
        }.resume()
    }
    
    // Book appointment function
    private func bookAppointment() {
        guard let doctor = selectedDoctor else {
            alertMessage = "Please select a doctor"
            showAlert = true
            return
        }
        
        // TODO: Implement appointment booking API call
        alertMessage = "Appointment booked with \(doctor.name) on \(selectedDate) at \(selectedTime)"
        showAlert = true
    }
}

struct BookAppointmentView_Previews: PreviewProvider {
    static var previews: some View {
        BookAppointmentView(onBackTapped: {})
    }
}

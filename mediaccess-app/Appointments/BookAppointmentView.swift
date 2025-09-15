import UserNotifications
import SwiftUI
import MapKit

struct Doctor: Codable, Identifiable {
    let id: String
    let name: String
    let speciality: String
    let email: String
    let imageURL: String
    let createdDate: String
    let createdTime: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case speciality
        case email
        case imageURL
        case createdDate
        case createdTime
    }
    
    var specialty: String {
        return speciality
    }
}

struct PatientOption: Identifiable {
    let id: String
    let name: String
    let relationship: String
    let dob: String
    
    var displayName: String {
        return "\(name) (\(relationship))"
    }
}

struct AppointmentBookingRequest: Codable {
    let patientId: String
    let patientName: String
    let contactNumber: String
    let dob: String
    let doctorName: String
    let speciality: String
    let appointmentDate: String
    let appointmentTime: String
}

struct BookAppointmentView: View {
    @State private var searchText = ""
    @State private var selectedDoctor: Doctor?
    @State private var selectedDate = ""
    @State private var selectedTime = ""
    @State private var showingDatePicker = false
    @State private var showingTimePicker = false
    @State private var showingPatientPicker = false
    @State private var date = Date()
    @State private var doctors: [Doctor] = []
    @State private var isLoading = false
    @State private var isBooking = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    @State private var patientOptions: [PatientOption] = []
    @State private var selectedPatient: PatientOption?
    
    @State private var editablePatientName = ""
    @State private var editableContactNumber = ""
    @State private var editableDob = ""
    
    @State private var showingNotificationAlert = false
    @State private var notificationMessage = ""
    @StateObject private var notificationManager = NotificationManager.shared
    
    let onBackTapped: () -> Void
    
    private var guardianContactNumber: String {
        return UserDefaults.standard.string(forKey: "contactNumber") ?? ""
    }
    
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
                VStack(spacing: 20) {
                    patientSelectionSection
                    patientDetailsSection
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
        .background(Color(.systemGroupedBackground))
        .onAppear {
            loadPatientOptions()
            fetchDoctors()
            notificationManager.requestPermission()
        }
        .sheet(isPresented: $showingPatientPicker) {
            patientPickerSheet
        }
        .sheet(isPresented: $showingDatePicker) {
            datePickerSheet
        }
        .sheet(isPresented: $showingTimePicker) {
            timePickerSheet
        }
        .alert("Booking Status", isPresented: $showAlert) {
            Button("OK") {
                if alertMessage.contains("successfully") {
                    resetForm()
                }
            }
        } message: {
            Text(alertMessage)
        }
        .alert("Notification Settings", isPresented: $showingNotificationAlert) {
            Button("OK") { }
        } message: {
            Text(notificationMessage)
        }
    }
    
    private var headerView: some View {
        HStack {
            Button(action: onBackTapped) {
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
            
            Text("Book Appointment")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.black)
            
            Spacer()
            
            Circle()
                .fill(Color.clear)
                .frame(width: 40, height: 40)
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
        .padding(.bottom, 5)
        .background(Color(.systemGroupedBackground))
    }
    
    private var patientSelectionSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Select Patient")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.black)
            
            Button(action: {
                showingPatientPicker = true
            }) {
                HStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(Color.green.opacity(0.1))
                            .frame(width: 35, height: 35)
                        
                        Image(systemName: "person.circle")
                            .font(.system(size: 14))
                            .foregroundColor(.green)
                    }
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Patient")
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                        
                        Text(selectedPatient?.displayName ?? "Select Patient")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(selectedPatient != nil ? .black : .gray)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.down")
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                }
                .padding(16)
                .background(Color.white)
                .cornerRadius(12)
                .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
            }
        }
    }
    
    private var patientPickerSheet: some View {
        NavigationView {
            VStack(spacing: 0) {
                List(patientOptions, id: \.id) { patient in
                    Button(action: {
                        selectedPatient = patient
                        updatePatientDetails(for: patient)
                        showingPatientPicker = false
                    }) {
                        HStack(spacing: 12) {
                            ZStack {
                                Circle()
                                    .fill(patient.relationship == "Self" ? Color.green.opacity(0.1) : Color.blue.opacity(0.1))
                                    .frame(width: 40, height: 40)
                                
                                Image(systemName: patient.relationship == "Self" ? "person.crop.circle.fill" : "person.fill")
                                    .font(.system(size: 18))
                                    .foregroundColor(patient.relationship == "Self" ? .green : .blue)
                            }
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(patient.name)
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.black)
                                
                                Text(patient.relationship)
                                    .font(.system(size: 14))
                                    .foregroundColor(.gray)
                            }
                            
                            Spacer()
                            
                            if selectedPatient?.id == patient.id {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                                    .font(.system(size: 18))
                            }
                        }
                        .padding(.vertical, 4)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .navigationTitle("Select Patient")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        showingPatientPicker = false
                    }
                }
            }
        }
        .presentationDetents([.medium, .large])
    }
    
    private var patientDetailsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Patient Information")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.black)
            
            VStack(spacing: 12) {
                patientInfoField(title: "Full Name", value: $editablePatientName, placeholder: "Enter patient's full name", icon: "person.fill")
                patientInfoField(title: "Contact Number", value: $editableContactNumber, placeholder: "Enter contact number", icon: "phone.fill")
                patientInfoField(title: "Date of Birth", value: $editableDob, placeholder: "Enter date of birth (YYYY-MM-DD)", icon: "calendar")
            }
            .padding(16)
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
        }
    }
    
    private func patientInfoField(title: String, value: Binding<String>, placeholder: String, icon: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(Color.blue.opacity(0.1))
                        .frame(width: 35, height: 35)
                    
                    Image(systemName: icon)
                        .font(.system(size: 14))
                        .foregroundColor(.blue)
                }
                
                Text(title)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.black)
                
                Spacer()
            }
            
            TextField(placeholder, text: value)
                .font(.system(size: 16))
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
                .background(Color(.systemGray6))
                .cornerRadius(8)
        }
    }
    
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
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
        }
    }
    
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
            doctorIcon()
            
            VStack(alignment: .leading, spacing: 4) {
                Text(doctor.name)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.black)
                
                Text(doctor.specialty)
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                
                HStack(spacing: 4) {
                    Image(systemName: "envelope")
                        .font(.system(size: 10))
                    Text(doctor.email)
                        .font(.system(size: 12))
                }
                .foregroundColor(.blue)
                .padding(6)
                .background(Color.blue.opacity(0.1))
                .cornerRadius(6)
            }
            
            Spacer()
            
            Button(action: {
                selectedDoctor = nil
            }) {
                ZStack {
                    Circle()
                        .fill(Color.red.opacity(0.1))
                        .frame(width: 30, height: 30)
                    
                    Image(systemName: "xmark")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.red)
                }
            }
        }
        .padding(16)
        .background(Color.green.opacity(0.05))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.green.opacity(0.3), lineWidth: 1)
        )
    }
    
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
            VStack(spacing: 12) {
                ForEach(filteredDoctors) { doctor in
                    doctorRow(doctor: doctor)
                }
            }
        }
    }
    
    private var loadingView: some View {
        VStack(spacing: 16) {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                .scaleEffect(1.2)
            Text("Loading doctors...")
                .font(.system(size: 14))
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
        .background(Color.white)
        .cornerRadius(12)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(Color.gray.opacity(0.1))
                    .frame(width: 60, height: 60)
                
                Image(systemName: "person.slash")
                    .font(.system(size: 24))
                    .foregroundColor(.gray)
            }
            
            Text(searchText.isEmpty ? "No doctors available" : "No doctors found")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.gray)
            
            if !searchText.isEmpty {
                Text("Try a different search term")
                    .font(.system(size: 14))
                    .foregroundColor(.gray.opacity(0.7))
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
        .background(Color.white)
        .cornerRadius(12)
    }
    
    private func doctorRow(doctor: Doctor) -> some View {
        Button(action: {
            selectedDoctor = doctor
        }) {
            HStack(spacing: 12) {
                doctorIcon()
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(doctor.name)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.black)
                    
                    Text(doctor.specialty)
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                    
                    HStack(spacing: 4) {
                        Image(systemName: "envelope")
                            .font(.system(size: 10))
                        Text(doctor.email)
                            .font(.system(size: 12))
                    }
                    .foregroundColor(.blue)
                    .padding(4)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(4)
                }
                
                Spacer()
                
                if selectedDoctor?.id == doctor.id {
                    ZStack {
                        Circle()
                            .fill(Color.green)
                            .frame(width: 24, height: 24)
                        
                        Image(systemName: "checkmark")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.white)
                    }
                } else {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                }
            }
            .padding(16)
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func doctorIcon() -> some View {
        ZStack {
            Circle()
                .fill(Color.blue.opacity(0.1))
                .frame(width: 60, height: 60)
            
            Image(systemName: "stethoscope")
                .font(.system(size: 24))
                .foregroundColor(.blue)
        }
    }
    
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
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(Color.orange.opacity(0.1))
                        .frame(width: 35, height: 35)
                    
                    Image(systemName: "calendar")
                        .font(.system(size: 14))
                        .foregroundColor(.orange)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Appointment Date")
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                    
                    Text(selectedDate.isEmpty ? "Select Date" : selectedDate)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(selectedDate.isEmpty ? .gray : .black)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
            }
            .padding(16)
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
        }
    }
    
    private var timePickerButton: some View {
        Button(action: {
            showingTimePicker = true
        }) {
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(Color.purple.opacity(0.1))
                        .frame(width: 35, height: 35)
                    
                    Image(systemName: "clock")
                        .font(.system(size: 14))
                        .foregroundColor(.purple)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Appointment Time")
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                    
                    Text(selectedTime.isEmpty ? "Select Time" : selectedTime)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(selectedTime.isEmpty ? .gray : .black)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
            }
            .padding(16)
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
        }
    }
    
    private var bookAppointmentButton: some View {
        Button(action: bookAppointment) {
            HStack {
                if isBooking {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(0.8)
                } else if isBookingEnabled {
                    Image(systemName: "calendar.badge.plus")
                        .font(.system(size: 16, weight: .semibold))
                }
                
                Text(isBooking ? "Booking..." : "Book Appointment")
                    .font(.system(size: 18, weight: .semibold))
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: isBookingEnabled && !isBooking ? [Color.blue, Color.blue.opacity(0.8)] : [Color.gray, Color.gray.opacity(0.8)]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(16)
        }
        .disabled(!isBookingEnabled || isBooking)
        .padding(.horizontal, 20)
        .padding(.bottom, 30)
    }
    
    private var datePickerSheet: some View {
        NavigationView {
            VStack {
                DatePicker("Select Date", selection: $date, in: Date()..., displayedComponents: .date)
                    .datePickerStyle(WheelDatePickerStyle())
                    .padding()
                
                Spacer()
            }
            .navigationTitle("Select Date")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        let formatter = DateFormatter()
                        formatter.dateFormat = "yyyy-MM-dd"
                        selectedDate = formatter.string(from: date)
                        showingDatePicker = false
                    }
                }
            }
        }
        .presentationDetents([.medium])
    }
    
    private var timePickerSheet: some View {
        NavigationView {
            VStack {
                DatePicker("Select Time", selection: $date, displayedComponents: .hourAndMinute)
                    .datePickerStyle(WheelDatePickerStyle())
                    .padding()
                
                Spacer()
            }
            .navigationTitle("Select Time")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        let formatter = DateFormatter()
                        formatter.dateFormat = "HH:mm"
                        selectedTime = formatter.string(from: date)
                        showingTimePicker = false
                    }
                }
            }
        }
        .presentationDetents([.medium])
    }
    
    private var isBookingEnabled: Bool {
        return selectedPatient != nil &&
        selectedDoctor != nil &&
        !selectedDate.isEmpty &&
        !selectedTime.isEmpty &&
        !editablePatientName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !editableContactNumber.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !editableDob.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    private func loadPatientOptions() {
        var options: [PatientOption] = []
        
        let primaryUserId = UserDefaults.standard.string(forKey: "id") ?? ""
        let primaryUserName = getPrimaryUserName()
        let primaryUserDob = UserDefaults.standard.string(forKey: "dob") ?? ""
        
        let primaryUser = PatientOption(
            id: primaryUserId,
            name: primaryUserName,
            relationship: "Self",
            dob: primaryUserDob
        )
        options.append(primaryUser)
        
        if let dependentsData = UserDefaults.standard.data(forKey: "dependents"),
           let dependents = try? JSONDecoder().decode([Dependent].self, from: dependentsData) {
            let dependentOptions = dependents.map { dependent in
                PatientOption(
                    id: dependent.id,
                    name: dependent.name,
                    relationship: dependent.relationship,
                    dob: dependent.dob
                )
            }
            options.append(contentsOf: dependentOptions)
        }
        
        patientOptions = options
        
        selectedPatient = primaryUser
        updatePatientDetails(for: primaryUser)
    }
    
    private func getPrimaryUserName() -> String {
        if let storedName = UserDefaults.standard.string(forKey: "name"), !storedName.isEmpty {
            return storedName
        }
        
        let email = UserDefaults.standard.string(forKey: "email") ?? ""
        if email.contains("@") {
            let username = String(email.split(separator: "@").first ?? "User")
            return username.replacingOccurrences(of: ".", with: " ")
                .replacingOccurrences(of: "_", with: " ")
                .capitalized
        }
        return email.capitalized
    }
    
    private func updatePatientDetails(for patient: PatientOption) {
        editablePatientName = patient.name
        editableDob = patient.dob
        editableContactNumber = guardianContactNumber
    }
    
    private func resetForm() {
        selectedDoctor = nil
        selectedDate = ""
        selectedTime = ""
        searchText = ""
    }
    
    private func prepareAppointmentData() -> AppointmentBookingRequest {
        return AppointmentBookingRequest(
            patientId: selectedPatient?.id ?? "",
            patientName: editablePatientName.trimmingCharacters(in: .whitespacesAndNewlines),
            contactNumber: editableContactNumber.trimmingCharacters(in: .whitespacesAndNewlines),
            dob: editableDob.trimmingCharacters(in: .whitespacesAndNewlines),
            doctorName: selectedDoctor?.name ?? "",
            speciality: selectedDoctor?.speciality ?? "",
            appointmentDate: selectedDate,
            appointmentTime: selectedTime
        )
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
                    struct DoctorsResponse: Codable {
                        let allDoctors: [Doctor]
                    }
                    
                    let response = try JSONDecoder().decode(DoctorsResponse.self, from: data)
                    self.doctors = response.allDoctors
                    
                    print("Successfully loaded \(self.doctors.count) doctors") // Debug log
                    
                } catch {
                    print("Decoding error: \(error)")
                    alertMessage = "Failed to parse doctors data: \(error.localizedDescription)"
                    showAlert = true
                }
            }
        }.resume()
    }
    
    private func bookAppointment() {
        guard let patient = selectedPatient else {
            alertMessage = "Please select a patient"
            showAlert = true
            return
        }
        
        guard let doctor = selectedDoctor else {
            alertMessage = "Please select a doctor"
            showAlert = true
            return
        }
        
        let patientName = editablePatientName.trimmingCharacters(in: .whitespacesAndNewlines)
        let contactNumber = editableContactNumber.trimmingCharacters(in: .whitespacesAndNewlines)
        let dob = editableDob.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Validation checks
        if patientName.isEmpty {
            alertMessage = "Please enter patient's full name"
            showAlert = true
            return
        }
        
        if contactNumber.isEmpty {
            alertMessage = "Please enter contact number"
            showAlert = true
            return
        }
        
        if dob.isEmpty {
            alertMessage = "Please enter date of birth"
            showAlert = true
            return
        }
        
        guard let url = URL(string: "https://mediaccess.vercel.app/api/appointment/add") else {
            alertMessage = "Invalid API endpoint"
            showAlert = true
            return
        }
        
        let appointmentData = prepareAppointmentData()
        
        isBooking = true
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData = try JSONEncoder().encode(appointmentData)
            request.httpBody = jsonData
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                DispatchQueue.main.async {
                    isBooking = false
                    
                    if let error = error {
                        alertMessage = "Network error: \(error.localizedDescription)"
                        showAlert = true
                        return
                    }
                    
                    if let httpResponse = response as? HTTPURLResponse {
                        if httpResponse.statusCode == 200 || httpResponse.statusCode == 201 {
                            // Booking successful - now schedule notifications
                            scheduleAppointmentNotifications(
                                patientName: patientName,
                                doctorName: doctor.name,
                                specialty: doctor.specialty,
                                appointmentDate: selectedDate,
                                appointmentTime: selectedTime
                            )
                            
                            alertMessage = "Appointment successfully booked!\n\nPatient: \(patientName)\nDoctor: \(doctor.name)\nSpecialty: \(doctor.specialty)\nDate: \(selectedDate)\nTime: \(selectedTime)\n\nYou will receive reminder notifications before your appointment."
                            showAlert = true
                            
                            // Save updated contact details
                            UserDefaults.standard.set(contactNumber, forKey: "contactNumber")
                            
                        } else {
                            if let data = data,
                               let errorMessage = String(data: data, encoding: .utf8) {
                                alertMessage = "Booking failed: \(errorMessage)"
                            } else {
                                alertMessage = "Booking failed with status code: \(httpResponse.statusCode)"
                            }
                            showAlert = true
                        }
                    } else {
                        alertMessage = "Invalid response from server"
                        showAlert = true
                    }
                }
            }.resume()
            
        } catch {
            isBooking = false
            alertMessage = "Failed to prepare appointment data: \(error.localizedDescription)"
            showAlert = true
        }
    }
    
    private func scheduleAppointmentNotifications(
        patientName: String,
        doctorName: String,
        specialty: String,
        appointmentDate: String,
        appointmentTime: String
    ) {
        notificationManager.scheduleAppointmentReminder(
            patientName: patientName,
            doctorName: doctorName,
            specialty: specialty,
            appointmentDate: appointmentDate,
            appointmentTime: appointmentTime
        ) { success in
            DispatchQueue.main.async {
                if success {
                    print("Appointment reminders scheduled successfully")
                } else {
                    notificationMessage = "Appointment booked successfully, but reminders could not be scheduled. Please check your notification settings."
                    showingNotificationAlert = true
                }
            }
        }
    }
}

struct BookAppointmentView_Previews: PreviewProvider {
    static var previews: some View {
        BookAppointmentView(onBackTapped: {})
    }
}

import SwiftUI

struct ProfileView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var showingSettings = false
    let onLogout: () -> Void
    
    // State variables for editing
    @State private var isEditingName = false
    @State private var isEditingEmail = false
    @State private var isEditingPhone = false
    @State private var isEditingAddress = false
    @State private var isEditingBloodType = false
    @State private var isEditingAllergies = false
    @State private var isEditingMedications = false
    @State private var isEditingNicNo = false
    @State private var isEditingDOB = false
    @State private var isEditingGender = false
    @State private var isEditingEmergencyName = false
    @State private var isEditingEmergencyPhone = false
    @State private var isEditingEmergencyRelation = false
    
    // Get data from UserDefaults (populated during login)
    private var userData: Patient? {
        guard let patientData = UserDefaults.standard.data(forKey: "patientData") else { return nil }
        return try? JSONDecoder().decode(Patient.self, from: patientData)
    }
    
    // Editable values - initialized from stored data
    @State private var name: String
    @State private var email: String
    @State private var contactNumber: String
    @State private var address: String
    @State private var bloodType: String
    @State private var allergies: String
    @State private var medications: String
    @State private var nicNo: String
    @State private var dob: String
    @State private var gender: String
    @State private var emergencyName: String
    @State private var emergencyPhone: String
    @State private var emergencyRelation: String
    @State private var patientId: String
    
    // Custom initializer to load data from UserDefaults
    init(onLogout: @escaping () -> Void) {
        self.onLogout = onLogout
        
        // Initialize from stored patient data or fallback to defaults
        let storedName = UserDefaults.standard.string(forKey: "userName") ?? ""
        let storedEmail = UserDefaults.standard.string(forKey: "userEmail") ?? ""
        let storedContactNumber = UserDefaults.standard.string(forKey: "userPhone") ?? ""
        let storedId = UserDefaults.standard.string(forKey: "userId") ?? ""
        
        // Try to get full patient data
        var patient: Patient?
        if let patientData = UserDefaults.standard.data(forKey: "patientData") {
            patient = try? JSONDecoder().decode(Patient.self, from: patientData)
        }
        
        _name = State(initialValue: patient?.name ?? storedName)
        _email = State(initialValue: patient?.email ?? storedEmail)
        _contactNumber = State(initialValue: patient?.contactNumber ?? storedContactNumber)
        _patientId = State(initialValue: patient?.id ?? storedId)
        _address = State(initialValue: patient?.address ?? "")
        _bloodType = State(initialValue: patient?.bloodType ?? "")
        _allergies = State(initialValue: patient?.allergy ?? "")
        _medications = State(initialValue: patient?.medications ?? "")
        _nicNo = State(initialValue: patient?.nicNo ?? "")
        _dob = State(initialValue: patient?.dob ?? "")
        _gender = State(initialValue: patient?.gender ?? "")
        
        // Emergency contact data (assuming first emergency contact)
        let firstEmergencyContact = patient?.emergencyContact?.first
        _emergencyName = State(initialValue: firstEmergencyContact?.name ?? "")
        _emergencyPhone = State(initialValue: firstEmergencyContact?.contactNumber ?? "")
        _emergencyRelation = State(initialValue: firstEmergencyContact?.relation ?? "")
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "arrow.left")
                        .font(.title2)
                        .foregroundColor(.black)
                }
                
                Spacer()
                
                Text("Profile")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.black)
                
                Spacer()
                
                Button(action: {
                    showingSettings = true
                }) {
                    Image(systemName: "gearshape")
                        .font(.title2)
                        .foregroundColor(.black)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)
            
            ScrollView {
                VStack(spacing: 24) {
                    // Profile Image and Name
                    VStack(spacing: 16) {
                        // Show initials instead of image
                        ZStack {
                            Circle()
                                .fill(Color.blue.opacity(0.1))
                                .frame(width: 120, height: 120)
                            
                            Text(getInitials(from: name))
                                .font(.system(size: 36, weight: .semibold))
                                .foregroundColor(.blue)
                        }
                        
                        VStack(spacing: 4) {
                            Text(name.isEmpty ? "No Name" : name)
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.black)
                            
                            Text("Patient ID: \(patientId.isEmpty ? "N/A" : patientId)")
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.top, 30)
                    
                    // Personal Information Section
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Personal Information")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.black)
                        
                        EditableProfileInfoRow(
                            title: "Name",
                            value: $name,
                            isEditing: $isEditingName
                        )
                        EditableProfileInfoRow(
                            title: "Email",
                            value: $email,
                            isEditing: $isEditingEmail
                        )
                        EditableProfileInfoRow(
                            title: "Contact Number",
                            value: $contactNumber,
                            isEditing: $isEditingPhone
                        )
                        EditableProfileInfoRow(
                            title: "Address",
                            value: $address,
                            isEditing: $isEditingAddress
                        )
                        EditableProfileInfoRow(
                            title: "NIC Number",
                            value: $nicNo,
                            isEditing: $isEditingNicNo
                        )
                        EditableProfileInfoRow(
                            title: "Date of Birth",
                            value: $dob,
                            isEditing: $isEditingDOB
                        )
                        EditableProfileInfoRow(
                            title: "Gender",
                            value: $gender,
                            isEditing: $isEditingGender
                        )
                    }
                    .padding(.horizontal, 20)
                    
                    // Medical Information Section
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Medical Information")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.black)
                        
                        EditableProfileInfoRow(
                            title: "Blood Type",
                            value: $bloodType,
                            isEditing: $isEditingBloodType
                        )
                        EditableProfileInfoRow(
                            title: "Allergies",
                            value: $allergies,
                            isEditing: $isEditingAllergies
                        )
                        EditableProfileInfoRow(
                            title: "Medications",
                            value: $medications,
                            isEditing: $isEditingMedications
                        )
                    }
                    .padding(.horizontal, 20)
                    
                    // Emergency Contact Section
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Emergency Contact")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.black)
                        
                        EditableProfileInfoRow(
                            title: "Name",
                            value: $emergencyName,
                            isEditing: $isEditingEmergencyName
                        )
                        EditableProfileInfoRow(
                            title: "Phone",
                            value: $emergencyPhone,
                            isEditing: $isEditingEmergencyPhone
                        )
                        EditableProfileInfoRow(
                            title: "Relation",
                            value: $emergencyRelation,
                            isEditing: $isEditingEmergencyRelation
                        )
                    }
                    .padding(.horizontal, 20)
                    
                    Spacer(minLength: 100)
                }
            }
        }
        .background(Color.white)
        .fullScreenCover(isPresented: $showingSettings) {
            SettingsView(onLogout: onLogout)
        }
    }
    
    // Helper function to get initials from name
    private func getInitials(from name: String) -> String {
        guard !name.isEmpty else { return "?" }
        let components = name.components(separatedBy: " ")
        let initials = components.compactMap { $0.first }.map { String($0) }
        return initials.prefix(2).joined().uppercased()
    }
}

struct EditableProfileInfoRow: View {
    let title: String
    @Binding var value: String
    @Binding var isEditing: Bool
    @State private var tempValue: String = ""
    @State private var isUpdating = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.black)
            
            HStack {
                if isEditing {
                    TextField("Enter \(title.lowercased())", text: $tempValue)
                        .font(.system(size: 14))
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .onAppear {
                            tempValue = value
                        }
                } else {
                    Text(value.isEmpty ? "Not specified" : value)
                        .font(.system(size: 14))
                        .foregroundColor(value.isEmpty ? .gray.opacity(0.7) : .gray)
                        .italic(value.isEmpty)
                    
                    Spacer()
                }
                
                if isEditing {
                    HStack(spacing: 8) {
                        // Save button
                        Button(action: {
                            updatePatientDetails()
                        }) {
                            HStack(spacing: 4) {
                                if isUpdating {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .green))
                                        .scaleEffect(0.7)
                                } else {
                                    Image(systemName: "checkmark")
                                        .font(.system(size: 14))
                                        .foregroundColor(.green)
                                }
                            }
                        }
                        .disabled(isUpdating)
                        
                        // Cancel button
                        Button(action: {
                            tempValue = value
                            isEditing = false
                        }) {
                            Image(systemName: "xmark")
                                .font(.system(size: 14))
                                .foregroundColor(.red)
                        }
                        .disabled(isUpdating)
                    }
                } else {
                    Button(action: {
                        isEditing = true
                    }) {
                        Image(systemName: "pencil")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                    }
                }
            }
        }
        .padding(.vertical, 8)
        .alert("Update Status", isPresented: $showAlert) {
            Button("OK") { }
        } message: {
            Text(alertMessage)
        }
    }
    
    // Function to update patient details via API
    private func updatePatientDetails() {
        guard let patientId = UserDefaults.standard.string(forKey: "userId"), !patientId.isEmpty else {
            alertMessage = "Patient ID not found"
            showAlert = true
            return
        }
        
        isUpdating = true
        
        // Prepare the request body with the updated field
        var requestBody: [String: Any] = ["id": patientId]
        
        // Map the field title to the correct API field name
        let apiFieldName = getAPIFieldName(for: title)
        requestBody[apiFieldName] = tempValue
        
        // If updating emergency contact, handle it specially
        if title.contains("Emergency") {
            updateEmergencyContact(patientId: patientId, field: title, value: tempValue)
            return
        }
        
        // Make API call
        guard let url = URL(string: "https://mediaccess.vercel.app/api/patient/update") else {
            isUpdating = false
            alertMessage = "Invalid API endpoint"
            showAlert = true
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
        } catch {
            isUpdating = false
            alertMessage = "Failed to prepare request"
            showAlert = true
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                self.isUpdating = false
                
                if let error = error {
                    self.alertMessage = "Network error: \(error.localizedDescription)"
                    self.showAlert = true
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 200 {
                        // Success - update local values
                        self.value = self.tempValue
                        self.isEditing = false
                        self.updateUserDefaults(field: self.title, value: self.tempValue)
                        self.alertMessage = "\(self.title) updated successfully"
                        self.showAlert = true
                    } else {
                        // Error
                        if let data = data,
                           let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                           let message = json["message"] as? String {
                            self.alertMessage = message
                        } else {
                            self.alertMessage = "Failed to update \(self.title.lowercased())"
                        }
                        self.showAlert = true
                    }
                }
            }
        }.resume()
    }
    
    // Function to handle emergency contact updates
    private func updateEmergencyContact(patientId: String, field: String, value: String) {
        // Get current patient data
        guard let patientData = UserDefaults.standard.data(forKey: "patientData"),
              var patient = try? JSONDecoder().decode(Patient.self, from: patientData) else {
            isUpdating = false
            alertMessage = "Failed to get patient data"
            showAlert = true
            return
        }
        
        // Update emergency contact
        var emergencyContact = patient.emergencyContact?.first ?? EmergencyContact(id: "1", name: "", contactNumber: "", relation: "")
        
        switch field {
        case "Name":
            emergencyContact = EmergencyContact(id: emergencyContact.id, name: value, contactNumber: emergencyContact.contactNumber, relation: emergencyContact.relation)
        case "Phone":
            emergencyContact = EmergencyContact(id: emergencyContact.id, name: emergencyContact.name, contactNumber: value, relation: emergencyContact.relation)
        case "Relation":
            emergencyContact = EmergencyContact(id: emergencyContact.id, name: emergencyContact.name, contactNumber: emergencyContact.contactNumber, relation: value)
        default:
            break
        }
        
        // Prepare request body with emergency contact array
        let requestBody: [String: Any] = [
            "id": patientId,
            "emergencyContact": [
                [
                    "id": emergencyContact.id,
                    "name": emergencyContact.name,
                    "contactNumber": emergencyContact.contactNumber,
                    "relation": emergencyContact.relation
                ]
            ]
        ]
        
        // Make API call
        guard let url = URL(string: "https://mediaccess.vercel.app/api/patient/update") else {
            isUpdating = false
            alertMessage = "Invalid API endpoint"
            showAlert = true
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
        } catch {
            isUpdating = false
            alertMessage = "Failed to prepare request"
            showAlert = true
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                self.isUpdating = false
                
                if let error = error {
                    self.alertMessage = "Network error: \(error.localizedDescription)"
                    self.showAlert = true
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 200 {
                        // Success - update local values
                        self.value = self.tempValue
                        self.isEditing = false
                        self.updateUserDefaults(field: self.title, value: self.tempValue)
                        self.alertMessage = "Emergency contact updated successfully"
                        self.showAlert = true
                    } else {
                        // Error
                        if let data = data,
                           let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                           let message = json["message"] as? String {
                            self.alertMessage = message
                        } else {
                            self.alertMessage = "Failed to update emergency contact"
                        }
                        self.showAlert = true
                    }
                }
            }
        }.resume()
    }
    
    // Helper function to map UI field names to API field names
    private func getAPIFieldName(for fieldTitle: String) -> String {
        switch fieldTitle {
        case "Name": return "name"
        case "Email": return "email"
        case "Phone": return "contactNumber"
        case "Address": return "address"
        case "Blood Type": return "bloodType"
        case "Allergies": return "allergy"
        case "Medications": return "medications"
        case "NIC Number": return "nicNo"
        case "Date of Birth": return "dob"
        case "Gender": return "gender"
        default: return fieldTitle.lowercased().replacingOccurrences(of: " ", with: "")
        }
    }
    
    // Helper function to update UserDefaults when fields are edited
    private func updateUserDefaults(field: String, value: String) {
        switch field {
        case "Name":
            UserDefaults.standard.set(value, forKey: "name")
        case "Email":
            UserDefaults.standard.set(value, forKey: "email")
        case "Phone":
            UserDefaults.standard.set(value, forKey: "contactNumber")
        default:
            break
        }
        
        // Update the full patient data object if it exists
        if var patientData = UserDefaults.standard.data(forKey: "patientData"),
           var patient = try? JSONDecoder().decode(Patient.self, from: patientData) {
            
            // Update the patient object based on the field
            switch field {
            case "Name": patient.name = value
            case "Email": patient.email = value
            case "Phone": patient.phone = value
            case "Address": patient.address = value
            case "Blood Type": patient.bloodType = value
            case "Allergies": patient.allergy = value
            case "Medications": patient.medications = value
            case "NIC Number": patient.nicNo = value
            case "Date of Birth": patient.dob = value
            case "Gender": patient.gender = value
            default: break
            }
            
            // Save the updated patient data back to UserDefaults
            if let updatedData = try? JSONEncoder().encode(patient) {
                UserDefaults.standard.set(updatedData, forKey: "patientData")
            }
        }
    }
}

// EmergencyContact model for the emergency contact array

struct EmergencyContact: Codable {
    let id: String
    let name: String
    let contactNumber: String
    let relation: String
}

struct ProfileInfoRow: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.black)
            
            HStack {
                Text(value.isEmpty ? "Not specified" : value)
                    .font(.system(size: 14))
                    .foregroundColor(value.isEmpty ? .gray.opacity(0.7) : .gray)
                    .italic(value.isEmpty)
                
                Spacer()
                
                Button(action: {}) {
                    Image(systemName: "pencil")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(.vertical, 8)
    }
}

struct BottomNavItem: View {
    let icon: String
    let title: String
    let isSelected: Bool
    
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(isSelected ? .blue : .gray)
            
            Text(title)
                .font(.system(size: 12))
                .foregroundColor(isSelected ? .blue : .gray)
        }
        .frame(maxWidth: .infinity)
    }
}

struct TabBarItem: View {
    let icon: String
    let title: String
    let isSelected: Bool
    
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(isSelected ? .blue : .gray)
            
            Text(title)
                .font(.system(size: 12))
                .foregroundColor(isSelected ? .blue : .gray)
        }
        .frame(maxWidth: .infinity)
    }
}

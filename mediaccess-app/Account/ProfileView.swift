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
            headerView
            
            ScrollView {
                VStack(spacing: 20) {
                    profileHeaderSection
                    personalInfoSection
                    medicalInfoSection
                    emergencyContactSection
                    Spacer(minLength: 100)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
            }
        }
        .background(Color(.systemGroupedBackground))
        .fullScreenCover(isPresented: $showingSettings) {
            SettingsView(onLogout: onLogout)
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
            
            Text("Profile")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.black)
            
            Spacer()
            
            Button(action: {
                showingSettings = true
            }) {
                ZStack {
                    Circle()
                        .fill(Color.white)
                        .frame(width: 40, height: 40)
                        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
                    
                    Image(systemName: "gearshape")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.black)
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
        .padding(.bottom, 5)
        .background(Color(.systemGroupedBackground))
    }
    
    private var profileHeaderSection: some View {
        VStack(spacing: 16) {
            // Profile Avatar
            ZStack {
                Circle()
                    .fill(LinearGradient(
                        gradient: Gradient(colors: [Color.blue.opacity(0.8), Color.blue.opacity(0.6)]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))
                    .frame(width: 100, height: 100)
                    .shadow(color: .blue.opacity(0.3), radius: 10, x: 0, y: 5)
                
                Text(getInitials(from: name))
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)
            }
            
            VStack(spacing: 8) {
                Text(name.isEmpty ? "No Name" : name)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.black)
                
                HStack(spacing: 4) {
                    Image(systemName: "person.text.rectangle")
                        .font(.system(size: 12))
                        .foregroundColor(.blue)
                    Text("ID: \(patientId.isEmpty ? "N/A" : patientId)")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.gray)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color.blue.opacity(0.1))
                .cornerRadius(8)
            }
        }
        .padding(.vertical, 20)
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 2)
    }
    
    private var personalInfoSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(Color.green.opacity(0.1))
                        .frame(width: 35, height: 35)
                    
                    Image(systemName: "person.fill")
                        .font(.system(size: 16))
                        .foregroundColor(.green)
                }
                
                Text("Personal Information")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.black)
                
                Spacer()
            }
            
            VStack(spacing: 12) {
                ModernEditableRow(
                    title: "Full Name",
                    value: $name,
                    isEditing: $isEditingName,
                    icon: "person.fill",
                    iconColor: .blue
                )
                
                ModernEditableRow(
                    title: "Email Address",
                    value: $email,
                    isEditing: $isEditingEmail,
                    icon: "envelope.fill",
                    iconColor: .orange
                )
                
                ModernEditableRow(
                    title: "Contact Number",
                    value: $contactNumber,
                    isEditing: $isEditingPhone,
                    icon: "phone.fill",
                    iconColor: .green
                )
                
                ModernEditableRow(
                    title: "Address",
                    value: $address,
                    isEditing: $isEditingAddress,
                    icon: "house.fill",
                    iconColor: .purple
                )
                
                ModernEditableRow(
                    title: "NIC Number",
                    value: $nicNo,
                    isEditing: $isEditingNicNo,
                    icon: "creditcard.fill",
                    iconColor: .indigo
                )
                
                ModernEditableRow(
                    title: "Date of Birth",
                    value: $dob,
                    isEditing: $isEditingDOB,
                    icon: "calendar",
                    iconColor: .pink
                )
                
                ModernEditableRow(
                    title: "Gender",
                    value: $gender,
                    isEditing: $isEditingGender,
                    icon: "figure.dress.line.vertical.figure",
                    iconColor: .teal
                )
            }
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 2)
    }
    
    private var medicalInfoSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(Color.red.opacity(0.1))
                        .frame(width: 35, height: 35)
                    
                    Image(systemName: "heart.fill")
                        .font(.system(size: 16))
                        .foregroundColor(.red)
                }
                
                Text("Medical Information")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.black)
                
                Spacer()
            }
            
            VStack(spacing: 12) {
                ModernEditableRow(
                    title: "Blood Type",
                    value: $bloodType,
                    isEditing: $isEditingBloodType,
                    icon: "drop.fill",
                    iconColor: .red
                )
                
                ModernEditableRow(
                    title: "Allergies",
                    value: $allergies,
                    isEditing: $isEditingAllergies,
                    icon: "exclamationmark.triangle.fill",
                    iconColor: .orange
                )
                
                ModernEditableRow(
                    title: "Current Medications",
                    value: $medications,
                    isEditing: $isEditingMedications,
                    icon: "pills.fill",
                    iconColor: .blue
                )
            }
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 2)
    }
    
    private var emergencyContactSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(Color.orange.opacity(0.1))
                        .frame(width: 35, height: 35)
                    
                    Image(systemName: "phone.badge.plus")
                        .font(.system(size: 16))
                        .foregroundColor(.orange)
                }
                
                Text("Emergency Contact")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.black)
                
                Spacer()
            }
            
            VStack(spacing: 12) {
                ModernEditableRow(
                    title: "Contact Name",
                    value: $emergencyName,
                    isEditing: $isEditingEmergencyName,
                    icon: "person.crop.circle.fill",
                    iconColor: .green
                )
                
                ModernEditableRow(
                    title: "Phone Number",
                    value: $emergencyPhone,
                    isEditing: $isEditingEmergencyPhone,
                    icon: "phone.fill",
                    iconColor: .blue
                )
                
                ModernEditableRow(
                    title: "Relationship",
                    value: $emergencyRelation,
                    isEditing: $isEditingEmergencyRelation,
                    icon: "heart.fill",
                    iconColor: .pink
                )
            }
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 2)
    }
    
    // Helper function to get initials from name
    private func getInitials(from name: String) -> String {
        guard !name.isEmpty else { return "?" }
        let components = name.components(separatedBy: " ")
        let initials = components.compactMap { $0.first }.map { String($0) }
        return initials.prefix(2).joined().uppercased()
    }
}

struct ModernEditableRow: View {
    let title: String
    @Binding var value: String
    @Binding var isEditing: Bool
    let icon: String
    let iconColor: Color
    
    @State private var tempValue: String = ""
    @State private var isUpdating = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(iconColor.opacity(0.1))
                        .frame(width: 35, height: 35)
                    
                    Image(systemName: icon)
                        .font(.system(size: 14))
                        .foregroundColor(iconColor)
                }
                
                Text(title)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.black)
                
                Spacer()
                
                if !isEditing {
                    Button(action: {
                        tempValue = value
                        isEditing = true
                    }) {
                        ZStack {
                            Circle()
                                .fill(Color.gray.opacity(0.1))
                                .frame(width: 28, height: 28)
                            
                            Image(systemName: "pencil")
                                .font(.system(size: 12))
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
            
            if isEditing {
                HStack(spacing: 8) {
                    TextField("Enter \(title.lowercased())", text: $tempValue)
                        .font(.system(size: 16))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 10)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .onAppear {
                            tempValue = value
                        }
                    
                    Button(action: {
                        updatePatientDetails()
                    }) {
                        ZStack {
                            Circle()
                                .fill(Color.green.opacity(0.1))
                                .frame(width: 35, height: 35)
                            
                            if isUpdating {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .green))
                                    .scaleEffect(0.7)
                            } else {
                                Image(systemName: "checkmark")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.green)
                            }
                        }
                    }
                    .disabled(isUpdating)
                    
                    Button(action: {
                        tempValue = value
                        isEditing = false
                    }) {
                        ZStack {
                            Circle()
                                .fill(Color.red.opacity(0.1))
                                .frame(width: 35, height: 35)
                            
                            Image(systemName: "xmark")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.red)
                        }
                    }
                    .disabled(isUpdating)
                }
            } else {
                Text(value.isEmpty ? "Not specified" : value)
                    .font(.system(size: 16))
                    .foregroundColor(value.isEmpty ? .gray : .black)
                    .italic(value.isEmpty)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 10)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(.systemGray6).opacity(0.5))
                    .cornerRadius(8)
            }
        }
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
        if title.contains("Contact") || title.contains("Phone Number") || title.contains("Relationship") {
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
        case "Contact Name":
            emergencyContact = EmergencyContact(id: emergencyContact.id, name: value, contactNumber: emergencyContact.contactNumber, relation: emergencyContact.relation)
        case "Phone Number":
            emergencyContact = EmergencyContact(id: emergencyContact.id, name: emergencyContact.name, contactNumber: value, relation: emergencyContact.relation)
        case "Relationship":
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
        case "Full Name": return "name"
        case "Email Address": return "email"
        case "Contact Number": return "contactNumber"
        case "Address": return "address"
        case "Blood Type": return "bloodType"
        case "Allergies": return "allergy"
        case "Current Medications": return "medications"
        case "NIC Number": return "nicNo"
        case "Date of Birth": return "dob"
        case "Gender": return "gender"
        default: return fieldTitle.lowercased().replacingOccurrences(of: " ", with: "")
        }
    }
    
    // Helper function to update UserDefaults when fields are edited
    private func updateUserDefaults(field: String, value: String) {
        switch field {
        case "Full Name":
            UserDefaults.standard.set(value, forKey: "name")
        case "Email Address":
            UserDefaults.standard.set(value, forKey: "email")
        case "Contact Number":
            UserDefaults.standard.set(value, forKey: "contactNumber")
        default:
            break
        }
        
        // Update the full patient data object if it exists
        if var patientData = UserDefaults.standard.data(forKey: "patientData"),
           var patient = try? JSONDecoder().decode(Patient.self, from: patientData) {
            
            // Update the patient object based on the field
            switch field {
            case "Full Name": patient.name = value
            case "Email Address": patient.email = value
            case "Contact Number": patient.phone = value
            case "Address": patient.address = value
            case "Blood Type": patient.bloodType = value
            case "Allergies": patient.allergy = value
            case "Current Medications": patient.medications = value
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

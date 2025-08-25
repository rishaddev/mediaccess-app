import SwiftUI

struct AddFamilyMemberView: View {
    let onBackTapped: () -> Void
    @State private var name = ""
    @State private var relationship = ""
    @State private var selectedDate = ""
    @State private var gender = "Male"
    @State private var contactNumber = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var isAdding = false
    
    let genders = ["Male", "Female", "Other"]
    
    private var primaryUserId: String {
        return UserDefaults.standard.string(forKey: "id") ?? ""
    }
    
    
    private var primaryUserEmail: String {
        return UserDefaults.standard.string(forKey: "email") ?? ""
    }
    
    private var primaryUserName: String {
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
    
    private var isFormValid: Bool {
        return !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !relationship.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        VStack(spacing: 0) {
            headerView
            
            ScrollView {
                VStack(spacing: 20) {
                    primaryUserSection
                    familyMemberDetailsSection
                    Spacer(minLength: 100)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
            }
            
            addMemberButton
        }
        .background(Color(.systemGroupedBackground))
        .alert("Add Family Member", isPresented: $showAlert) {
            Button("OK") {
                if alertMessage.contains("successfully") {
                    resetForm()
                    onBackTapped()
                }
            }
        } message: {
            Text(alertMessage)
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
            
            Text("Add Family Member")
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
    
    private var primaryUserSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Primary Account Holder")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.black)
            
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(Color.green.opacity(0.1))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: "person.crop.circle.fill")
                        .font(.system(size: 24))
                        .foregroundColor(.green)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(primaryUserName)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.black)
                    
                    HStack(spacing: 4) {
                        Text("ID:")
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                        Text(primaryUserEmail)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.blue)
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(6)
                }
                
                Spacer()
                
                VStack(spacing: 2) {
                    Text("GUARDIAN")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(.green)
                    Text("ACCOUNT")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(.green)
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 6)
                .background(Color.green.opacity(0.1))
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.green.opacity(0.3), lineWidth: 1)
                )
            }
            .padding(16)
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
        }
    }
    
    private var familyMemberDetailsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Text("Dependent Information")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.black)
                
                ZStack {
                    Circle()
                        .fill(Color.orange.opacity(0.1))
                        .frame(width: 24, height: 24)
                    
                    Image(systemName: "person.badge.plus")
                        .font(.system(size: 12))
                        .foregroundColor(.orange)
                }
            }
            
            VStack(spacing: 16) {
                memberInfoField(
                    title: "Dependent Name",
                    value: $name,
                    placeholder: "Enter dependent's full name",
                    icon: "person.fill"
                )
                
                memberInfoField(
                    title: "Relationship to You",
                    value: $relationship,
                    placeholder: "e.g., Son, Daughter, Wife, Husband, Mother, Father",
                    icon: "heart.fill"
                )
                
                memberInfoField(
                    title: "Date of Birth",
                    value: $selectedDate,
                    placeholder: "YYYY-MM-DD",
                    icon: "calendar"
                )
                
                genderSelectionField()
                
                memberInfoField(
                    title: "Contact Number (Optional)",
                    value: $contactNumber,
                    placeholder: "Enter contact number",
                    icon: "phone.fill",
                    keyboardType: .phonePad
                )
            }
            .padding(16)
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
        }
    }

    
    private func memberInfoField(
        title: String,
        value: Binding<String>,
        placeholder: String,
        icon: String,
        keyboardType: UIKeyboardType = .default
    ) -> some View {
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
                .keyboardType(keyboardType)
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
                .background(Color(.systemGray6))
                .cornerRadius(8)
        }
    }
    
    
    private func genderSelectionField() -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(Color.purple.opacity(0.1))
                        .frame(width: 35, height: 35)
                    
                    Image(systemName: "person.2.fill")
                        .font(.system(size: 14))
                        .foregroundColor(.purple)
                }
                
                Text("Gender")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.black)
                
                Spacer()
            }
            
            HStack(spacing: 12) {
                ForEach(genders, id: \.self) { genderOption in
                    Button(action: {
                        gender = genderOption
                    }) {
                        HStack(spacing: 8) {
                            ZStack {
                                Circle()
                                    .fill(gender == genderOption ? Color.blue : Color.gray.opacity(0.2))
                                    .frame(width: 16, height: 16)
                                
                                if gender == genderOption {
                                    Circle()
                                        .fill(Color.white)
                                        .frame(width: 6, height: 6)
                                }
                            }
                            
                            Text(genderOption)
                                .font(.system(size: 14))
                                .foregroundColor(gender == genderOption ? .blue : .gray)
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(gender == genderOption ? Color.blue.opacity(0.1) : Color.gray.opacity(0.1))
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
    }
    
    private var addMemberButton: some View {
        Button(action: addFamilyMember) {
            HStack {
                if isAdding {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(0.8)
                } else if isFormValid {
                    Image(systemName: "person.badge.plus")
                        .font(.system(size: 16, weight: .semibold))
                }
                
                Text(isAdding ? "Adding Dependent..." : "Add Dependent")
                    .font(.system(size: 18, weight: .semibold))
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: isFormValid && !isAdding ? [Color.blue, Color.blue.opacity(0.8)] : [Color.gray, Color.gray.opacity(0.8)]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(16)
        }
        .disabled(!isFormValid || isAdding)
        .padding(.horizontal, 20)
        .padding(.bottom, 30)
    }
    
    private func resetForm() {
        name = ""
        relationship = ""
        selectedDate = ""
        gender = "Male"
        contactNumber = ""
    }
    
    private func addFamilyMember() {
        let dependentName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let memberRelationship = relationship.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if dependentName.isEmpty {
            alertMessage = "Please enter the dependent's full name"
            showAlert = true
            return
        }
        
        if memberRelationship.isEmpty {
            alertMessage = "Please enter the relationship"
            showAlert = true
            return
        }
        
        isAdding = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            isAdding = false
            
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            
            alertMessage = "🎉 Dependent successfully added!\n\nGuardian: \(primaryUserName)\nDependent: \(dependentName)\nRelationship: \(memberRelationship)\nDate of Birth: \(selectedDate)\nGender: \(gender)\n"
            showAlert = true
        }
        
         guard let url = URL(string: "https://mediaccess.vercel.app/api/dependent/add") else {
         alertMessage = "Invalid API endpoint"
         showAlert = true
         isAdding = false
         return
         }
         
         let formatter = DateFormatter()
         formatter.dateFormat = "yyyy-MM-dd"
         
         let dependent = [
         "guardianId": primaryUserId,
         "name": dependentName,
         "relationship": memberRelationship,
         "dateOfBirth": selectedDate,
         "gender": gender,
         "contactNumber": contactNumber
         ]
         
         var request = URLRequest(url: url)
         request.httpMethod = "POST"
         request.setValue("application/json", forHTTPHeaderField: "Content-Type")
         
         do {
         let jsonData = try JSONSerialization.data(withJSONObject: dependent)
         request.httpBody = jsonData
         
         URLSession.shared.dataTask(with: request) { data, response, error in
         DispatchQueue.main.async {
         isAdding = false
         
         if let error = error {
         alertMessage = "Network error: \(error.localizedDescription)"
         showAlert = true
         return
         }
         
         if let httpResponse = response as? HTTPURLResponse {
         if httpResponse.statusCode == 200 || httpResponse.statusCode == 201 {
         alertMessage = "🎉 Dependent successfully added!"
         showAlert = true
         } else {
         alertMessage = "Failed to add dependent"
         showAlert = true
         }
         }
         }
         }.resume()
         
         } catch {
         isAdding = false
         alertMessage = "Failed to prepare dependent data: \(error.localizedDescription)"
         showAlert = true
         }
    }
}

struct AddFamilyMemberView_Previews: PreviewProvider {
    static var previews: some View {
        AddFamilyMemberView(onBackTapped: {})
    }
}

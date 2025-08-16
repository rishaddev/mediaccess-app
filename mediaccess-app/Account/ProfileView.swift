import SwiftUI

struct ProfileView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var showingSettings = false
    
    // State variables for editing
    @State private var isEditingName = false
    @State private var isEditingEmail = false
    @State private var isEditingPhone = false
    @State private var isEditingAddress = false
    @State private var isEditingBloodType = false
    @State private var isEditingAllergies = false
    @State private var isEditingMedications = false
    @State private var isEditingEmergencyName = false
    @State private var isEditingEmergencyPhone = false
    
    // Editable values
    @State private var name = "Sophia Carter"
    @State private var email = "sophia.carter@email.com"
    @State private var phone = "+1 (555) 123-4567"
    @State private var address = "123 Main St, Anytown, USA"
    @State private var bloodType = "AB+"
    @State private var allergies = "None"
    @State private var medications = "None"
    @State private var emergencyName = "Ethan Carter"
    @State private var emergencyPhone = "+1 (555) 987-6543"
    
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
                        Image("profile_avatar")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 120, height: 120)
                            .clipShape(Circle())
                        
                        VStack(spacing: 4) {
                            Text(name)
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.black)
                            
                            Text("Patient ID: 1234567")
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
                            title: "Phone",
                            value: $phone,
                            isEditing: $isEditingPhone
                        )
                        EditableProfileInfoRow(
                            title: "Address",
                            value: $address,
                            isEditing: $isEditingAddress
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
                    }
                    .padding(.horizontal, 20)
                    
                    Spacer(minLength: 100)
                }
            }
            
            // Bottom Navigation (matching the design)
//            HStack {
//                BottomNavItem(icon: "house", title: "Home", isSelected: true)
//                BottomNavItem(icon: "calendar", title: "Appointments", isSelected: false)
//                BottomNavItem(icon: "cross.case", title: "Pharmacy", isSelected: false)
//                BottomNavItem(icon: "person.2", title: "Family", isSelected: false)
//            }
//            .padding(.horizontal, 20)
//            .padding(.vertical, 12)
//            .background(Color.white)
//            .overlay(
//                Rectangle()
//                    .frame(height: 1)
//                    .foregroundColor(Color.gray.opacity(0.2)),
//                alignment: .top
//            )
        }
        .background(Color.white)
        
        .fullScreenCover(isPresented: $showingSettings) {
            SettingsView()
        }
    }
}

struct EditableProfileInfoRow: View {
    let title: String
    @Binding var value: String
    @Binding var isEditing: Bool
    @State private var tempValue: String = ""
    
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
                    Text(value)
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                    
                    Spacer()
                }
                
                if isEditing {
                    HStack(spacing: 8) {
                        // Save button
                        Button(action: {
                            value = tempValue
                            isEditing = false
                            // TODO: Here you can add API call to update the database
                            // updateProfileField(field: title, value: tempValue)
                        }) {
                            Image(systemName: "checkmark")
                                .font(.system(size: 14))
                                .foregroundColor(.green)
                        }
                        
                        // Cancel button
                        Button(action: {
                            tempValue = value
                            isEditing = false
                        }) {
                            Image(systemName: "xmark")
                                .font(.system(size: 14))
                                .foregroundColor(.red)
                        }
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
    }
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
                Text(value)
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                
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


#Preview {
    ProfileView()
}

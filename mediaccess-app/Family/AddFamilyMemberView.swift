import SwiftUI

struct AddFamilyMemberView: View {
    let onBackTapped: () -> Void
    @State private var name = ""
    @State private var relationship = ""
    @State private var age = ""
    @State private var gender = "Male"
    
    let genders = ["Male", "Female", "Other"]
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Button(action: onBackTapped) {
                    Image(systemName: "arrow.left")
                        .font(.title2)
                        .foregroundColor(.black)
                }
                
                Spacer()
                
                Text("Add Family Member")
                    .font(.headline)
                    .fontWeight(.medium)
                
                Spacer()
                
                Color.clear
                    .frame(width: 24, height: 24)
            }
            .padding(.horizontal)
            .padding(.top, 20)
            .padding(.bottom, 20)
            
            ScrollView {
                VStack(spacing: 24) {
                    // Form fields
                    VStack(spacing: 16) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Full Name")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.black)
                            
                            TextField("Enter full name", text: $name)
                                .padding()
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(8)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Relationship")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.black)
                            
                            TextField("e.g., Son, Daughter, Wife", text: $relationship)
                                .padding()
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(8)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Age")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.black)
                            
                            TextField("Enter age", text: $age)
                                .keyboardType(.numberPad)
                                .padding()
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(8)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Gender")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.black)
                            
                            Picker("Gender", selection: $gender) {
                                ForEach(genders, id: \.self) { gender in
                                    Text(gender).tag(gender)
                                }
                            }
                            .pickerStyle(SegmentedPickerStyle())
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    Spacer(minLength: 50)
                    
                    // Add Member Button
                    Button(action: {
                        // Handle adding family member
                        onBackTapped()
                    }) {
                        Text("Add Family Member")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                }
                .padding(.top, 20)
            }
        }
        .background(Color.white)
    }
}


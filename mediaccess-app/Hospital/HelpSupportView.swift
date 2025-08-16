import SwiftUI

struct HelpSupportView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var name = ""
    @State private var email = ""
    @State private var subject = ""
    @State private var message = ""
    
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
                
                Text("Help & Support")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.black)
                
                Spacer()
                
                // Empty space to balance the header
                Image(systemName: "arrow.left")
                    .font(.title2)
                    .foregroundColor(.clear)
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Contact Us Section
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Contact Us")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.black)
                            .padding(.horizontal, 20)
                            .padding(.top, 20)
                        
                        VStack(spacing: 0) {
                            ContactRow(
                                icon: "calendar",
                                title: "Appointments",
                                subtitle: "For appointment scheduling or",
                                phone: "+1-800-555-0123"
                            )
                            
                            ContactRow(
                                icon: "pills",
                                title: "Pharmacy",
                                subtitle: "For prescription refills or pharmacy",
                                phone: "+1-800-555-0124"
                            )
                            
                            ContactRow(
                                icon: "questionmark.circle",
                                title: "General Inquiries",
                                subtitle: "For general questions or assistance",
                                phone: "+1-800-555-0125"
                            )
                        }
                        .padding(.horizontal, 20)
                    }
                    
                    // Inquiry Form Section
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Inquiry Form")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.black)
                            .padding(.horizontal, 20)
                        
                        VStack(spacing: 16) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Name")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.black)
                                
                                TextField("Your Name", text: $name)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 16)
                                    .background(Color.gray.opacity(0.1))
                                    .cornerRadius(8)
                            }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Email")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.black)
                                
                                TextField("Your Email", text: $email)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 16)
                                    .background(Color.gray.opacity(0.1))
                                    .cornerRadius(8)
                            }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Subject")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.black)
                                
                                TextField("Subject", text: $subject)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 16)
                                    .background(Color.gray.opacity(0.1))
                                    .cornerRadius(8)
                            }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Message")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.black)
                                
                                TextEditor(text: $message)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 12)
                                    .background(Color.gray.opacity(0.1))
                                    .cornerRadius(8)
                                    .frame(minHeight: 100)
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    
                    Spacer(minLength: 20)
                }
            }
            
            // Submit Button
            VStack {
                Button(action: {
                    submitInquiry()
                }) {
                    Text("Submit")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.blue)
                        .cornerRadius(12)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
            }
        }
        .background(Color.white)
    }
    
    private func submitInquiry() {
        // TODO: Implement form submission
        print("Submitting inquiry: Name: \(name), Email: \(email), Subject: \(subject), Message: \(message)")
    }
}

struct ContactRow: View {
    let icon: String
    let title: String
    let subtitle: String
    let phone: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(.black)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.black)
                
                Text(subtitle)
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Text(phone)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.black)
        }
        .padding(.vertical, 12)
    }
}


#Preview {
    HelpSupportView()
}

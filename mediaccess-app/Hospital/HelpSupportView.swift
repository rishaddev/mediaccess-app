import SwiftUI

struct HelpSupportView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var name = ""
    @State private var email = ""
    @State private var subject = ""
    @State private var message = ""
    @State private var isSubmitting = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var isSuccess = false
    
    var body: some View {
        VStack(spacing: 0) {
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
                
                Text("Help & Support")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.black)
                
                Spacer()
                
                Circle()
                    .fill(Color.clear)
                    .frame(width: 40, height: 40)
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)
            
            ScrollView {
                VStack(spacing: 0) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Contact Us")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.black)
                            .padding(.horizontal, 20)
                        
                        ContactCard(
                            icon: "calendar.badge.plus",
                            title: "Appointments",
                            subtitle: "For appointment scheduling",
                            phone: "+94 11 555 0123",
                            action: { makePhoneCall("+94 11 555 0123") }
                        )
                        
                        ContactCard(
                            icon: "pills.fill",
                            title: "Pharmacy",
                            subtitle: "For prescription refills",
                            phone: "+94 11 555 0124",
                            action: { makePhoneCall("+94 11 555 0124") }
                        )
                        
                        ContactCard(
                            icon: "questionmark.circle.fill",
                            title: "General Inquiries",
                            subtitle: "For general questions",
                            phone: "+94 11 555 0125",
                            action: { makePhoneCall("+94 11 555 0125") }
                        )
                    }
                    .padding(.top, 20)
                    
                    Spacer()
                        .frame(height: 32)
                    
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Send us a Message")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.black)
                            .padding(.horizontal, 20)
                        
                        VStack(spacing: 16) {
                            FormField(label: "Name", text: $name, placeholder: "Enter your full name")
                            FormField(label: "Email", text: $email, placeholder: "Enter your email address")
                            FormField(label: "Subject", text: $subject, placeholder: "Brief subject line")
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Message")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.black)
                                
                                ZStack(alignment: .topLeading) {
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.white)
                                        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
                                    
                                    TextEditor(text: $message)
                                        .padding(16)
                                        .background(Color.clear)
                                        .frame(minHeight: 100)
                                    
                                    if message.isEmpty {
                                        Text("Describe your inquiry or concern...")
                                            .foregroundColor(.gray)
                                            .padding(.horizontal, 20)
                                            .padding(.vertical, 20)
                                            .allowsHitTesting(false)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    
                    Spacer()
                        .frame(height: 32)
                }
            }
            
            VStack {
                Button(action: {
                    Task {
                        await submitInquiry()
                    }
                }) {
                    HStack {
                        if isSubmitting {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .scaleEffect(0.8)
                            
                            Text("Submitting...")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                        } else {
                            Text("Submit Message")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(isSubmitting ? Color.blue.opacity(0.7) : Color.blue)
                    .cornerRadius(12)
                    .shadow(color: .blue.opacity(0.3), radius: 4, x: 0, y: 2)
                }
                .disabled(name.isEmpty || email.isEmpty || subject.isEmpty || message.isEmpty || isSubmitting)
                .opacity((name.isEmpty || email.isEmpty || subject.isEmpty || message.isEmpty || isSubmitting) ? 0.6 : 1.0)
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
            }
        }
        .background(Color(.systemGroupedBackground))
        .alert("Message Status", isPresented: $showAlert) {
            Button("OK") {
                if isSuccess {
                    dismiss()
                }
            }
        } message: {
            Text(alertMessage)
        }
    }
    
    private func makePhoneCall(_ phoneNumber: String) {
        let cleanNumber = phoneNumber.replacingOccurrences(of: " ", with: "")
        
        if let phoneURL = URL(string: "tel:\(cleanNumber)") {
            if UIApplication.shared.canOpenURL(phoneURL) {
                UIApplication.shared.open(phoneURL)
            }
        }
    }
    
    private func submitInquiry() async {
        isSubmitting = true
        
        let inquiryData = [
            "name": name,
            "email": email,
            "subject": subject,
            "message": message
        ]
        
        do {
            guard let url = URL(string: "https://mediaccess.vercel.app/api/inquiry/add") else {
                throw URLError(.badURL)
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let jsonData = try JSONSerialization.data(withJSONObject: inquiryData)
            request.httpBody = jsonData
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 || httpResponse.statusCode == 201 {
                    // Success
                    await MainActor.run {
                        isSuccess = true
                        alertMessage = "Your inquiry has been submitted successfully! We'll get back to you soon."
                        showAlert = true
                        
                        // Clear form
                        name = ""
                        email = ""
                        subject = ""
                        message = ""
                    }
                } else {
                    // Server error
                    await MainActor.run {
                        isSuccess = false
                        alertMessage = "Failed to submit inquiry. Please try again later."
                        showAlert = true
                    }
                }
            }
            
        } catch {
            // Network or parsing error
            await MainActor.run {
                isSuccess = false
                if error.localizedDescription.contains("offline") || error.localizedDescription.contains("Internet") {
                    alertMessage = "Please check your internet connection and try again."
                } else {
                    alertMessage = "Something went wrong. Please try again later."
                }
                showAlert = true
            }
        }
        
        await MainActor.run {
            isSubmitting = false
        }
    }
}

struct ContactCard: View {
    let icon: String
    let title: String
    let subtitle: String
    let phone: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                // Icon container (matching AppointmentCard style)
                ZStack {
                    Circle()
                        .fill(Color.blue.opacity(0.1))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: icon)
                        .font(.system(size: 20))
                        .foregroundColor(.blue)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.black)
                    
                    Text(subtitle)
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                    
                    // Phone number with call icon
                    HStack(spacing: 4) {
                        Image(systemName: "phone.fill")
                            .font(.system(size: 10))
                        Text(phone)
                            .font(.system(size: 12, weight: .medium))
                    }
                    .foregroundColor(.blue)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(6)
                }
                
                Spacer()
                
                VStack(spacing: 2) {
                    Image(systemName: "phone.circle.fill")
                        .font(.system(size: 24))
                        .foregroundColor(.green)
                    
                    Text("Call")
                        .font(.system(size: 10, weight: .medium))
                        .foregroundColor(.green)
                }
            }
            .padding(16)
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
        }
        .buttonStyle(PlainButtonStyle())
        .padding(.horizontal, 20)
    }
}

struct FormField: View {
    let label: String
    @Binding var text: String
    let placeholder: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.black)
            
            TextField(placeholder, text: $text)
                .padding(16)
                .background(Color.white)
                .cornerRadius(12)
                .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
        }
    }
}

#Preview {
    HelpSupportView()
}

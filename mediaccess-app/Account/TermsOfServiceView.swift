import SwiftUI

struct TermsOfServiceView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            
            HStack {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "arrow.left")
                        .font(.title2)
                        .foregroundColor(.black)
                }
                
                Spacer()
                
                Text("Terms of Service")
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
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 16) {
                        
                        
                        Text("Last updated: August 16, 2025")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 30)
                    
                    VStack(alignment: .leading, spacing: 20) {
                        TermsSection(
                            title: "1. Acceptance of Terms",
                            content: "By accessing and using MediAccess, you accept and agree to be bound by the terms and provision of this agreement. If you do not agree to abide by the above, please do not use this service."
                        )
                        
                        TermsSection(
                            title: "2. Use License",
                            content: "Permission is granted to temporarily download one copy of MediAccess per device for personal, non-commercial transitory viewing only. This is the grant of a license, not a transfer of title, and under this license you may not: modify or copy the materials; use the materials for any commercial purpose or for any public display; attempt to reverse engineer any software contained in MediAccess; or remove any copyright or other proprietary notations from the materials."
                        )
                        
                        TermsSection(
                            title: "3. Medical Information Disclaimer",
                            content: "The information provided by MediAccess is for general informational purposes only. All information on the app is provided in good faith, however we make no representation or warranty of any kind, express or implied, regarding the accuracy, adequacy, validity, reliability, availability or completeness of any information on the app. Under no circumstance shall we have any liability to you for any loss or damage of any kind incurred as a result of the use of the app or reliance on any information provided on the app."
                        )
                        
                        TermsSection(
                            title: "4. Privacy Policy",
                            content: "Your privacy is important to us. Our Privacy Policy explains how we collect, use, and protect your information when you use our service. By using our service, you agree to the collection and use of information in accordance with our Privacy Policy."
                        )
                        
                        TermsSection(
                            title: "5. User Accounts",
                            content: "When you create an account with us, you must provide information that is accurate, complete, and current at all times. You are responsible for safeguarding the password and for all activities that occur under your account."
                        )
                        
                        TermsSection(
                            title: "6. Prohibited Uses",
                            content: "You may not use our service: for any unlawful purpose or to solicit others to perform unlawful acts; to violate any international, federal, provincial, or state regulations, rules, laws, or local ordinances; to infringe upon or violate our intellectual property rights or the intellectual property rights of others; to harass, abuse, insult, harm, defame, slander, disparage, intimidate, or discriminate; to submit false or misleading information."
                        )
                        
                        TermsSection(
                            title: "7. Termination",
                            content: "We may terminate or suspend your account and bar access to the service immediately, without prior notice or liability, under our sole discretion, for any reason whatsoever and without limitation, including but not limited to a breach of the Terms."
                        )
                        
                        TermsSection(
                            title: "8. Changes to Terms",
                            content: "We reserve the right, at our sole discretion, to modify or replace these Terms at any time. If a revision is material, we will provide at least 30 days notice prior to any new terms taking effect."
                        )
                        
                        TermsSection(
                            title: "9. Contact Information",
                            content: "If you have any questions about these Terms of Service, please contact us at support@mediaccess.com or through our in-app support feature."
                        )
                    }
                    .padding(.horizontal, 20)
                    
                    Spacer(minLength: 50)
                }
            }
        }
        .background(Color.white)
    }
}

struct TermsSection: View {
    let title: String
    let content: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.black)
            
            Text(content)
                .font(.system(size: 14))
                .foregroundColor(.gray)
                .lineSpacing(2)
        }
    }
}

#Preview {
    TermsOfServiceView()
}

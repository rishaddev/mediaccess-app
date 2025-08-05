import SwiftUI

struct WelcomeView: View {
    let onLoginTapped: () -> Void
    let onSignUpTapped: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            // Hospital Image
            Image("hospital_building")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxHeight: 400)
                .clipped()
                .padding(.top, 20)
            
            Spacer()
            
            // App Title and Tagline
            VStack(spacing: 16) {
                Text("MediAccess")
                    .font(.system(size: 48, weight: .bold))
                    .foregroundColor(.black)
                
                Text("Your Health, Simplified")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            // Buttons
            VStack(spacing: 16) {
                Button(action: {
                    onLoginTapped()
                }) {
                    Text("Login")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(Color.blue.opacity(0.3))
                        .cornerRadius(12)
                }
                
                Button(action: {
                    onSignUpTapped()
                }) {
                    Text("Sign Up")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(Color.clear)
                }
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 60)
        }
        .background(Color.white)
        .ignoresSafeArea()
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView(
            onLoginTapped: {},
            onSignUpTapped: {}
        )
    }
}

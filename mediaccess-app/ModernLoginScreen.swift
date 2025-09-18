import SwiftUI

struct ModernLoginScreen: View {
    @State private var phoneNumber: String = ""
    @State private var password: String = ""
    @State private var isPasswordVisible: Bool = false
    @State private var rememberMe: Bool = false
    @FocusState private var isPhoneFieldFocused: Bool
    @FocusState private var isPasswordFieldFocused: Bool
    
    let onLogin: () -> Void
    let onSignUp: () -> Void
    let onForgotPassword: () -> Void
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.95, green: 0.97, blue: 1.0),
                    Color(red: 0.98, green: 0.95, blue: 1.0)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            GeometryReader { geometry in
                Circle()
                    .fill(Color.blue.opacity(0.1))
                    .frame(width: 200, height: 200)
                    .position(x: geometry.size.width * 1.2, y: geometry.size.height * 0.1)
                
                Circle()
                    .fill(Color.purple.opacity(0.08))
                    .frame(width: 150, height: 150)
                    .position(x: geometry.size.width * -0.2, y: geometry.size.height * 0.8)
                
                RoundedRectangle(cornerRadius: 30)
                    .fill(Color.pink.opacity(0.06))
                    .frame(width: 100, height: 100)
                    .rotationEffect(.degrees(45))
                    .position(x: geometry.size.width * 0.9, y: geometry.size.height * 0.7)
            }
            
            ScrollView {
                VStack(spacing: 0) {
                    HStack {
                        Button(action: {}) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 20, weight: .medium))
                                .foregroundColor(.black)
                                .frame(width: 44, height: 44)
                                .background(Color.white)
                                .cornerRadius(22)
                                .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                        }
                        
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    
                    VStack(spacing: 16) {
                        Text("Medire")
                            .font(.system(size: 40, weight: .bold))
                            .foregroundColor(Color.blue)
                        
                        Text("Welcome back!")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.black)
                        
                        Text("Accompany you on the road to recovery health!")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                    }
                    .padding(.top, 30)
                    .padding(.bottom, 50)
                    
                    VStack(spacing: 24) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Phone")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.black)
                            
                            HStack(spacing: 12) {
                                HStack {
                                    Image(systemName: "flag.fill")
                                        .font(.system(size: 16))
                                        .foregroundColor(.red)
                                    
                                    Text("+84")
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(.black)
                                    
                                    Image(systemName: "chevron.down")
                                        .font(.system(size: 12))
                                        .foregroundColor(.gray)
                                }
                                .padding(.vertical, 12)
                                .padding(.horizontal, 16)
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(12)
                                
                                TextField("Your phone", text: $phoneNumber)
                                    .font(.system(size: 16))
                                    .foregroundColor(.black)
                                    .keyboardType(.numberPad)
                                    .focused($isPhoneFieldFocused)
                                    .padding(.vertical, 16)
                                    .padding(.horizontal, 16)
                                    .background(Color.gray.opacity(0.1))
                                    .cornerRadius(12)
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Password")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.black)
                            
                            HStack {
                                Image(systemName: "lock.fill")
                                    .font(.system(size: 16))
                                    .foregroundColor(.gray)
                                
                                if isPasswordVisible {
                                    TextField("Password", text: $password)
                                        .font(.system(size: 16))
                                        .focused($isPasswordFieldFocused)
                                } else {
                                    SecureField("Password", text: $password)
                                        .font(.system(size: 16))
                                        .focused($isPasswordFieldFocused)
                                }
                                
                                Button(action: {
                                    isPasswordVisible.toggle()
                                }) {
                                    Image(systemName: isPasswordVisible ? "eye.slash.fill" : "eye.fill")
                                        .font(.system(size: 16))
                                        .foregroundColor(.gray)
                                }
                            }
                            .padding(.vertical, 16)
                            .padding(.horizontal, 16)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(12)
                        }

                        HStack {
                            Button(action: {
                                rememberMe.toggle()
                            }) {
                                HStack(spacing: 8) {
                                    Image(systemName: rememberMe ? "checkmark.square.fill" : "square")
                                        .font(.system(size: 18))
                                        .foregroundColor(rememberMe ? .blue : .gray)
                                    
                                    Text("Remember me")
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(.black)
                                }
                            }
                            
                            Spacer()
                            
                            Button(action: onForgotPassword) {
                                Text("Forgot Password?")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.blue)
                            }
                        }
                        .padding(.top, 8)
                        
                        Button(action: onLogin) {
                            Text("Sign In")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                                .background(
                                    LinearGradient(
                                        gradient: Gradient(colors: [Color.blue, Color.purple]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .cornerRadius(28)
                                .shadow(color: .blue.opacity(0.3), radius: 10, x: 0, y: 5)
                        }
                        .padding(.top, 16)
                        
                        HStack {
                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(height: 1)
                            
                            Text("or sign in with")
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                                .padding(.horizontal, 16)
                            
                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(height: 1)
                        }
                        .padding(.top, 24)
                        
                        HStack(spacing: 20) {
                            SocialLoginButton(icon: "facebook", color: .blue)
                            SocialLoginButton(icon: "google", color: .red)
                            SocialLoginButton(icon: "apple", color: .black)
                        }
                        .padding(.top, 16)
                        
                        HStack {
                            Text("Don't have an account?")
                                .font(.system(size: 16))
                                .foregroundColor(.gray)
                            
                            Button(action: onSignUp) {
                                Text("Sign up")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.blue)
                            }
                        }
                        .padding(.top, 20)
                        .padding(.bottom, 40)
                    }
                    .padding(.horizontal, 40)
                }
            }
        }
        .onTapGesture {
            isPhoneFieldFocused = false
            isPasswordFieldFocused = false
        }
    }
}

struct SocialLoginButton: View {
    let icon: String
    let color: Color
    
    var body: some View {
        Button(action: {}) {
            Image(systemName: iconName)
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(color)
                .frame(width: 56, height: 56)
                .background(Color.white)
                .cornerRadius(28)
                .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
        }
    }
    
    private var iconName: String {
        switch icon {
        case "facebook":
            return "f.circle.fill"
        case "google":
            return "g.circle.fill"
        case "apple":
            return "apple.logo"
        default:
            return "questionmark.circle"
        }
    }
}

struct OnboardingAndLogin_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            OnboardingScreen1(onNext: {}, onSkip: {})
                .previewDisplayName("Onboarding 1")
            
            OnboardingScreen2(onNext: {}, onSkip: {})
                .previewDisplayName("Onboarding 2")
            
            ModernLoginScreen(
                onLogin: {},
                onSignUp: {},
                onForgotPassword: {}
            )
            .previewDisplayName("Login Screen")
        }
    }
}

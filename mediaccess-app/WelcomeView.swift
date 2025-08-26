import SwiftUI

struct WelcomeView: View {
    let onLoginTapped: () -> Void
    let onSignUpTapped: () -> Void
    
    @State private var animateContent = false
    @State private var animateButtons = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                LinearGradient(
                    colors: [
                        Color(red: 0.1, green: 0.4, blue: 0.8),
                        Color(red: 0.2, green: 0.6, blue: 0.9),
                        Color.white
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                FloatingElementsView()
                
                VStack(spacing: 0) {
                    Spacer(minLength: 60)
                    
                    VStack(spacing: 24) {
                        ZStack {
                            Circle()
                                .fill(Color.white.opacity(0.1))
                                .frame(width: 120, height: 120)
                                .blur(radius: 10)
                            
                            Circle()
                                .fill(Color.white.opacity(0.2))
                                .frame(width: 100, height: 100)
                            
                            Image(systemName: "cross.case.fill")
                                .font(.system(size: 40, weight: .medium))
                                .foregroundColor(.white)
                        }
                        .scaleEffect(animateContent ? 1.0 : 0.8)
                        .opacity(animateContent ? 1.0 : 0.0)
                        
                        VStack(spacing: 12) {
                            Text("MediAccess")
                                .font(.system(size: 42, weight: .bold, design: .rounded))
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [.white, Color.white.opacity(0.4)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 2)
                            
                            Text("Your Health, Simplified")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(.white.opacity(0.9))
                                .multilineTextAlignment(.center)
                        }
                        .opacity(animateContent ? 1.0 : 0.0)
                        .offset(y: animateContent ? 0 : 20)
                    }
                    
                    Spacer()
                    
                    HStack(spacing: 30) {
                        FeatureItem(icon: "calendar.badge.plus", title: "Easy Booking")
                        FeatureItem(icon: "doc.text", title: "Digital Records")
                        FeatureItem(icon: "stethoscope", title: "Expert Care")
                    }
                    .opacity(animateContent ? 1.0 : 0.0)
                    .offset(y: animateContent ? 0 : 30)
                    
                    Spacer(minLength: 40)
                    
                    VStack(spacing: 16) {
                        Button(action: {
                            onLoginTapped()
                        }) {
                            HStack {
                                Text("Login")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(.white)
                                
                                Spacer()
                                
                                Image(systemName: "arrow.right")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.white)
                            }
                            .padding(.horizontal)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(
                                LinearGradient(
                                    colors: [
                                        Color(red: 0.2, green: 0.6, blue: 0.9),
                                        Color(red: 0.1, green: 0.4, blue: 0.8)
                                    ],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(16)
                            .shadow(color: Color.blue.opacity(0.3), radius: 8, x: 0, y: 4)
                        }
                        .scaleEffect(animateButtons ? 1.0 : 0.9)
                        .opacity(animateButtons ? 1.0 : 0.0)
                        
                        Button(action: {
                            onSignUpTapped()
                        }) {
                            HStack {
                                Text("Create Account")
                                    .font(.system(size: 18, weight: .medium))
                                    .foregroundColor(Color(red: 0.1, green: 0.4, blue: 0.8))
                                
                                Spacer()
                                
                                Image(systemName: "person.badge.plus")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(Color(red: 0.1, green: 0.4, blue: 0.8))
                            }
                            .padding(.horizontal)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(Color.white)
                            .cornerRadius(16)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color.white.opacity(0.3), lineWidth: 1)
                            )
                            .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
                        }
                        .scaleEffect(animateButtons ? 1.0 : 0.9)
                        .opacity(animateButtons ? 1.0 : 0.0)
                    }
                    .padding(.horizontal, 32)
                    .padding(.bottom, max(geometry.safeAreaInsets.bottom + 20, 40))
                }
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.8)) {
                animateContent = true
            }
            
            withAnimation(.easeOut(duration: 0.6).delay(0.3)) {
                animateButtons = true
            }
        }
    }
}

struct FeatureItem: View {
    let icon: String
    let title: String
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(Color.white.opacity(0.2))
                    .frame(width: 50, height: 50)
                
                Image(systemName: icon)
                    .font(.system(size: 22, weight: .medium))
                    .foregroundColor(.white)
            }
            
            Text(title)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.white.opacity(0.9))
                .multilineTextAlignment(.center)
        }
    }
}

struct FloatingElementsView: View {
    @State private var animateElements = false
    
    var body: some View {
        ZStack {
            ForEach(0..<6, id: \.self) { index in
                FloatingElement(
                    icon: ["pills", "cross.case", "heart.fill", "leaf.fill", "drop.fill", "bandage"][index],
                    delay: Double(index) * 0.5
                )
            }
        }
        .onAppear {
            animateElements = true
        }
    }
}

struct FloatingElement: View {
    let icon: String
    let delay: Double
    @State private var animate = false
    
    var body: some View {
        Image(systemName: icon)
            .font(.system(size: 20, weight: .light))
            .foregroundColor(.white.opacity(0.1))
            .offset(
                x: animate ? CGFloat.random(in: -100...100) : 0,
                y: animate ? CGFloat.random(in: -200...200) : 0
            )
            .scaleEffect(animate ? CGFloat.random(in: 0.5...1.5) : 1.0)
            .opacity(animate ? 0.1 : 0.05)
            .animation(
                .easeInOut(duration: Double.random(in: 8...12))
                .repeatForever(autoreverses: true)
                .delay(delay),
                value: animate
            )
            .onAppear {
                animate = true
            }
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

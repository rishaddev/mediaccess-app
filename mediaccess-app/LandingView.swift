import SwiftUI

struct LandingView: View {
    let onNext: () -> Void
    let onSkip: () -> Void
    
    @State private var animateContent = false
    @State private var animateButtons = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background gradient
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
                
                // Floating background elements
                FloatingElementsView()
                
                VStack(spacing: 0) {
                    Spacer(minLength: 60)
                    
                    // App icon and title section
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
                            Text("Welcome to")
                                .font(.system(size: 20, weight: .medium))
                                .foregroundColor(.white.opacity(0.8))
                            
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
                    
                    // Key features overview
                    VStack(spacing: 30) {
                        Text("Everything you need for better health")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                        
                        HStack(spacing: 30) {
                            FeatureItem(icon: "calendar.badge.plus", title: "Easy Booking")
                            FeatureItem(icon: "doc.text", title: "Digital Records")
                            FeatureItem(icon: "stethoscope", title: "Expert Care")
                        }
                    }
                    .opacity(animateContent ? 1.0 : 0.0)
                    .offset(y: animateContent ? 0 : 30)
                    
                    Spacer(minLength: 40)
                    
                    // Navigation buttons
                    VStack(spacing: 16) {
                        Button(action: {
                            onNext()
                        }) {
                            HStack {
                                Text("Get Started")
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
                            onSkip()
                        }) {
                            HStack {
                                Text("Skip Tutorial")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.white.opacity(0.8))
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.white.opacity(0.6))
                            }
                            .padding(.horizontal)
                            .frame(maxWidth: .infinity)
                            .frame(height: 48)
                            .background(Color.white.opacity(0.1))
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
                            )
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

struct LandingView_Previews: PreviewProvider {
    static var previews: some View {
        LandingView(
            onNext: {},
            onSkip: {}
        )
    }
}

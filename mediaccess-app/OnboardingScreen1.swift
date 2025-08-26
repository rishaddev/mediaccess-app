import SwiftUI

struct OnboardingScreen1: View {
    let onNext: () -> Void
    
    var body: some View {
        ZStack {
            
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.4, green: 0.6, blue: 1.0),
                    Color(red: 0.6, green: 0.4, blue: 0.9)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            GeometryReader { geometry in
                Circle()
                    .fill(Color.white.opacity(0.1))
                    .frame(width: 120, height: 120)
                    .position(x: geometry.size.width * 0.8, y: geometry.size.height * 0.2)
                
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white.opacity(0.08))
                    .frame(width: 80, height: 80)
                    .rotationEffect(.degrees(45))
                    .position(x: geometry.size.width * 0.15, y: geometry.size.height * 0.3)
                
                Circle()
                    .fill(Color.white.opacity(0.06))
                    .frame(width: 60, height: 60)
                    .position(x: geometry.size.width * 0.9, y: geometry.size.height * 0.7)
            }
            
            VStack(spacing: 40) {
                Spacer()
                
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.2))
                        .frame(width: 280, height: 280)
                    
                    VStack(spacing: 20) {
                        Image(systemName: "stethoscope")
                            .font(.system(size: 80, weight: .light))
                            .foregroundColor(.white)
                        
                        Image(systemName: "heart.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.pink)
                            .offset(x: 30, y: -10)
                    }
                }
                
                
                VStack(spacing: 24) {
                    Text("Expert Medical Care")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    
                    Text("Connect with certified healthcare professionals anytime, anywhere. Get the care you deserve.")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.white.opacity(0.9))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                }
                
                Spacer()
                
                Button(action: onNext) {
                    HStack {
                        Text("Next")
                            .font(.system(size: 18, weight: .semibold))
                        
                        Image(systemName: "arrow.right")
                            .font(.system(size: 16, weight: .semibold))
                    }
                    .foregroundColor(.blue)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(Color.white)
                    .cornerRadius(28)
                    .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 60)
            }
        }
    }
}

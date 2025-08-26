import SwiftUI

struct OnboardingScreen2: View {
    let onNext: () -> Void
    
    var body: some View {
        ZStack {
            
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.9, green: 0.4, blue: 0.6),
                    Color(red: 0.6, green: 0.8, blue: 0.9)
                ]),
                startPoint: .topTrailing,
                endPoint: .bottomLeading
            )
            .ignoresSafeArea()
            
            GeometryReader { geometry in
                Image(systemName: "pills.fill")
                    .font(.system(size: 30))
                    .foregroundColor(.white.opacity(0.3))
                    .position(x: geometry.size.width * 0.8, y: geometry.size.height * 0.15)
                
                Image(systemName: "cross.fill")
                    .font(.system(size: 25))
                    .foregroundColor(.white.opacity(0.25))
                    .position(x: geometry.size.width * 0.2, y: geometry.size.height * 0.25)
                
                Image(systemName: "thermometer")
                    .font(.system(size: 35))
                    .foregroundColor(.white.opacity(0.2))
                    .position(x: geometry.size.width * 0.9, y: geometry.size.height * 0.6)
                
                Circle()
                    .fill(Color.white.opacity(0.1))
                    .frame(width: 100, height: 100)
                    .position(x: geometry.size.width * 0.1, y: geometry.size.height * 0.7)
            }
            
            VStack(spacing: 40) {
                Spacer()
                
                ZStack {
                    RoundedRectangle(cornerRadius: 40)
                        .fill(Color.white.opacity(0.2))
                        .frame(width: 300, height: 280)
                    
                    VStack(spacing: 30) {
                        HStack(spacing: 20) {
                            VStack {
                                Image(systemName: "calendar")
                                    .font(.system(size: 35))
                                    .foregroundColor(.white)
                                
                                Text("Schedule")
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(.white)
                            }
                            
                            VStack {
                                Image(systemName: "video.fill")
                                    .font(.system(size: 35))
                                    .foregroundColor(.white)
                                
                                Text("Consult")
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(.white)
                            }
                        }
                        
                        HStack(spacing: 20) {
                            VStack {
                                Image(systemName: "doc.text.fill")
                                    .font(.system(size: 35))
                                    .foregroundColor(.white)
                                
                                Text("Reports")
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(.white)
                            }
                            
                            VStack {
                                Image(systemName: "bell.fill")
                                    .font(.system(size: 35))
                                    .foregroundColor(.white)
                                
                                Text("Reminders")
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(.white)
                            }
                        }
                    }
                }
                
                
                VStack(spacing: 24) {
                    Text("Complete Health Management")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    
                    Text("Schedule appointments, track medications, access reports, and never miss important health reminders.")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.white.opacity(0.9))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                }
                
                Spacer()
                
                Button(action: onNext) {
                    HStack {
                        Text("Get Started")
                            .font(.system(size: 18, weight: .semibold))
                        
                        Image(systemName: "arrow.right.circle.fill")
                            .font(.system(size: 18))
                    }
                    .foregroundColor(.pink)
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

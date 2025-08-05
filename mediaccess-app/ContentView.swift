import SwiftUI

enum AppState {
    case welcome
    case login
    case signUp
    case dashboard
}

struct ContentView: View {
    @State private var currentState: AppState = .welcome
    @State private var selectedTab: TabSelection = .home
    
    var body: some View {
        NavigationView {
            Group {
                switch currentState {
                case .welcome:
                    LandingPageView(
                        onLoginTapped: {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                currentState = .login
                            }
                        },
                        onSignUpTapped: {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                currentState = .signUp
                            }
                        }
                    )
                    
                case .login:
                    LoginView(
                        onBackTapped: {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                currentState = .welcome
                            }
                        },
                        onLoginSuccess: {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                currentState = .dashboard
                            }
                        },
                        onSignUpTapped: {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                currentState = .signUp
                            }
                        }
                    )
                    
                case .signUp:
                    SignUpView(
                        onBackTapped: {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                currentState = .welcome
                            }
                        },
                        onSignUpSuccess: {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                currentState = .dashboard
                            }
                        },
                        onLoginTapped: {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                currentState = .login
                            }
                        }
                    )
                    
                case .dashboard:
                    VStack(spacing: 0) {
                        // Main Content based on selected tab
                        Group {
                            switch selectedTab {
                            case .home:
                                DashboardView()
                            case .appointments:
                                AppointmentsView()
                            case .pharmacy:
                                PharmacyView()
                            case .family:
                                FamilyView()
                            }
                        }
                        
                        // Custom Navigation Bar
                        NavigationBar(selectedTab: $selectedTab)
                    }
                }
            }
        }
        .navigationBarHidden(true)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

import SwiftUI

enum AppState {
    case welcome
    case login
    case signUp
    case dashboard
}

enum DashboardPage {
    case main
    case bookAppointment
    case bookHomeVisit
    case appointmentDetails(AppointmentDetail)
}

struct ContentView: View {
    @State private var currentState: AppState = .welcome
    @State private var selectedTab: TabSelection = .home
    @State private var dashboardPage: DashboardPage = .main
    
    var body: some View {
        NavigationView {
            Group {
                switch currentState {
                case .welcome:
                    WelcomeView(
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
                        Group {
                            switch dashboardPage {
                            case .main:
                                switch selectedTab {
                                case .home:
                                    DashboardView(onLogout: handleLogout)
                                    
                                case .appointments:
                                    AppointmentsView(
                                        onBookAppointment: {
                                            withAnimation {
                                                dashboardPage = .bookAppointment
                                            }
                                        },
                                        onBookHomeVisit: {
                                            withAnimation {
                                                dashboardPage = .bookHomeVisit
                                            }
                                        }
                                    )
                                case .pharmacy:
                                    PharmacyView()
                                case .family:
                                    FamilyView()
                                }
                                
                                
                            case .bookAppointment:
                                BookAppointmentView(onBackTapped: {
                                    withAnimation {
                                        dashboardPage = .main
                                    }
                                })
                            case .bookHomeVisit:
                                BookHomeVisitView(onBackTapped: {
                                    withAnimation {
                                        dashboardPage = .main
                                    }
                                })
                            case .appointmentDetails(let appointment):
                                AppointmentDetailsView(
                                    appointment: appointment,
                                    onBackTapped: {
                                        withAnimation {
                                            dashboardPage = .main
                                        }
                                    }
                                )
                            }
                        }

                        // Show navigation bar only in main dashboard view
                        if case .main = dashboardPage {
                            NavigationBar(selectedTab: $selectedTab)
                        }
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            checkLoginState()
        }
    }
    
    // MARK: - Helper Functions
    
    private func handleLogout() {
        withAnimation(.easeInOut(duration: 0.3)) {
            currentState = .welcome
            selectedTab = .home
            dashboardPage = .main
        }
    }
    
    private func checkLoginState() {
        // Check if user is already logged in when app starts
        if UserDefaults.standard.bool(forKey: "isLoggedIn") {
            currentState = .dashboard
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

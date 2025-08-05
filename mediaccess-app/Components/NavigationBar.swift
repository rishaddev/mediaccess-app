import SwiftUI

enum TabSelection: String, CaseIterable {
    case home = "Home"
    case appointments = "Appointments"
    case pharmacy = "Pharmacy"
    case family = "Family"
    
    var iconName: String {
        switch self {
        case .home:
            return "house"
        case .appointments:
            return "calendar"
        case .pharmacy:
            return "pills"
        case .family:
            return "person.2"
        }
    }
    
    var selectedIconName: String {
        switch self {
        case .home:
            return "house.fill"
        case .appointments:
            return "calendar"
        case .pharmacy:
            return "pills.fill"
        case .family:
            return "person.2.fill"
        }
    }
}

struct NavigationBar: View {
    @Binding var selectedTab: TabSelection
    
    var body: some View {
        HStack {
            ForEach(TabSelection.allCases, id: \.self) { tab in
                Button(action: {
                    selectedTab = tab
                }) {
                    VStack(spacing: 4) {
                        Image(systemName: selectedTab == tab ? tab.selectedIconName : tab.iconName)
                            .font(.system(size: 20))
                            .foregroundColor(selectedTab == tab ? .blue : .gray)
                        
                        Text(tab.rawValue)
                            .font(.system(size: 12))
                            .foregroundColor(selectedTab == tab ? .blue : .gray)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(Color.white)
        .shadow(color: Color.black.opacity(0.1), radius: 1, x: 0, y: -1)
    }
}

struct NavigationBar_Previews: PreviewProvider {
    static var previews: some View {
        NavigationBar(selectedTab: .constant(.home))
    }
}

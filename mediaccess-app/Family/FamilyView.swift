import SwiftUI

struct FamilyView: View {
    var body: some View {
        VStack {
            Text("Family")
                .font(.largeTitle)
                .padding()
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
    }
}

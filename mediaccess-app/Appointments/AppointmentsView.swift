import SwiftUI

struct AppointmentsView: View {
    var body: some View {
        VStack {
            Text("Appointments")
                .font(.largeTitle)
                .padding()
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
    }
}

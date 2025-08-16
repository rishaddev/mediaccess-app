import SwiftUI

struct AppointmentDetailView: View {
    let appointment: PastAppointment
    let onBackTapped: () -> Void
    
    var body: some View {
        VStack {
            Text("Appointment Details")
            Text(appointment.title)
            Button("Back", action: onBackTapped)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
    }
}

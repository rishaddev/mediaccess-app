import SwiftUI

struct AppointmentCard: View {
    let title: String
    let doctor: String
    let time: String
    let onTapped: (() -> Void)?
    
    init(title: String, doctor: String, time: String, onTapped: (() -> Void)? = nil) {
        self.title = title
        self.doctor = doctor
        self.time = time
        self.onTapped = onTapped
    }
    
    var body: some View {
        Button(action: {
            onTapped?()
        }) {
            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.black)
                    
                    Text(doctor)
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                if !time.isEmpty {
                    Text(time)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.blue)
                }
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }
            .padding(16)
            .background(Color.gray.opacity(0.05))
            .cornerRadius(12)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

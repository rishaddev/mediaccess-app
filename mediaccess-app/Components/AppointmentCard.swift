import SwiftUI

struct AppointmentCard: View {
    let title: String
    let doctor: String
    let time: String
    
    var body: some View {
        HStack(spacing: 12) {
            // Calendar Icon
            VStack {
                Image(systemName: "calendar")
                    .font(.title2)
                    .foregroundColor(.blue)
                Text("12")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.blue)
            }
            .frame(width: 50, height: 50)
            .background(Color.blue.opacity(0.1))
            .cornerRadius(8)
            
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
                    .foregroundColor(.black)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color.gray.opacity(0.05))
        .cornerRadius(12)
    }
}

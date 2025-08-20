import SwiftUI

struct AppointmentCard: View {
    let speciality: String
    let doctorName: String
    let appointmentDate: String
    let appointmentTime: String
    let onTapped: (() -> Void)?
    
    init(speciality: String, doctorName: String,appointmentDate: String, appointmentTime: String, onTapped: (() -> Void)? = nil) {
        self.speciality = speciality
        self.doctorName = doctorName
        self.appointmentDate = appointmentDate
        self.appointmentTime = appointmentTime
        self.onTapped = onTapped
    }
    
    var body: some View {
        Button(action: {
            onTapped?()
        }) {
            HStack(spacing: 12) {
                // Doctor Avatar
                ZStack {
                    Circle()
                        .fill(Color.blue.opacity(0.1))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: "stethoscope")
                        .font(.system(size: 20))
                        .foregroundColor(.blue)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(speciality)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.black)
                    
                    Text(doctorName)
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                    
                    if !appointmentDate.isEmpty {
                        HStack(spacing: 8) {
                            HStack(spacing: 4) {
                                Image(systemName: "calendar")
                                    .font(.system(size: 10))
                                Text(appointmentDate)
                                    .font(.system(size: 12))
                            }
                            
                            HStack(spacing: 4) {
                                Image(systemName: "clock")
                                    .font(.system(size: 10))
                                Text(appointmentTime)
                                    .font(.system(size: 12))
                            }
                        }
                        .foregroundColor(.blue)
                        .padding(8)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(6)
                    }
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }
            .padding(16)
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

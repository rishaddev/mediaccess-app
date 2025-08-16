import SwiftUI

struct LabReportDetailView: View {
    let report: LabReport
    let onBackTapped: () -> Void
    
    var body: some View {
        VStack {
            Text("Lab Report Details")
            Text(report.title)
            Button("Back", action: onBackTapped)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
    }
}

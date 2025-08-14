import SwiftUI

struct OrderHistoryView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Order History")
                    .font(.title)
                    .padding()
                
                Text("Order history will be displayed here")
                    .foregroundColor(.gray)
                
                Spacer()
            }
            .navigationTitle("Order History")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                trailing: Button("Close") {
                    dismiss()
                }
            )
        }
    }
}

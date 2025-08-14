import SwiftUI

struct PlaceNewOrderView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var contactNumber = ""
    @State private var notes = ""
    @State private var showingImagePicker = false
    @State private var selectedImage: UIImage?
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "arrow.left")
                        .font(.title2)
                        .foregroundColor(.black)
                }
                
                Spacer()
                
                Text("Upload Prescription")
                    .font(.headline)
                    .fontWeight(.medium)
                
                Spacer()
                
                // Empty space to center the title
                Color.clear
                    .frame(width: 24, height: 24)
            }
            .padding(.horizontal)
            .padding(.top, 50)
            .padding(.bottom, 20)
            
            ScrollView {
                VStack(spacing: 20) {
                    
                    // Upload Prescription Section
                    VStack(spacing: 15) {
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.gray.opacity(0.3), style: StrokeStyle(lineWidth: 2, dash: [8]))
                            .frame(height: 200)
                            .overlay(
                                VStack(spacing: 15) {
                                    if let selectedImage = selectedImage {
                                        Image(uiImage: selectedImage)
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(maxHeight: 150)
                                    } else {
                                        VStack(spacing: 10) {
                                            Text("Upload Prescription")
                                                .font(.headline)
                                                .fontWeight(.medium)
                                            
                                            Text("Take a photo or upload a file of your prescription.")
                                                .font(.subheadline)
                                                .foregroundColor(.gray)
                                                .multilineTextAlignment(.center)
                                                .padding(.horizontal)
                                        }
                                    }
                                    
                                    Button(action: {
                                        showingImagePicker = true
                                    }) {
                                        Text("Upload")
                                            .font(.system(size: 16, weight: .medium))
                                            .foregroundColor(.black)
                                            .padding(.horizontal, 30)
                                            .padding(.vertical, 12)
                                            .background(Color.gray.opacity(0.1))
                                            .cornerRadius(8)
                                    }
                                }
                            )
                            .padding(.horizontal)
                    }
                    
                    // Contact Number Section
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Contact Number")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.black)
                            Spacer()
                        }
                        
                        TextField("Enter Contact Number", text: $contactNumber)
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                            .keyboardType(.phonePad)
                    }
                    .padding(.horizontal)
                    
                    // Notes Section
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Notes")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.black)
                            Spacer()
                        }
                        
                        TextEditor(text: $notes)
                            .padding(8)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                            .frame(minHeight: 100)
                    }
                    .padding(.horizontal)
                    
                    Spacer(minLength: 30)
                    
                    // Place Order Button
                    Button(action: {
                        // Handle place order action
                        dismiss()
                    }) {
                        Text("Place Order")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                }
            }
        }
        .background(Color.white)
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(selectedImage: $selectedImage)
        }
    }
}

// Simple ImagePicker wrapper for UIImagePickerController
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Environment(\.dismiss) private var dismiss
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .photoLibrary
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image
            }
            parent.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.dismiss()
        }
    }
}

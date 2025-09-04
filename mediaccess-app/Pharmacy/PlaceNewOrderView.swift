import SwiftUI
import Foundation
import UIKit
import VisionKit
import Vision

struct PharmacyOrderRequest: Codable {
    let patientId: String
    let patientName: String
    let contactNumber: String
    let address: String
    let notes: String?
    let prescriptionImageData: String?
    let orderDate: String
    let status: String
}

struct PlaceNewOrderView: View {
    @Environment(\.dismiss) private var dismiss
    let onOrderPlaced: ((PharmacyOrder) -> Void)?
    
    @State private var customerName = ""
    @State private var contactNumber = ""
    @State private var address = ""
    @State private var notes = ""
    @State private var selectedImage: UIImage?
    @State private var showingImagePicker = false
    @State private var showingDocumentScanner = false
    @State private var isPlacingOrder = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var showingImageSourceAlert = false
    @State private var isProcessingOCR = false
    
    @State private var imagePickerSource: UIImagePickerController.SourceType = .photoLibrary
    
    init(onOrderPlaced: ((PharmacyOrder) -> Void)? = nil) {
        self.onOrderPlaced = onOrderPlaced
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                
                ScrollView {
                    VStack(spacing: 24) {
                        headerSection
                        
                        uploadSection
                        
                        customerDetailsSection
                        
                        notesSection
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
            .background(Color(.systemGroupedBackground))
            .onAppear {
                loadUserDefaults()
            }
        }
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(selectedImage: $selectedImage, sourceType: imagePickerSource) { image in
                if let image = image {
                    processImageWithOCR(image)
                }
            }
        }
        .sheet(isPresented: $showingDocumentScanner) {
            if #available(iOS 13.0, *) {
                DocumentScannerView { images in
                    if let firstImage = images.first {
                        selectedImage = firstImage
                        processImageWithOCR(firstImage)
                    }
                }
            }
        }
        .confirmationDialog("Select Image Source", isPresented: $showingImageSourceAlert) {
            if #available(iOS 13.0, *), VNDocumentCameraViewController.isSupported {
                Button("Scan Document") {
                    showingDocumentScanner = true
                }
            }
            
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                Button("Camera") {
                    imagePickerSource = .camera
                    showingImagePicker = true
                }
            }
            
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                Button("Photo Library") {
                    imagePickerSource = .photoLibrary
                    showingImagePicker = true
                }
            }
            
            Button("Cancel", role: .cancel) { }
        }
        .alert("Order Status", isPresented: $showAlert) {
            Button("OK") {
                if alertMessage.contains("successfully") {
                    dismiss()
                }
            }
        } message: {
            Text(alertMessage)
        }
        .overlay(alignment: .bottom) {
            placeOrderButton
        }
    }
    
    private var headerSection: some View {
        HStack {
            Button("Cancel") {
                dismiss()
            }
            .foregroundColor(.blue)
            
            Spacer()
            
            Text("Place New Order")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.black)
            
            Spacer()
            
            Color.clear
                .frame(width: 50)
        }
    }
    
    private var uploadSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Upload Prescription")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.black)
            
            Button(action: {
                showingImageSourceAlert = true
            }) {
                VStack(spacing: 16) {
                    if let selectedImage = selectedImage {
                        Image(uiImage: selectedImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxHeight: 200)
                            .cornerRadius(12)
                    } else {
                        VStack(spacing: 12) {
                            Image(systemName: "doc.text.viewfinder")
                                .font(.system(size: 50))
                                .foregroundColor(.blue)
                            
                            Text("Scan Prescription")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.black)
                            
                            Text("Scan document, take photo, or choose from gallery")
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                        }
                    }
                    
                    if isProcessingOCR {
                        HStack {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                                .scaleEffect(0.8)
                            
                            Text("Processing text...")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.blue)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(8)
                    } else {
                        Text(selectedImage == nil ? "Choose Option" : "Change Image")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.blue)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 8)
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(8)
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(minHeight: 200)
                .background(Color.white)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray.opacity(0.3), style: StrokeStyle(lineWidth: 2, dash: [8]))
                )
            }
            .buttonStyle(PlainButtonStyle())
            .disabled(isProcessingOCR)
        }
    }
    
    private var customerDetailsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Customer Details")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.black)
            
            VStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Full Name")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.gray)
                    
                    TextField("Enter your full name", text: $customerName)
                        .font(.system(size: 16))
                        .padding(12)
                        .background(Color.white)
                        .cornerRadius(12)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Contact Number")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.gray)
                    
                    TextField("Enter contact number", text: $contactNumber)
                        .font(.system(size: 16))
                        .keyboardType(.phonePad)
                        .padding(12)
                        .background(Color.white)
                        .cornerRadius(12)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Address")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.gray)
                    
                    TextField("Enter delivery address", text: $address, axis: .vertical)
                        .font(.system(size: 16))
                        .padding(12)
                        .background(Color.white)
                        .cornerRadius(12)
                        .lineLimit(2...4)
                }
            }
        }
    }
    
    private var notesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Prescription Details")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.black)
                
                Spacer()
                
                if !notes.isEmpty {
                    Button("Clear") {
                        notes = ""
                    }
                    .font(.system(size: 14))
                    .foregroundColor(.red)
                }
            }
            
            TextField("Scanned prescription text will appear here...\n\nYou can also add any special requirements or notes manually.", text: $notes, axis: .vertical)
                .font(.system(size: 16))
                .padding(12)
                .background(Color.white)
                .cornerRadius(12)
                .lineLimit(5...10)
        }
    }
    
    private var placeOrderButton: some View {
        Button(action: {
            placeOrder()
        }) {
            HStack {
                if isPlacingOrder {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(0.8)
                }
                
                Text(isPlacingOrder ? "Placing Order..." : "Place Order")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity)
            .padding(16)
            .background(canPlaceOrder ? Color.blue : Color.gray)
            .cornerRadius(12)
        }
        .disabled(!canPlaceOrder || isPlacingOrder || isProcessingOCR)
        .padding(.horizontal, 20)
        .padding(.bottom, 30)
        .background(Color(.systemGroupedBackground))
    }
    
    private var canPlaceOrder: Bool {
        !customerName.isEmpty && !contactNumber.isEmpty && !address.isEmpty && selectedImage != nil
    }
    
    private var patientId: String {
        return UserDefaults.standard.string(forKey: "id") ?? UUID().uuidString
    }
    
    // MARK: - OCR Processing
    private func processImageWithOCR(_ image: UIImage) {
        guard let cgImage = image.cgImage else { return }
        
        isProcessingOCR = true
        
        let request = VNRecognizeTextRequest { request, error in
            DispatchQueue.main.async {
                self.isProcessingOCR = false
                
                if let error = error {
                    print("OCR Error: \(error.localizedDescription)")
                    return
                }
                
                guard let observations = request.results as? [VNRecognizedTextObservation] else {
                    return
                }
                
                let recognizedText = observations.compactMap { observation in
                    observation.topCandidates(1).first?.string
                }.joined(separator: "\n")
                
                if !recognizedText.isEmpty {
                    // Clean up and format the extracted text
                    let cleanedText = cleanupExtractedText(recognizedText)
                    self.notes = cleanedText
                }
            }
        }
        
        // Configure for better accuracy with prescriptions
        request.recognitionLevel = .accurate
        request.usesLanguageCorrection = true
        
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try handler.perform([request])
            } catch {
                DispatchQueue.main.async {
                    self.isProcessingOCR = false
                    print("Failed to perform OCR: \(error.localizedDescription)")
                }
            }
        }
    }
    
    private func cleanupExtractedText(_ text: String) -> String {
        // Basic cleanup for prescription text
        var cleanedText = text
        
        // Remove excessive whitespace and newlines
        cleanedText = cleanedText.replacingOccurrences(of: "\n\n+", with: "\n", options: .regularExpression)
        cleanedText = cleanedText.replacingOccurrences(of: "[ \t]+", with: " ", options: .regularExpression)
        cleanedText = cleanedText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Add some structure if it looks like a prescription
        if cleanedText.contains("Dr.") || cleanedText.contains("MD") || cleanedText.contains("Rx") {
            cleanedText = "📋 Prescription Details:\n\n" + cleanedText
        }
        
        return cleanedText
    }
    
    private func loadUserDefaults() {
        customerName = UserDefaults.standard.string(forKey: "name") ?? ""
        contactNumber = UserDefaults.standard.string(forKey: "contactNumber") ?? ""
        address = UserDefaults.standard.string(forKey: "address") ?? ""
    }
    
    private func saveToUserDefaults() {
        UserDefaults.standard.set(customerName, forKey: "name")
        UserDefaults.standard.set(contactNumber, forKey: "contactNumber")
        UserDefaults.standard.set(address, forKey: "address")
    }
    
    private func generateOrderId() -> String {
        return "PH\(String(format: "%04d", Int.random(in: 1000...9999)))"
    }
    
    private func formatCurrentDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: Date())
    }
    
    private func placeOrder() {
        guard canPlaceOrder else { return }
        
        isPlacingOrder = true
        saveToUserDefaults()
        
        guard let url = URL(string: "https://mediaccess.vercel.app/api/pharmacy-order/add") else {
            isPlacingOrder = false
            alertMessage = "Invalid API endpoint"
            showAlert = true
            return
        }
        
        var prescriptionImageData: String?
        if let image = selectedImage {
            if let compressedData = image.resized(toMaxWidth: 800, compressionQuality: 0.5) {
                if compressedData.count < 900_000 {
                    prescriptionImageData = compressedData.base64EncodedString()
                } else if let smallerData = image.resized(toMaxWidth: 600, compressionQuality: 0.4) {
                    prescriptionImageData = smallerData.base64EncodedString()
                }
            }
        }
        
        let orderRequest = PharmacyOrderRequest(
            patientId: patientId,
            patientName: customerName.trimmingCharacters(in: .whitespacesAndNewlines),
            contactNumber: contactNumber.trimmingCharacters(in: .whitespacesAndNewlines),
            address: address.trimmingCharacters(in: .whitespacesAndNewlines),
            notes: notes.isEmpty ? nil : notes.trimmingCharacters(in: .whitespacesAndNewlines),
            prescriptionImageData: prescriptionImageData,
            orderDate: formatCurrentDate(),
            status: "Processing"
        )
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData = try JSONEncoder().encode(orderRequest)
            request.httpBody = jsonData
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                OperationQueue.main.addOperation {
                    self.isPlacingOrder = false
                    
                    if let error = error {
                        self.alertMessage = "Network error: \(error.localizedDescription)"
                        self.showAlert = true
                        return
                    }
                    
                    if let httpResponse = response as? HTTPURLResponse {
                        if httpResponse.statusCode == 200 || httpResponse.statusCode == 201 {
                            let newOrder = PharmacyOrder(
                                id: self.generateOrderId(),
                                patientId: self.patientId,
                                patientName: self.customerName,
                                contactNumber: self.contactNumber,
                                address: self.address,
                                notes: self.notes,
                                prescriptionImageData: prescriptionImageData ?? "",
                                orderDate: self.formatCurrentDate(),
                                status: "Processing",
                                orderItems: [],
                                price: "0.00",
                                createdDate: "",
                                createdTime: ""
                            )
                            
                            self.onOrderPlaced?(newOrder)
                            self.alertMessage = "Order placed successfully!\n\nOrder ID: \(newOrder.id)\nStatus: Processing\n\nYou will be contacted by the pharmacy team soon."
                        } else {
                            if let data = data,
                               let errorMessage = String(data: data, encoding: .utf8) {
                                self.alertMessage = "Order failed: \(errorMessage)"
                            } else {
                                self.alertMessage = "Order failed with status code: \(httpResponse.statusCode)"
                            }
                        }
                    } else {
                        self.alertMessage = "Invalid response from server"
                    }
                    self.showAlert = true
                }
            }.resume()
            
        } catch {
            isPlacingOrder = false
            alertMessage = "Failed to prepare order data: \(error.localizedDescription)"
            showAlert = true
        }
    }
}

// MARK: - Document Scanner
@available(iOS 13.0, *)
struct DocumentScannerView: UIViewControllerRepresentable {
    let onScanComplete: ([UIImage]) -> Void
    @Environment(\.dismiss) private var dismiss
    
    func makeUIViewController(context: Context) -> VNDocumentCameraViewController {
        let scanner = VNDocumentCameraViewController()
        scanner.delegate = context.coordinator
        return scanner
    }
    
    func updateUIViewController(_ uiViewController: VNDocumentCameraViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, VNDocumentCameraViewControllerDelegate {
        let parent: DocumentScannerView
        
        init(_ parent: DocumentScannerView) {
            self.parent = parent
        }
        
        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
            var images: [UIImage] = []
            
            for pageIndex in 0..<scan.pageCount {
                let image = scan.imageOfPage(at: pageIndex)
                images.append(image)
            }
            
            parent.onScanComplete(images)
            parent.dismiss()
        }
        
        func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
            parent.dismiss()
        }
        
        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
            print("Document scanner failed: \(error.localizedDescription)")
            parent.dismiss()
        }
    }
}

// MARK: - Image Picker
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    var sourceType: UIImagePickerController.SourceType
    let onImageSelected: (UIImage?) -> Void
    @Environment(\.dismiss) private var dismiss
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = sourceType
        picker.allowsEditing = false
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
                parent.onImageSelected(image)
            }
            parent.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.dismiss()
        }
    }
}

extension UIImage {
    func resized(toMaxWidth maxWidth: CGFloat, compressionQuality: CGFloat = 0.5) -> Data? {
        let scale = maxWidth / max(size.width, size.height)
        let newSize = CGSize(width: size.width * scale, height: size.height * scale)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        self.draw(in: CGRect(origin: .zero, size: newSize))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return resizedImage?.jpegData(compressionQuality: compressionQuality)
    }
}

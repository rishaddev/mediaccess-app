import Foundation

// Email validation helper
class EmailValidator {
    func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
}

// Signup data structure for testing
struct SignupData {
    let fullName: String
    let email: String
    let password: String
    let phoneNumber: String
}

// Signup validation helper
class SignupValidator {
    private let emailValidator = EmailValidator()
    
    func validateSignupData(_ data: SignupData) -> String? {
        // Check if all fields are filled
        guard !data.fullName.isEmpty,
              !data.email.isEmpty,
              !data.password.isEmpty,
              !data.phoneNumber.isEmpty else {
            return "Please fill in all fields"
        }
        
        // Check email format
        guard emailValidator.isValidEmail(data.email) else {
            return "Please enter a valid email address"
        }
        
        // Check password length
        guard data.password.count >= 6 else {
            return "Password must be at least 6 characters"
        }
        
        // All validation passed
        return nil
    }
}

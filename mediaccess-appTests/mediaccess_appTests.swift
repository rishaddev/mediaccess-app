//
//  mediaccess_appTests.swift
//  mediaccess-appTests
//
//  Created by Rishad 009 on 2025-08-05.
//

import Testing
@testable import mediaccess_app

struct mediaccess_appTests {

    @Test func example() async throws {
        // Write your test here and use APIs like `#expect(...)` to check expected conditions.
    }
    
    // Test email validation
    @Test func testValidEmailAddresses() async throws {
        let validator = EmailValidator()
        
        // Valid email addresses
        #expect(validator.isValidEmail("test@example.com") == true)
        #expect(validator.isValidEmail("user.name@domain.co.uk") == true)
        #expect(validator.isValidEmail("firstname+lastname@company.org") == true)
        #expect(validator.isValidEmail("123@test.io") == true)
    }
    
    @Test func testInvalidEmailAddresses() async throws {
        let validator = EmailValidator()
        
        // Invalid email addresses
        #expect(validator.isValidEmail("") == false)
        #expect(validator.isValidEmail("notanemail") == false)
        #expect(validator.isValidEmail("test@") == false)
        #expect(validator.isValidEmail("@domain.com") == false)
        #expect(validator.isValidEmail("test.domain.com") == false)
        #expect(validator.isValidEmail("test@domain") == false)
    }
    
    // Test signup form validation
    @Test func testSignupValidation() async throws {
        let validator = SignupValidator()
        
        // Valid signup data
        let validData = SignupData(
            fullName: "John Doe",
            email: "john@example.com",
            password: "password123",
            phoneNumber: "1234567890"
        )
        #expect(validator.validateSignupData(validData) == nil)
        
        // Invalid data - empty name
        let invalidName = SignupData(
            fullName: "",
            email: "john@example.com",
            password: "password123",
            phoneNumber: "1234567890"
        )
        #expect(validator.validateSignupData(invalidName) == "Please fill in all fields")
        
        // Invalid data - short password
        let shortPassword = SignupData(
            fullName: "John Doe",
            email: "john@example.com",
            password: "123",
            phoneNumber: "1234567890"
        )
        #expect(validator.validateSignupData(shortPassword) == "Password must be at least 6 characters")
        
        // Invalid data - bad email
        let badEmail = SignupData(
            fullName: "John Doe",
            email: "notanemail",
            password: "password123",
            phoneNumber: "1234567890"
        )
        #expect(validator.validateSignupData(badEmail) == "Please enter a valid email address")
    }

}

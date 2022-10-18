//
//  SignupViewModel.swift
//  SwufitUI Validation and MVVM
//
//  Created by Stewart Lynch on 2020-05-09.
//  Copyright © 2020 CreaTECH Solutions. All rights reserved.
//

import Foundation

class SignupViewModel: ObservableObject {
    @Published var email = "" {
        didSet {
            isValidEmail = isEmailValid()
        }
    }
    
    @Published var password = "" {
        didSet {
            isValidPassword = isPasswordValid()
        }
    }
    
    @Published var confirmPw = "" {
        didSet {
            isPasswordMatch = passwordsMatch()
        }
    }
    
    var birthYear: Int = Calendar.current.dateComponents([.year], from: Date()).year! {
        didSet {
            isValidAge = isAgeValid()
        }
    }
    
    var isValidEmail  = false
    var isValidPassword  = false
    var isPasswordMatch  = false
    var isValidAge  = false
    
    // MARK: - Validation Functions
    
    func passwordsMatch() -> Bool {
        password == confirmPw
    }
    
    func isPasswordValid() -> Bool {
        // criteria in regex.  See http://regexlib.com
        let passwordTest = NSPredicate(format: "SELF MATCHES %@",
                                       "^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z]).{8,15}$")
        return passwordTest.evaluate(with: password)
    }
    
    func isEmailValid() -> Bool {
        // criteria in regex.  See http://regexlib.com
        let emailTest = NSPredicate(format: "SELF MATCHES %@",
                                    "^([a-zA-Z0-9_\\-\\.]+)@((\\[[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\\]?)$")
        return emailTest.evaluate(with: email)
    }
    
    func isAgeValid() -> Bool {
        (Calendar.current.dateComponents([.year], from: Date()).year! - birthYear) >= 21
    }
    
    var isSignUpComplete: Bool {
        if !isPasswordMatch ||
        !isValidPassword ||
        !isValidEmail ||
            !isValidAge {
            return false
        }
        return true
    }
    
    // MARK: - Validation Prompt Strings
    
    var confirmPwPrompt: String {
        if isPasswordMatch {
            return ""
        } else {
            return "Password fields do not match"
        }
    }
    
    var emailPrompt: String {
        if isValidEmail {
            return ""
        } else {
            return "Enter a valid email address"
        }
    }
    
    var passwordPrompt: String {
        if isValidPassword {
            return ""
        } else {
            return "Must be between 8 and 15 characters containing at least one number and one capital letter"
        }
    }
    
    var agePrompt: String {
        if isValidAge {
            return "Year of birth"
        } else {
            return "Year of birth (must be 21 years old)"
        }
    }
    
    func signUp() {
        // perform signup functions then clear fields
        email = ""
        password = ""
        confirmPw = ""
        birthYear = Calendar.current.dateComponents([.year], from: Date()).year!
    }
}

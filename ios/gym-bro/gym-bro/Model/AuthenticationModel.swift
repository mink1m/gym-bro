//
//  UserStateViewModel.swift
//  gym-bro
//

//

import Foundation
import Firebase
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

enum AuthenticationError: Error {
    case signInError, signOutError, registrationError
}

enum AuthenticationStates: String {
    case signedOut, signedIn, creatingAccount
}

@Observable
class AuthenticationModel {
    var currAuthState = AuthenticationStates.signedOut
    var authErrorMessage = ""
    var authError = false
    
    // Sign In to account through email and password
    func signIn(email: String, password: String) {
        authErrorMessage = ""
        self.authError = false
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                self.authErrorMessage = error.localizedDescription
                self.authError = true
                return
            }
            
            self.currAuthState = .signedIn
        }
    }
    
    // create a new Email password account
    func createUser(email: String, password: String, newUser: Profile) {
        authErrorMessage = ""
        self.authError = false
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                self.authErrorMessage = error.localizedDescription
                self.authError = true
                return
            }
            
            guard let curEmail = Auth.auth().currentUser?.email else {
                self.authErrorMessage = "Failed to create user account"
                self.authError = true
                return
                
            }
            let userRef = Firestore.firestore().collection("users").document(curEmail)
            let encoder = Firestore.Encoder()
            
            do {
                let userData = try encoder.encode(newUser)
                userRef.setData(userData) { error in
                    if let error = error {
                        self.authErrorMessage = error.localizedDescription
                        self.authError = true
                        return
                    }
                    self.currAuthState = .signedIn
                }
            }
            catch {
                self.authErrorMessage = error.localizedDescription
                self.authError = true
            }
        }
        
    }
    
    
    // sign out of account
    func signOut() {
        authErrorMessage = ""
        self.authError = false
        do {
            try Auth.auth().signOut()
            self.currAuthState = .signedOut
        } catch {
            authErrorMessage = error.localizedDescription
            self.authError = true
        }
    }
}

//
//  RegistrationView.swift
//  gym-bro
//

//

import SwiftUI

struct SignUpView: View {
    @Environment(ModelData.self) private var modelData
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showingRegistrationSheet: Bool = false
    
    var body: some View {
        @Bindable var modelData = modelData
        VStack {
            
            Spacer()
            
            Text("Gym Bro")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.bottom, 30)
            
            Text("Create Account")
                .font(.body)
                .fontWeight(.thin)
                .padding(.bottom, 30)
            
            CustomInput(label: "Email", field_value: $email, systemImageName: "envelope.circle.fill")
                .padding(.bottom, 10)
            
            CustomInput(label: "Password", field_value: $password, systemImageName: "lock.circle.fill")
                .padding(.bottom, 10)
            
            CustomButton(text: "Register") {
                
                if(password.count > 7) {
                    showingRegistrationSheet.toggle()
                }
                else {
                    print("password doesn't meet minimum length of 8")
                }
            }
            .padding(.bottom, 10)
            
            Spacer()
        }
        .sheet(isPresented: $showingRegistrationSheet) {
            RegistrationView(profile: $modelData.profile) {
                modelData.authModel.createUser(
                    email: email,
                    password: password,
                    newUser: modelData.profile
                )
            }
        }
        .alert(modelData.authModel.authErrorMessage, isPresented: $modelData.authModel.authError) {
            Button("Ok", role: .cancel) {}
        }
    }
}

#Preview {
    SignUpView()
        .environment(ModelData())
}

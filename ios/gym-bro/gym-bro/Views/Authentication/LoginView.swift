//
//  LoginView.swift
//  gym-bro
//
//

import SwiftUI

struct LoginView: View {
    @Environment(ModelData.self) private var modelData
    @State private var email: String = ""
    @State private var password: String = ""
    
    var body: some View {
        @Bindable var modelData = modelData
        
        NavigationStack {
            
            Spacer()
            
            Text("Gym Bro")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.bottom, 30)
            
            Text("We got you Bro")
                .font(.body)
                .fontWeight(.thin)
                .padding(.bottom, 30)
            
            CustomInput(label: "Email", field_value: $email, systemImageName: "envelope.circle.fill")
                .padding(.bottom, 10)
            
            CustomInput(label: "Password", field_value: $password, systemImageName: "lock.circle.fill")
                .padding(.bottom, 10)
            
            CustomButton(text: "Login") {
                modelData.authModel.signIn(email: email, password: password)
            }
            .padding(.bottom, 10)
        
            NavigationLink {
                SignUpView()
            } label: {
                Text("Sign Up")
                    .foregroundColor(.secondary)
            }
            
            
            Spacer()
        }
        .padding(30)
        .alert(modelData.authModel.authErrorMessage, isPresented: $modelData.authModel.authError) {
            Button("Ok", role: .cancel) {}
        }
    }
}

#Preview {
    LoginView()
        .environment(ModelData())
}

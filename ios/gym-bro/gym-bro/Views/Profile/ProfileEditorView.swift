//
//  ProfileEditorView.swift
//  gym-bro
//
//

import SwiftUI

struct ProfileEditorView: View {
    @State private var submitInfo = false
    
    @Environment(ModelData.self) private var modelData
    @State private var draftProfile = Profile.default
    @State private var updateProfileAlert = false
    
    var body: some View {
        @Bindable var modelData = modelData
        
        NavigationStack {
            VStack {
                Form {
                    Section {
                        ProfileEditor(profile: $draftProfile)
                    }
                    Section {
                        Button("Update") {
                            
                            Task {
                                let suc = await updateCurrentUserProfile(newProfile: draftProfile)
                                
                                if suc {
                                    modelData.profile = draftProfile
                                    updateProfileAlert.toggle()
                                }
                            }
                        }
                    }
                    Section {
                        Button("Logout") {
                            modelData.authModel.signOut()
                            modelData.profile = Profile.default
                        }
                        .foregroundColor(.red)
                        
                    }
                }
                
            }
            .navigationTitle("Info")
            .onAppear {
                draftProfile = modelData.profile
            }
            .alert(modelData.authModel.authErrorMessage, isPresented: $modelData.authModel.authError) {
                Button("Ok", role: .cancel) {}
            }
            .alert("Updated Profile", isPresented: $updateProfileAlert) {
                Button("Ok", role: .cancel) {}
            }
        }
    }
}

#Preview {
    ProfileEditorView()
        .environment(ModelData())
}

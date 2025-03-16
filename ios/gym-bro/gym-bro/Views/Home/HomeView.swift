//
//  HomeView.swift
//  gym-bro
//

//

import SwiftUI

struct HomeView: View {
    @Environment(ModelData.self) private var modelData
    @State private var selection: Tab = .workout
    
    enum Tab {
        case stats
        case workout
        case profile
    }
    
    
    var body: some View {
        @Bindable var modelData = modelData
        
        TabView(selection: $selection) {
            StatsView()
                .tabItem {
                    Image(systemName: "chart.bar")
                }
                .tag(Tab.stats)
            
            WorkoutView()
                .tabItem {
                    Image(systemName: "house")
                }
                .tag(Tab.workout)
            
            ProfileEditorView()
                .tabItem {
                    Image(systemName: "person.crop.circle")
                }
                .tag(Tab.profile)
        }
        .onAppear {
            // correct the transparency bug for Tab bars
            let tabBarAppearance = UITabBarAppearance()
            tabBarAppearance.configureWithOpaqueBackground()
            UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
            // correct the transparency bug for Navigation bars
            let navigationBarAppearance = UINavigationBarAppearance()
            navigationBarAppearance.configureWithOpaqueBackground()
            UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
            
        }
        .task {
            guard let signedInUser: Profile = await getCurrentUserProfile() else {
                return
            }
            modelData.profile = signedInUser
            
            await modelData.currentWorkout.getExercises()
        }
    }
}

#Preview {
    HomeView()
        .environment(ModelData())
}

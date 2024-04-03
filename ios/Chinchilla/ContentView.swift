//
//  ContentView.swift
//  Chinchilla
//
//  Created by Samantha Vaca on 3/9/24.
//

import SwiftUI
import Firebase

struct ContentView: View {
    
    var multipeerManager = MultipeerManager()

    var body: some View {
        NavigationView {
            
            TabView {
                ListeningView()
                    .tabItem {
                        Label("Listen", systemImage: "mic")
                    }
                ProfileView()
                    .tabItem {
                        Label("Profile", systemImage: "person.fill")
                    }
                MatchesView()
                    .tabItem {
                        Label("Matches", systemImage: "list.bullet")
                    }
            }
            
        }
        .navigationBarTitle("")
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

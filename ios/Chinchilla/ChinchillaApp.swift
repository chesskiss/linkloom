//
//  ChinchillaApp.swift
//  Chinchilla
//
//  Created by Samantha Vaca on 3/9/24.
//

import SwiftUI
import UIKit
import Firebase

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct ChinchillaApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @StateObject var userSettings = UserSettings()
    
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            initialView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(userSettings)
        }
    }
    
    func initialView() -> some View {
        if userSettings.isLoggedIn {
            return AnyView(ContentView())
        } else {
            return AnyView(Login())
        }
    }
}

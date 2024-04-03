//
//  LoginViewModel.swift
//  Chinchilla
//
//  Created by Samantha Vaca on 3/9/24.
//

import Foundation
import FirebaseAuth
import Firebase

class LoginViewModel: ObservableObject {
    
    var userSettings: UserSettings = UserSettings()
    var email: String = ""
    var password: String = ""
    
    func login(completion: @escaping () -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                self.userSettings.isLoggedIn = true;
                
                let userID = Auth.auth().currentUser!.uid
                
                let defaults = UserDefaults.standard
                defaults.set(userID, forKey: "userID")
                completion()
            }
            
        }
    }
}


//
//  RegisterViewModel.swift
//  Chinchilla
//
//  Created by Samantha Vaca on 3/9/24.
//

import Foundation
import FirebaseAuth
import Firebase

var db = Firestore.firestore()

class RegisterViewModel: ObservableObject {
    var email: String = ""
    var password: String = ""
    var name: String = ""
    var instagram: String = ""
    var linkedin: String = ""
    var userSettings: UserSettings = UserSettings()
    
    
    func register(completion: @escaping () -> Void) {
        // Change this to phone number!
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
            
                let userID = Auth.auth().currentUser!.uid
                
                let defaults = UserDefaults.standard
                defaults.set(userID, forKey: "userID")

                db.collection("profiles").document(userID).setData([
                    "name": [self.name, 1],
                    "email": [self.email, 1],
                    "instagram": [self.instagram, 2],
                    "linkedin": [self.linkedin, 2]
                ]) { err in
                    if let err = err {
                        print("Error writing document: \(err)")
                    } else {
                        self.userSettings.isLoggedIn = true;
                        completion()
                    }
                }
                
            }
            
        }
        
    }
}

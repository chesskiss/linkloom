//
//  ProfileObserver.swift
//  Chinchilla
//
//  Created by Samantha Vaca on 3/10/24.
//

import Foundation

import FirebaseFirestore

class DocumentViewModel: ObservableObject {
    private let db = Firestore.firestore()
    @Published var documentData : [String: String] = ["temp": "temp"] // Change this data type according to your document structure
    @Published var name: String = ""
    @Published var email: String = ""
    @Published var instagram: String = ""
    @Published var linkedin: String = ""
    
    init() {
        let docRef = db.collection("profiles").document(UserDefaults.standard.string(forKey: "userID") ?? "ERROR")
        
        docRef.addSnapshotListener { [weak self] (documentSnapshot, error) in
            guard let document = documentSnapshot else {
                print("Error fetching document: \(error!)")
                return
            }
            
            guard let data = document.data() else {
                print("Document data was empty.")
                return
            }
            
            print(data)
            print("DOCUMENT DATA")
            
            for (key, value) in data {
                if let array = value as? [String], let firstElement = array.first {
                    if (key == "name") {
                        self!.name = firstElement
                    }
                    if (key == "email") {
                        self!.email = firstElement
                    }
                    if (key == "instagram") {
                        self!.instagram = firstElement
                    }
                    if (key == "linkedin") {
                        self!.linkedin = firstElement
                    }
                    print("\(key): \(firstElement)")
                    self!.documentData[key] = firstElement
                }
            }
            
            print(self!.documentData)
            
            print("RUNNIN")

        }
    }
}

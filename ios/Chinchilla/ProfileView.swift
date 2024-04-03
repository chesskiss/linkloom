//
//  Profile.swift
//  Chinchilla
//
//  Created by Samantha Vaca on 3/9/24.
//


import SwiftUI

struct ProfileView: View {
    var profileHasImage = false
    
    @ObservedObject var profileDocument = DocumentViewModel()
    
    var body: some View {
        
        VStack {
            Text("Name: \(profileDocument.name)")
                        .padding()
            Text("Email: \(profileDocument.email)")
                        .padding()
            Text("Instagram: \(profileDocument.instagram)")
                        .padding()
            Text("Linkedin: \(profileDocument.linkedin)")
                        .padding()
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}

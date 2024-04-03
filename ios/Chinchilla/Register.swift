//
//  SignUp.swift
//  Chinchilla
//
//  Created by Samantha Vaca on 3/9/24.
//

import SwiftUI
import Swift


struct SignUp: View {
    
    @State var isPresented: Bool = false
    @State var isActive: Bool = false
    @State var isLoginIn: Bool = false
    
    @ObservedObject private var registerVM = RegisterViewModel()
    
    var body: some View {
        
        NavigationView {
            VStack(alignment: .leading, content: {
                    Image("ColorSplash-RemovedBack")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 300, height: 300)
                        .clipShape(Circle())
                        .padding(15)
                        .scaledToFill()
                        .padding(.leading)
                    
                        Text("Sign Up")
                            .font(.largeTitle)
                            .fontWeight(.heavy)
                                
                            
                        Text("Please sign up to continue")
                            .font(.callout)
                            .fontWeight(.semibold)
                            .foregroundStyle(.gray)
                            .padding(.top, -5)
                        
                    
                    VStack(spacing: 25) {
                        
                        HStack(alignment: .top, spacing: 8, content: {
                            Image(systemName: "person")
                                .foregroundStyle(.black)
                                .frame(width: 30)
                            
                            VStack(alignment: .leading, spacing: 8, content: {
                                TextField("Name", text: $registerVM.name)
                                
                                Divider()
                            })
                            
                        })
                        
                        HStack(alignment: .top, spacing: 8, content: {
                            Image(systemName: "at")
                                .foregroundStyle(.black)
                                .frame(width: 30)
                            
                            VStack(alignment: .leading, spacing: 8, content: {
                                TextField("Instagram", text: $registerVM.instagram)
                                
                                Divider()
                            })
                            
                        })
                        
                        HStack(alignment: .top, spacing: 8, content: {
                            Image(systemName: "at")
                                .foregroundStyle(.black)
                                .frame(width: 30)
                            
                            VStack(alignment: .leading, spacing: 8, content: {
                                TextField("LinkedIn", text: $registerVM.linkedin)
                                
                                Divider()
                            })
                            
                        })
                        
                        HStack(alignment: .top, spacing: 8, content: {
                            Image(systemName: "at")
                                .foregroundStyle(.black)
                                .frame(width: 30)
                            
                            VStack(alignment: .leading, spacing: 8, content: {
                                TextField("Email", text: $registerVM.email)
                                
                                Divider()
                            })
                            
                        })
                        
                        HStack(alignment: .top, spacing: 8, content: {
                            Image(systemName: "lock")
                                .foregroundStyle(.black)
                                .frame(width: 30)
                            
                            VStack(alignment: .leading, spacing: 8, content: {
                                SecureField("Password", text: $registerVM.password)
                                
                                Divider()
                            })
                            
                        })
                        
                        Button("Sign Up"){
                            registerVM.register {
                                isActive = true
                            }
                        }
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                        .padding(.vertical, 12)
                        .padding(.horizontal, 35)
                        .background(.linearGradient(colors: [.purple, .blue], startPoint: .top, endPoint: .bottom), in: .capsule)
                        .padding(.bottom, 10)
                        
                        Spacer(minLength: 0)
                        
                        HStack(spacing: 6) {
                            Text("Already have an account?")
                                .foregroundStyle(.gray)
                            
                            Button("Sign In") {
                                isLoginIn = true
                            }
                            .fontWeight(.semibold)
                            .foregroundStyle(.black)
                        }
                        .font(.callout)
                        .padding(5)
                        
                        
                    }
                    .padding(10)
            })
            .padding(.horizontal, 15)
        }
        .navigate(to: ContentView(), when: $isActive)
        .navigate(to: Login(), when: $isLoginIn)
        .navigationBarHidden(true)
    }
}

struct SignUp_Previews: PreviewProvider {
    static var previews: some View {
        SignUp()
    }
}

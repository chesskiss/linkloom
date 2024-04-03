//
//  Login.swift
//  Chinchilla
//
//  Created by Samantha Vaca on 3/9/24.
//

import SwiftUI
import Swift


struct Login: View {
    
    @State var isPresented: Bool = false
    @State var isActive: Bool = false
    @State var isSignUp: Bool = false
    
    @ObservedObject private var loginVM = LoginViewModel()
    
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
                    
                        Text("Login")
                            .font(.largeTitle)
                            .fontWeight(.heavy)
                                
                            
                        Text("Please sign in to continue")
                            .font(.callout)
                            .fontWeight(.semibold)
                            .foregroundStyle(.gray)
                            .padding(.top, -5)
                        
                    
                    VStack(spacing: 25) {
                        
                        HStack(alignment: .top, spacing: 8, content: {
                            Image(systemName: "at")
                                .foregroundStyle(.black)
                                .frame(width: 30)
                            
                            VStack(alignment: .leading, spacing: 8, content: {
                                TextField("Email", text: $loginVM.email)
                                
                                Divider()
                            })
                            
                        })
                        
                        HStack(alignment: .top, spacing: 8, content: {
                            Image(systemName: "lock")
                                .foregroundStyle(.black)
                                .frame(width: 30)
                            
                            VStack(alignment: .leading, spacing: 8, content: {
                                SecureField("Password", text: $loginVM.password)
                                
                                Divider()
                            })
                            
                        })
                        
                        Button("Login"){
                            loginVM.login {
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
                            Text("Don't have an account?")
                                .foregroundStyle(.gray)
                            
                            Button("Sign Up") {
                                isSignUp = true
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
        .navigate(to: SignUp(), when: $isSignUp)
        .navigationBarHidden(true)
    }
}

extension View {
    func navigate<NewView: View>(to view: NewView, when binding: Binding<Bool>) -> some View {
        NavigationView {
            ZStack {
                self
                    .navigationBarTitle("")
                    .navigationBarHidden(true)
                    .navigationBarBackButtonHidden(true)

                NavigationLink(
                    destination: view
                        .navigationBarTitle("")
                        .navigationBarHidden(true)
                        .navigationBarBackButtonHidden(true),
                    isActive: binding
                ) {
                    EmptyView()
                }
            }
        }
    }
}


struct Login_Previews: PreviewProvider {
    static var previews: some View {
        Login()
    }
}


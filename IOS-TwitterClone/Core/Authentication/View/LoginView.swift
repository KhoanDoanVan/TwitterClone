//
//  LoginView.swift
//  Swift-Threads
//
//  Created by Đoàn Văn Khoan on 07/02/2024.
//

import SwiftUI

struct LoginView: View {
    
    @StateObject private var viewModel = LoginViewModel()
    
    var body: some View {
        NavigationStack{
            
            Spacer()
            
            Image("Icon")
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 150)
            
            VStack{
                TextField("Enter your email", text : $viewModel.email)
                    .autocapitalization(.none)
                    .modifier(TwitterTextFieldModifier())
                
                SecureField("Enter your password", text : $viewModel.password)
                    .modifier(TwitterTextFieldModifier())
            }
            .padding(.top)
            
            NavigationLink{
                Text("Forgot password View")
            } label: {
                Text("Forgot Password?")
                    .font(.footnote)
                    .fontWeight(.semibold)
                    .padding(.trailing, 28)
                    .padding(.vertical)
                    .foregroundColor(.blue)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
            
            Button(action: {
                Task {
                    try await viewModel.login()
                }
            }, label: {
                Text("Login")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .frame(width: 350, height: 50)
                    .background(Color("BlueMain"))
                    .foregroundColor(.white)
                    .cornerRadius(10)
            })
            
            Spacer()
            
            Divider()
            
            NavigationLink{
                RegisterationView()
            } label : {
                HStack (spacing : 3){
                    Text("Don't have an account?")
                    
                    Text("Sign Up")
                        .fontWeight(.semibold)
                        .foregroundStyle(.blue)
                }
                .font(.footnote)
                .foregroundColor(.black)
            }
            .padding(.vertical, 16)
        }
    }
}

#Preview {
    LoginView()
}

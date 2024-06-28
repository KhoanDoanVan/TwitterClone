//
//  LoginView.swift
//  Swift-Threads
//
//  Created by Đoàn Văn Khoan on 07/02/2024.
//

import SwiftUI

struct RegisterationView: View {
    @Environment(\.dismiss) private var dismiss
    
    @StateObject private var viewModel = RegisterationViewModel()
    
    var body: some View {
        NavigationStack{
            
            VStack{
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
                    
                    TextField("Enter your user name", text : $viewModel.username)
                        .autocapitalization(.none)
                        .modifier(TwitterTextFieldModifier())
                    
                    TextField("Enter your full name", text : $viewModel.fullname)
                        .autocapitalization(.none)
                        .modifier(TwitterTextFieldModifier())
                }
                .padding(.top)
                
                
                Button(action: {
                    Task {
                        try await viewModel.signUp()
                    }
                }, label: {
                    Text("Sign up")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .frame(width: 350, height: 50)
                        .background(Color("BlueMain"))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                })
                
                Spacer()
                
                Divider()
                
                Button{
                    dismiss()
                } label : {
                    HStack (spacing : 3){
                        Text("Already has an account?")
                        
                        Text("Login")
                            .fontWeight(.semibold)
                            .foregroundStyle(.blue)
                    }
                    .font(.footnote)
                    .foregroundColor(.black)
                }
                .padding(.vertical, 16)
                .navigationBarBackButtonHidden(true)
            }
        }
    }
}

#Preview {
    RegisterationView()
}

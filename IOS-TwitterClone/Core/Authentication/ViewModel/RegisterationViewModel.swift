//
//  RegisterationViewModel.swift
//  IOS-TwitterClone
//
//  Created by Đoàn Văn Khoan on 15/04/2024.
//

import Foundation


class RegisterationViewModel: ObservableObject {
    @Published var email : String
    @Published var password : String
    @Published var username : String
    @Published var fullname : String
    
    init() {
        self.email = ""
        self.password = ""
        self.username = ""
        self.fullname = ""
    }
    
    @MainActor
    func signUp() async throws {
        try await AuthService.shared.createUser(withEmail: email, password: password, username: username, fullname: fullname)
    }
}

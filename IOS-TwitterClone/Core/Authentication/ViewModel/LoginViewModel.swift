//
//  LoginViewModel.swift
//  IOS-TwitterClone
//
//  Created by Đoàn Văn Khoan on 15/04/2024.
//

import Foundation


class LoginViewModel: ObservableObject {
    @Published var email : String
    @Published var password : String
    
    init() {
        self.email = ""
        self.password = ""
    }
    
    @MainActor
    func login() async throws {
        try await AuthService.shared.login(withEmail: email, password: password)
    }
}

//
//  AuthService.swift
//  IOS-TwitterClone
//
//  Created by Đoàn Văn Khoan on 15/04/2024.
//

import Firebase
import FirebaseFirestoreSwift

class AuthService {
    @Published var userSession : FirebaseAuth.User?
    
    static let shared = AuthService()
    
    init() {
        self.userSession = Auth.auth().currentUser
    }
    
    func login(withEmail email : String, password : String) async throws {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            try await UserService.shared.fetchCurrentUser()
        } catch {
            print("Login Failed with error \(error.localizedDescription)")
        }
    }
    
    func createUser(withEmail email : String, password : String, username : String, fullname : String) async throws {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            print("userSession: \(result.user)")
            self.userSession = result.user
            try await uploadUserInformationFireStore(id: result.user.uid, withEmail: email, username: username, fullname: fullname)
        } catch {
            print("Create new user failed with error \(error.localizedDescription)")
        }
    }
    
    private func uploadUserInformationFireStore(id : String, withEmail email : String, username : String, fullname : String) async throws {
        let user = User(id: id, email: email, username: username, fullname: fullname)
        guard let userData = try? Firestore.Encoder().encode(user) else { return }
        try await Firestore.firestore().collection("users").document(id).setData(userData)
        UserService.shared.currentUser = user
    }
    
    func signOut() throws {
        try? Auth.auth().signOut()
        self.userSession = nil
        UserService.shared.reset()
    }
}

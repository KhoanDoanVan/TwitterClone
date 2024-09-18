//
//  UserService.swift
//  IOS-TwitterClone
//
//  Created by Đoàn Văn Khoan on 15/04/2024.
//

import Firebase
import FirebaseFirestoreSwift

class UserService {
    @Published var currentUser : User?
    
    static var shared = UserService()
    
    init() {
        Task {
            try await fetchCurrentUser()
        }
    }
    
    // Fetch Current User
    func fetchCurrentUser() async throws {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let snapshot = try await Firestore.firestore().collection("users").document(uid).getDocument()
        let user = try snapshot.data(as: User.self)
        self.currentUser = user
    }
    
    // Fetch All Users
    func fetchUsers() async throws -> [User] {
        guard let currentUid = Auth.auth().currentUser?.uid else { return [] }
        let snapshot = try await Firestore.firestore().collection("users").getDocuments()
        let users = snapshot.documents.compactMap({
            try? $0.data(as: User.self)
        })
        return users.filter({ $0.id != currentUid })
    }
    
    // Fetch User by ID
    static func fetchUser(withUid uid : String) async throws -> User {
        let snapshot = try await Firestore.firestore().collection("users").document(uid).getDocument()
        return try snapshot.data(as: User.self)
    }
    
    // Refresh User Current
    func reset() {
        self.currentUser = nil
    }
    
    static func fetchListUserByKeySearch(keySearch : String) async throws -> [User] {
        guard let currentUid = Auth.auth().currentUser?.uid else { return [] }
        let snapshot = try await Firestore.firestore().collection("users").getDocuments()
        let users = snapshot.documents.compactMap({
            try? $0.data(as: User.self)
        })
        return users.filter({
            ($0.id != currentUid) && (($0.username.range(of: keySearch)) != nil)
        })
    }
    
    @MainActor
    func updateImageUser(withImageUrl imageUrl : String) async throws {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        try await Firestore.firestore().collection("users").document(currentUid).updateData([
            "profileImageUrl" : imageUrl
        ])
        self.currentUser?.profileImageUrl = imageUrl
    }
    
    @MainActor
    func updateImageBackgroundUser(withImageUrl imageUrl : String) async throws {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        try await Firestore.firestore().collection("users").document(currentUid).updateData([
            "backgroundImageUrl" : imageUrl
        ])
        self.currentUser?.backgroundImageUrl = imageUrl
    }
    
    func followUserUid(userUid : String) async throws {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        try await Firestore.firestore().collection("users")
            .document(currentUid)
            .updateData([
                "following" : FieldValue.arrayUnion([
                    userUid
                ])
            ])
        
        try await Firestore.firestore().collection("users")
            .document(userUid)
            .updateData([
                "followers" : FieldValue.arrayUnion([
                    currentUid
                ])
            ])
    }
    
    func unfollowUserUid(userUid : String) async throws {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        try await Firestore.firestore().collection("users")
            .document(currentUid)
            .updateData([
                "following" : FieldValue.arrayRemove([
                    userUid
                ])
            ])
        
        try await Firestore.firestore().collection("users")
            .document(userUid)
            .updateData([
                "followers" : FieldValue.arrayRemove([
                    currentUid
                ])
            ])
    }
}

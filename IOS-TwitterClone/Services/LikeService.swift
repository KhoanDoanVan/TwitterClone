//
//  LikeService.swift
//  IOS-TwitterClone
//
//  Created by Đoàn Văn Khoan on 28/4/24.
//

import Firebase

class LikeService {
    
    static func likePost(uidPost: String) async throws {
        guard let uidCurrent = UserService.shared.currentUser?.id else { return }
        
        let likeRef = Firestore.firestore().collection("likes").document(uidPost)
        
        let documentSnapshot = try await likeRef.getDocument()
        
        if !documentSnapshot.exists {
            let initialLike = Like(id: uidPost, userIds: [uidCurrent])
            let likeData = try Firestore.Encoder().encode(initialLike)
            try await likeRef.setData(likeData)
        } else {
            try await likeRef.updateData([
                "userIds": FieldValue.arrayUnion([uidCurrent])
            ])
        }
    }
    
    static func unLikePost(uidPost : String, amountCheck : Int) async throws {
        guard let uidCurrent = UserService.shared.currentUser?.id else { return }
        
        if amountCheck == 1 {
            try await Firestore.firestore().collection("likes").document(uidPost).delete()
        } else {
            try await Firestore.firestore().collection("likes").document(uidPost).updateData([
                "userIds" : FieldValue.arrayRemove(
                    [
                        uidCurrent
                    ]
                )
            ])
        }
    }
}

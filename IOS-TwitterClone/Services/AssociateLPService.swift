//
//  AssociateLPService.swift
//  IOS-TwitterClone
//
//  Created by Đoàn Văn Khoan on 28/4/24.
//

import Firebase

class AssociateLPService {
    static func likePost(userId: String, postId: String) {
        let likeRef = Firestore.firestore().collection("alp").document(postId + "_" + userId)
        likeRef.setData(["postId": postId, "userId": userId])
    }
        
    static func unlikePost(userId: String, postId: String) {
        let likeRef = Firestore.firestore().collection("alp").document(postId + "_" + userId)
        likeRef.delete()
    }
    
    static func hasUserLikedPost(userId: String, postId: String, completion: @escaping (Bool) -> Void) {
        let likeRef = Firestore.firestore().collection("alp").document(postId + "_" + userId)
        
        likeRef.getDocument { (document, error) in
            if let document = document, document.exists {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
}

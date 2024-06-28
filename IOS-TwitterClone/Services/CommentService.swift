//
//  CommentService.swift
//  IOS-TwitterClone
//
//  Created by Đoàn Văn Khoan on 29/4/24.
//

import Firebase


class CommentService {
    
    static func uploadComment(comment : Comment) async throws {
        guard let commentData = try? Firestore.Encoder().encode(comment) else { return }
        try await Firestore.firestore().collection("comments").addDocument(data: commentData)
    }
    
    static func fetchAllCommentByTweetUid(tweetUid : String) async throws -> [Comment] {
        let snapshot = try await Firestore.firestore().collection("comments").whereField("postId", in: [tweetUid]).getDocuments()
        
        return snapshot.documents.compactMap({
            try? $0.data(as: Comment.self)
        })
    }
}

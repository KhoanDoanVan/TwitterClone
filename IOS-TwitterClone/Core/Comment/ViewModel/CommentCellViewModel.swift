//
//  CommentCellViewModel.swift
//  IOS-TwitterClone
//
//  Created by Đoàn Văn Khoan on 29/4/24.
//

import Firebase
import FirebaseFirestoreSwift

class CommentCellViewModel: ObservableObject {
    @Published var user : User?
    
    @Published var postObject : ObjectPostRealtime?
    @Published var likeState : Bool? = false
    @Published var likeStateDB : Bool? = false
    let cacheManager = CacheManager.shared
    @Published var checkCacheLiked : Bool = false
    
    var ref : DatabaseReference! = Database.database().reference()
    
    @MainActor
    func readValue(uidComment : String) {
        ref.child("comments").child(uidComment)
            .observe(.value) { snapshot in
                do {
                    self.postObject = try snapshot.data(as: ObjectPostRealtime.self)
                } catch {
                    print(error.localizedDescription)
                }
            }
    }
    
    func setLikeValueOrUnlike(uidComment : String) {
        
        self.likeStateDB = self.likeState
        
        ref.child("comments").child(uidComment)
            .runTransactionBlock { currentData in
                guard var postData = currentData.value as? [String : Any] else {
                    return TransactionResult.abort()
                }
                
                // handle like or unlike
                var likeCount = postData["likes"] as? Int ?? 0
                
                if(self.likeState == false) {
                    likeCount += 1
                    DispatchQueue.main.async {
                        self.likeState?.toggle()
                    }
                    
                    // handle cache
                    self.cacheManager.addCommentLiked(uidComment: uidComment, values: "1")
                } else {
                    likeCount = likeCount == 0 ? 0 : (likeCount - 1)
                    DispatchQueue.main.async {
                        self.likeState?.toggle()
                    }
                    
                    // handle cache
                    self.cacheManager.removeCommentLiked(uidComment: uidComment)
                }
                postData["likes"] = likeCount
                
                currentData.value = postData
                
                return TransactionResult.success(withValue: currentData)
            }
    }
    
    // this function will be call after the setLikeValueOrUnlike()
    func updateLikeDatabase(uidComment : String) async throws {
        guard let uidCurrent = UserService.shared.currentUser?.id else { return }
        
        if self.likeStateDB == false {
            
            // database storage postId and userIds
            try await LikeService.likePost(uidPost: uidComment)
            
            // database storage userId and postId for checking like
            AssociateLPService.likePost(userId: uidCurrent, postId: uidComment)
        } else {

            // database storage postId and userIds
            try await LikeService.unLikePost(uidPost: uidComment, amountCheck: self.postObject?.likes ?? 0)
            
            // database storage userId and postId for checking like
            AssociateLPService.unlikePost(userId: uidCurrent, postId: uidComment)
        }
    }
    
    func checkCommentLikedOrNot(uidComment : String){
        guard let uidCurrent = UserService.shared.currentUser?.id else { return }
        
        AssociateLPService.hasUserLikedPost(userId: uidCurrent, postId: uidComment) { state in
            if state {
                DispatchQueue.main.async {
                    self.likeState = state
                }
                
                // cache
                self.cacheManager.addCommentLiked(uidComment: uidComment, values: "1")
            } else {
                DispatchQueue.main.async {
                    self.likeState = state
                }

            }
        }
    }
    
    @MainActor
    func fetchUser(userUid : String) async throws {
        do {
            self.user = try await UserService.fetchUser(withUid: userUid)
        } catch {
            print(error.localizedDescription)
        }
    }
}

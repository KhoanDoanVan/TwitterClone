//
//  TweetCellViewModel.swift
//  IOS-TwitterClone
//
//  Created by Đoàn Văn Khoan on 27/4/24.
//

import Foundation
import Firebase
import FirebaseDatabaseSwift


class TweetCellViewModel: ObservableObject {
    @Published var postObject : ObjectPostRealtime?
    @Published var likeState : Bool? = false
    @Published var likeStateDB : Bool? = false
    let cacheManager = CacheManager.shared
    @Published var checkCacheLiked : Bool = false
    
    var ref : DatabaseReference! = Database.database().reference()
    
    @MainActor
    func readValue(uidTweet : String) {
        ref.child("posts").child(uidTweet)
            .observe(.value) { snapshot in
                do {
                    self.postObject = try snapshot.data(as: ObjectPostRealtime.self)
                } catch {
                    print(error.localizedDescription)
                }
            }
    }
    
    func setLikeValueOrUnlike(uidTweet : String) {
        
        self.likeStateDB = self.likeState
        
        ref.child("posts").child(uidTweet)
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
                    self.cacheManager.addTweetLiked(uidTweet: uidTweet, values: "1")
                } else {
                    likeCount = likeCount == 0 ? 0 : (likeCount - 1)
                    DispatchQueue.main.async {
                        self.likeState?.toggle()
                    }
                    
                    // handle cache
                    self.cacheManager.removeTweetLiked(uidTweet: uidTweet)
                }
                postData["likes"] = likeCount
                
                currentData.value = postData
                
                return TransactionResult.success(withValue: currentData)
            }
    }
    
    // this function will be call after the setLikeValueOrUnlike()
    func updateLikeDatabase(uidTweet : String) async throws {
        guard let uidCurrent = UserService.shared.currentUser?.id else { return }
        
        if self.likeStateDB == false {
            
            // database storage postId and userIds
            try await LikeService.likePost(uidPost: uidTweet)
            
            // database storage userId and postId for checking like
            AssociateLPService.likePost(userId: uidCurrent, postId: uidTweet)
            
            // set notification
            let tweet = try await TweetService.fetchTweetsById(tweetId: uidTweet)
            
            let content = tweet?.content
            
            try await NotificationService.sendNotification(notification: Notification(id: UUID().uuidString, toId: tweet?.ownerUid ?? "", fromId: uidCurrent, type: NotificationType.like, content: content))
        } else {

            // database storage postId and userIds
            try await LikeService.unLikePost(uidPost: uidTweet, amountCheck: self.postObject?.likes ?? 0)
            
            // database storage userId and postId for checking like
            AssociateLPService.unlikePost(userId: uidCurrent, postId: uidTweet)
        }
    }
    
    func checkPostLikedOrNot(uidPost : String){
        guard let uidCurrent = UserService.shared.currentUser?.id else { return }
        
        AssociateLPService.hasUserLikedPost(userId: uidCurrent, postId: uidPost) { state in
            if state {
                DispatchQueue.main.async {
                    self.likeState = state
                }
                
                // cache
                self.cacheManager.addTweetLiked(uidTweet: uidPost, values: "1")
            } else {
                DispatchQueue.main.async {
                    self.likeState = state
                }

            }
        }
    }
}

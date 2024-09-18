//
//  DetailTweetViewModel.swift
//  IOS-TwitterClone
//
//  Created by Đoàn Văn Khoan on 29/4/24.
//

import Firebase
import FirebaseFirestoreSwift


@MainActor
class DetailTweetViewModel: ObservableObject {
    @Published var postObject: ObjectPostRealtime?
    @Published var stateLike : Bool? = false
    @Published var likeStateDB : Bool? = false
    @Published var checkedCacheLike : Bool = false
    
    @Published var currentUser : User? = UserService.shared.currentUser
    
    let managerCache = CacheManager.shared
    var ref : DatabaseReference! = Database.database().reference()
    
    // comment
    @Published var commentContent : String = ""
    @Published var openComment : Bool = false
    @Published var fakeComments = [Comment]()
    @Published var comments = [Comment]()
    @Published var commentsLoading : Bool = false
    
    func readValue(tweetUid : String) {
        ref.child("posts").child(tweetUid)
            .observe(.value) { snapshot in
                do {
                    self.postObject = try snapshot.data(as: ObjectPostRealtime.self)
                } catch {
                    print(error.localizedDescription)
                }
            }
    }
    
    func setLikeOrUnlike(tweetUid : String) {
        self.likeStateDB = self.stateLike
        
        ref.child("posts").child(tweetUid)
            .runTransactionBlock { currentData in
                guard var postObjectData = currentData.value as? [String : Any] else {
                    return TransactionResult.abort()
                }
                
                var countPost = postObjectData["likes"] as? Int ?? 0
                
                if(self.stateLike == false) {
                    countPost += 1
                    DispatchQueue.main.async {
                        self.stateLike?.toggle()
                    }
                    
                    self.managerCache.addTweetLiked(uidTweet: tweetUid, values: "1")
                } else {
                    if(countPost > 0){
                        countPost -= 1
                        DispatchQueue.main.async {
                            self.stateLike?.toggle()
                        }
                    }
                    
                    self.managerCache.removeTweetLiked(uidTweet: tweetUid)
                }
                
                postObjectData["likes"] = countPost
                currentData.value = postObjectData
                
                return TransactionResult.success(withValue: currentData)
            }
    }
    
    func updateLikeState(tweetUid : String) async throws {
        guard let currentUid = UserService.shared.currentUser?.id else { return }
        
        if self.likeStateDB == false {
            try await LikeService.likePost(uidPost: tweetUid)
            
            AssociateLPService.likePost(userId: currentUid, postId: tweetUid)
        } else {
            try await LikeService.unLikePost(uidPost: tweetUid, amountCheck: self.postObject?.likes ?? 0)
            
            AssociateLPService.unlikePost(userId: currentUid, postId: tweetUid)
        }
    }
    
    func checkLikeOrNotLike(tweetUid : String) {
        guard let currentUid = UserService.shared.currentUser?.id else { return }
        
        AssociateLPService.hasUserLikedPost(userId: currentUid, postId: tweetUid) { state in
            if state {
                // if state equal true will set cache
                self.managerCache.addTweetLiked(uidTweet: tweetUid, values: "1")
            }
            
            DispatchQueue.main.async {
                self.stateLike = state
            }
        }
    }
    
    // stil not handle
    func uploadCommentTweet(postId : String) async throws {
        let uid = UUID().uuidString
        let comment = Comment(id: uid, ownerUid: currentUser?.id ?? "", create : Date.now, content : self.commentContent, postId : postId)
        
        // fake data
        addFakeComment(comment: comment)
        
        // indeed
        try await CommentService.uploadComment(comment: comment)
        
        // set notification
        let tweet = try await TweetService.fetchTweetsById(tweetId: postId)
        
        
        let content = comment.content
        
        try await NotificationService.sendNotification(notification: Notification(id: UUID().uuidString, toId: tweet?.ownerUid ?? "", fromId: currentUser?.id ?? "", type: NotificationType.comment, content: content))
        
        self.commentContent = ""
        setAmountComment(tweetUid: postId)
        setRealtimeForComment(uidComment: uid)
    }
    
    // set realtime
    func setAmountComment(tweetUid : String) {
        ref.child("posts").child(tweetUid)
            .runTransactionBlock { currentData in
                guard var postObjectData = currentData.value as? [String : Any] else {
                    return TransactionResult.abort()
                }
                
                var countCommentPost = postObjectData["comments"] as? Int ?? 0
                
                countCommentPost += 1
                
                postObjectData["comments"] = countCommentPost
                currentData.value = postObjectData
                
                return TransactionResult.success(withValue: currentData)
            }
    }
    
    func setRealtimeForComment(uidComment : String) {
        let postRef = ref.child("comments").child(uidComment)
        
        let objectPost = [
            "likes" : 0,
            "comments" : 0,
            "reupload" : 0
        ] as [String : Any]
        
        postRef.setValue(objectPost)
    }
    
    func fetchComments(tweetUid : String) async throws {
        
        self.commentsLoading = true
        do {
            self.comments = try await CommentService.fetchAllCommentByTweetUid(tweetUid: tweetUid)
            self.commentsLoading = false
        } catch {
            print(error.localizedDescription)
            self.commentsLoading = false
        }
    }
    
    func addFakeComment(comment : Comment) {
        self.fakeComments.append(comment)
    }
}

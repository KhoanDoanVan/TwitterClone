//
//  HomeViewModel.swift
//  IOS-TwitterClone
//
//  Created by Đoàn Văn Khoan on 17/04/2024.
//
import Foundation

@MainActor
class HomeViewModel: ObservableObject {
    @Published var tweetsFetch = [Tweet]()
    @Published var tweets = [Tweet]()
    @Published var isLoadingTweetFetch : Bool = false
    @Published var countAmountPost : Int = 0
    
    @Published var showTweetDetail : Bool = false
    @Published var tweetDetail : Tweet?
    
    @Published var userCurrent : User?
    
    @Published var arrayUidRenderHomeView : [String]?
    
    init() {
        Task {
           try await initialize()
        }
    }
    
    func initialize() async throws {
        // fetch current user
        try await fetchCurrentUser()
        
        // fetch amount post of following by current user
        try await getAmountTweet()
        
        // fetch tweets
        try await fetchTweets()
    }
    
    func fetchTweets() async throws {
        isLoadingTweetFetch = true

        do {
            self.tweetsFetch = try await TweetService.fetchTweetsByUserUids(arrayUid: arrayUidRenderHomeView ?? [], limit: 5)
            try await fetchUserByTweet()
            self.tweets += self.tweetsFetch
            isLoadingTweetFetch = false
        } catch {
            isLoadingTweetFetch = true
            print("\(error.localizedDescription)")
        }
    }
    
    func fetchUserByTweet() async throws {
        for i in 0..<tweetsFetch.count {
            let tweet = tweetsFetch[i]
            let ownerUid = tweet.ownerUid
            do {
                let userOfTweet = try await UserService.fetchUser(withUid: ownerUid)
                tweetsFetch[i].user = userOfTweet
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func fetchMoreTweets() async throws {
        try await fetchTweets()
    }
    
    func getAmountTweet() async throws {
        let query = try await TweetService.getAmountDocumentsOfCollection(arrayUid: arrayUidRenderHomeView ?? [])
        self.countAmountPost = query
        print(self.countAmountPost)
    }
    
    func fetchCurrentUser() async throws {
        try await UserService.shared.fetchCurrentUser()
        self.userCurrent = UserService.shared.currentUser
        self.arrayUidRenderHomeView = userCurrent?.following
    }
}

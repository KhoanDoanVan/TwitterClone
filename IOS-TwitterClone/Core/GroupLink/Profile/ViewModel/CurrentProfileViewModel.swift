//
//  CurrentProfileViewModel.swift
//  IOS-TwitterClone
//
//  Created by Đoàn Văn Khoan on 25/4/24.
//

import Foundation


class CurrentProfileViewModel: ObservableObject {
    @Published var fetchTweets : [Tweet] = [Tweet]()
    @Published var tweets : [Tweet] = [Tweet]()
    @Published var countAmountTweets : Int = 0
    @Published var isLoading : Bool = false
    
    init() {
        Task {
            try await getAmountTweet()
        }
    }
    
    @MainActor
    func fetchMoreTweets() async throws {
        try await fetchTweets()
    }
    
    
    @MainActor
    func fetchTweets() async throws {
        guard let currentUid = UserService.shared.currentUser?.id else { return }
        
        self.fetchTweets = try await TweetService.fetchTweetsByUserOwnedUid(uid: currentUid, limit : 5)
        
        guard let userCurrent = UserService.shared.currentUser else { return }
        
        try await fetchUserTweet(user: userCurrent)
        
        self.tweets += self.fetchTweets
        self.countAmountTweets = tweets.count
    }
    
    @MainActor
    func fetchUserTweet(user : User) async throws {
        for i in 0..<fetchTweets.count {
            fetchTweets[i].user = user
        }
    }
    
    @MainActor
    func getAmountTweet() async throws {
        guard let currentUid = UserService.shared.currentUser?.id else { return }
        let query = try await TweetService.getAmountDocumentsOfCollectionByUid(uid: currentUid)
        self.countAmountTweets = query
    }
}

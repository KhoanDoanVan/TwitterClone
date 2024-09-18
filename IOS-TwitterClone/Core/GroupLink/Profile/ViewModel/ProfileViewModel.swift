//
//  ProfileViewModel.swift
//  IOS-TwitterClone
//
//  Created by Đoàn Văn Khoan on 26/4/24.
//

import Foundation


class ProfileViewModel: ObservableObject {
    @Published var fetchTweets : [Tweet] = [Tweet]()
    @Published var tweets : [Tweet] = [Tweet]()
    @Published var countAmountTweets : Int = 0
    @Published var isLoading : Bool = false
    
    @Published var user : User?
    
    @MainActor
    func fetchMoreTweets() async throws {
        try await fetchTweets()
    }
    
    
    @MainActor
    func fetchTweets() async throws {
        guard let user = user else { return }
    
        self.fetchTweets = try await TweetService.fetchTweetsByUserOwnedUid(uid: user.id, limit : 5)
        
        try await fetchUserTweet(user: user)
        
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
        guard let user = user else { return }
        let query = try await TweetService.getAmountDocumentsOfCollectionByUid(uid: user.id)
        self.countAmountTweets = query
    }
}

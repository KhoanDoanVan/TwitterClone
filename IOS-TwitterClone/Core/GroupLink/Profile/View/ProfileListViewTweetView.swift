//
//  ProfileListViewTweetView.swift
//  IOS-TwitterClone
//
//  Created by Đoàn Văn Khoan on 26/4/24.
//

import SwiftUI

struct ProfileListViewTweetView: View {

    @StateObject var viewModel : ProfileViewModel
    
    var body: some View {
        ScrollView(showsIndicators : false) {
            LazyVStack {
                ForEach(viewModel.tweets) { tweet in
                    VStack {
                        Button {
                            
                        } label: {
                            TweetCellView(tweet: tweet)
                                .padding()
                                .onAppear {
                                    if (viewModel.tweets[viewModel.tweets.count - 1].id == tweet.id) && (viewModel.countAmountTweets > viewModel.tweets.count) {
                                        Task {
                                            try await viewModel.fetchMoreTweets()
                                            try await viewModel.getAmountTweet()
                                        }
                                    }
                                }
                        }
                        .foregroundStyle(.black)
                        
    
                        Divider()
                    }
                }
                
                if viewModel.isLoading {
                    ProgressView()
                        .padding()
                }
            }
        }
        .onAppear {
            Task {
                try await viewModel.getAmountTweet()
                try await viewModel.fetchTweets()
            }
        }
    }
}

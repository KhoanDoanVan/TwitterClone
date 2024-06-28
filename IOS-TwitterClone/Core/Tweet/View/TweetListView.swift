//
//  TweetListView.swift
//  IOS-TwitterClone
//
//  Created by Đoàn Văn Khoan on 17/04/2024.
//

import SwiftUI

struct TweetListView: View {

    @StateObject var viewModel : HomeViewModel
    let managerCache = CacheManager.shared
    
    var body: some View {
        ScrollView(showsIndicators : false) {
            LazyVStack {
                ForEach(viewModel.tweets) { tweet in
                    VStack {
                        Button {
                            viewModel.tweetDetail = tweet
                            viewModel.showTweetDetail.toggle()
                        } label: {
                            TweetCellView(tweet: tweet)
                                .padding()
                                .onAppear {
                                    if viewModel.tweets[viewModel.tweets.count - 1].id == tweet.id && viewModel.countAmountPost > viewModel.tweets.count {
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
                
                if viewModel.isLoadingTweetFetch {
                    ProgressView()
                        .padding()
                }
            }
        }
        .frame(maxWidth: (viewModel.tweetDetail != nil) ? 0 : .infinity, maxHeight: (viewModel.tweetDetail != nil) ? 0 : .infinity)
    }
}

//#Preview {
//    TweetListView()
//}

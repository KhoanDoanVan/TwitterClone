//
//  TweetListView.swift
//  IOS-TwitterClone
//
//  Created by Đoàn Văn Khoan on 17/04/2024.
//

import SwiftUI

struct ProfileCurrentListTweetView: View {

    @StateObject var viewModel : CurrentProfileViewModel

    
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
            TweetService.lastDocumentSnapshot = nil
            Task {
                try await viewModel.fetchTweets()
            }
        }
    }
}

//#Preview {
//    TweetListView()
//}

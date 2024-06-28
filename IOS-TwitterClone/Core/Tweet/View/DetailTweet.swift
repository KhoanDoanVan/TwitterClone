//
//  DetailTweet.swift
//  IOS-TwitterClone
//
//  Created by Đoàn Văn Khoan on 25/4/24.
//

import SwiftUI
import AVKit

struct DetailTweet: View {
    
    @StateObject var viewModel : HomeViewModel
    @StateObject var detailTweetViewModel = DetailTweetViewModel()
    @State private var tweet : Tweet?
    
    private let managerCache = CacheManager.shared
    
    var body: some View {
        NavigationStack{
            VStack {
                ZStack {
                    HStack {
                        Button {
                            viewModel.showTweetDetail.toggle()
                            viewModel.tweetDetail = nil
                        } label: {
                            Image(systemName: "chevron.backward")
                                .foregroundStyle(.blue)
                        }
                        .tint(.black)
                        Spacer()
                    }
                    Text("Tweet")
                        .fontWeight(.bold)
                }
                .padding(.horizontal)
                Spacer()
                GeometryReader { geometry in
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack {
                            HStack {
                                if let imageUrl = tweet?.user?.profileImageUrl {
                                    if let cachedImage = managerCache.getImage(imageUrl: imageUrl) {
                                        Image(uiImage: cachedImage)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 50, height: 50)
                                            .clipShape(Circle())
                                            .onAppear {
                                                print("using cache")
                                            }
                                    } else {
                                        RemoteImage(url: imageUrl)
                                        .scaledToFit()
                                        .frame(width: 50, height: 50)
                                        .clipShape(Circle())
                                        .onAppear {
                                            let uiImageView = UIImageView()
                                            uiImageView.loadImage(from: imageUrl) { uiimage in
                                                if let image = uiimage {
                                                    managerCache.addImage(imageUrl: imageUrl, values: image)

                                                }
                                            }
                                        }
                                    }
                                } else {
                                    Image("imageProfile")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 70, height: 70)
                                        .clipShape(Circle())
                                }
                                HStack(spacing : 0) {
                                    VStack(alignment : .leading, spacing : 0) {
                                        Text(tweet?.user?.fullname ?? "unknown")
                                            .fontWeight(.semibold)
                                        Text("@\(tweet?.user?.username.lowercased() ?? "unknown")")
                                            .foregroundStyle(Color(.systemGray))
                                    }
                                    Spacer()
                                    Button {
                                        
                                    } label: {
                                        Image(systemName: "chevron.down")
                                            .tint(.gray)
                                    }
                                }
                            }
                            .frame(width: UIScreen.main.bounds.width - 40)
                            VStack {
                                Text(tweet?.content ?? "unknown")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .font(.title3)
                                
                                if let imageUrl = tweet?.imageUrl {
                                    if let cachedImage = managerCache.getImage(imageUrl: imageUrl) {
                                        Image(uiImage: cachedImage)
                                            .resizable()
                                            .scaledToFit()
                                            .cornerRadius(10)
                                            .onAppear {
                                                print("using cache")
                                            }
                                    } else {
                                        RemoteImage(url: imageUrl)
                                        .scaledToFit()
                                        .cornerRadius(10)
                                        .onAppear {
                                            let uiImageView = UIImageView()
                                            uiImageView.loadImage(from: imageUrl) { uiimage in
                                                if let image = uiimage {
                                                    managerCache.addImage(imageUrl: imageUrl, values: image)
                                                }
                                            }
                                        }
                                    }
                                }
                                
                                if let videoUrl = tweet?.videoUrl {
                                    VideoPlayer(player: AVPlayer(url: URL(string: videoUrl)!))
                                        .frame(height: 250)
                                        .cornerRadius(10)
                                }
                                
                                HStack {
                                    HStack {
                                        if let createDate = tweet?.createDate {
                                            Text(createDate.formatted(date: .short, time: .short))
                                        } else {
                                            Text("Unknown Date")
                                        }
                                    }
                                    Spacer()
                                }
                                .foregroundStyle(Color(.systemGray))
                                .padding(.vertical, 10)
                                
                                Divider()
                                
                                HStack {
                                    if detailTweetViewModel.postObject?.reupload != 0 {
                                        Label {
                                            Text(detailTweetViewModel.postObject?.reupload ?? 0 > 1 ? "Retweets" : "Retweet")
                                                .foregroundStyle(Color(.systemGray))
                                        } icon: {
                                            Text("\(detailTweetViewModel.postObject?.reupload ?? 0)")
                                                .fontWeight(.semibold)
                                        }
                                    }
                                    
                                    if detailTweetViewModel.postObject?.likes != 0 {
                                        Label {
                                            Text(detailTweetViewModel.postObject?.likes ?? 0 > 1 ? "Likes" : "Like")
                                                .foregroundStyle(Color(.systemGray))
                                                .contentTransition(.numericText(value: CGFloat(detailTweetViewModel.postObject?.likes ?? 0)))
                                                .animation(.snappy, value: detailTweetViewModel.postObject?.likes ?? 0)
                                        } icon: {
                                            Text("\(detailTweetViewModel.postObject?.likes ?? 0)")
                                                .fontWeight(.semibold)
                                        }
                                    }
                                    
                                    if detailTweetViewModel.postObject?.comments != 0 {
                                        Label {
                                            Text("Quote Tweets")
                                                .foregroundStyle(Color(.systemGray))
                                        } icon: {
                                            Text("\(detailTweetViewModel.postObject?.comments ?? 0)")
                                                .contentTransition(.numericText(value: CGFloat(detailTweetViewModel.postObject?.comments ?? 0)))
                                                .animation(.snappy, value: detailTweetViewModel.postObject?.comments ?? 0)
                                                .fontWeight(.semibold)
                                        }
                                    }
                                    Spacer()
                                }
                                
                                Divider()
                                
                                HStack {
                                    buttonDetailTweet(icon: "message")
                                    buttonDetailTweet(icon: "paperplane")
                                    buttonDetailTweet(icon: "heart")
                                    buttonDetailTweet(icon: "square.and.arrow.up")
                                }
                                .padding(.vertical, 5)
                                
                                Divider()
                                
                                
                                // display list comments
                                if !detailTweetViewModel.fakeComments.isEmpty {
                                    ForEach(detailTweetViewModel.fakeComments) { comment in
                                        VStack{
                                            CommentCellView(comment: comment)
                                                
                                            Divider()
                                        }
                                    }
                                }
                                
                                if detailTweetViewModel.commentsLoading {
                                    ProgressView()
                                } else {
                                    ForEach(detailTweetViewModel.comments) { comment in
                                        VStack{
                                            CommentCellView(comment: comment)
                                            Divider()
                                        }
                                    }
                                }
                                
                            }
                            .frame(width: UIScreen.main.bounds.width - 40)
                        }
                        .frame(width: geometry.size.width)
                    }
                }
                Spacer()
                HStack {
                    if let cachedImage = managerCache.getImage(imageUrl: detailTweetViewModel.currentUser?.profileImageUrl ?? "") {
                        Image(uiImage: cachedImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width:50, height: detailTweetViewModel.openComment ? 50 : 0)
                            .clipShape(Circle())
                    } else {
                        RemoteImage(url: detailTweetViewModel.currentUser?.profileImageUrl ?? "")
                        .scaledToFit()
                        .frame(width:50, height: detailTweetViewModel.openComment ? 50 : 0)
                        .clipShape(Circle())
                        .onAppear {
                            let uiImageView = UIImageView()
                            uiImageView.loadImage(from: detailTweetViewModel.currentUser?.profileImageUrl ?? "") { uiimage in
                                if let image = uiimage {
                                    managerCache.addImage(imageUrl: detailTweetViewModel.currentUser?.profileImageUrl ?? "", values: image)
                                }
                            }
                        }
                    }
                    
                    ZStack{
                        TextField("", text: $detailTweetViewModel.commentContent, prompt: Text("Comment..."))
                            .frame(height: detailTweetViewModel.openComment ? 30 : 0)
                            .padding(.vertical, detailTweetViewModel.openComment ? 5 : 0)
                            .padding(.horizontal)
                            .padding(.trailing, 20)
                            .background(Color(.systemGray).opacity(0.06))
                            .clipShape(Capsule())
                        
                        HStack{
                            Spacer()
                            if !detailTweetViewModel.commentContent.isEmpty {
                                Button {
                                    Task {
                                        try await detailTweetViewModel.uploadCommentTweet(postId: tweet?.id ?? "")
                                    }
                                    withAnimation {
                                        detailTweetViewModel.openComment.toggle()
                                    }
                                } label: {
                                    Image(systemName: "arrow.up.circle")
                                        .foregroundStyle(Color.blueMain)
                                }
                                .padding(.trailing, 10)
                            }
                        }
                    }
                }
                .frame(height: detailTweetViewModel.openComment ? 50 : 0)
            }
            .onAppear {
                tweet = viewModel.tweetDetail
                
                detailTweetViewModel.readValue(tweetUid: tweet?.id ?? "")
                
                if !managerCache.getTweetLiked(uidTweet: tweet?.id ?? "") {
                    if detailTweetViewModel.checkedCacheLike == false {
                        detailTweetViewModel.checkLikeOrNotLike(tweetUid: tweet?.id ?? "")
                        detailTweetViewModel.checkedCacheLike.toggle()
                    } else {
                        detailTweetViewModel.checkedCacheLike.toggle()
                    }
                } else {
                    detailTweetViewModel.stateLike = true
                }
                
                Task {
                    try await detailTweetViewModel.fetchComments(tweetUid: tweet?.id ?? "")
                }
            }
        }
    }
    
    @ViewBuilder
    func buttonDetailTweet(icon : String) -> some View {
        Button {
            if icon == "heart" {
                Task {
                    detailTweetViewModel.setLikeOrUnlike(tweetUid: tweet?.id ?? "")
                    
                    try await detailTweetViewModel.updateLikeState(tweetUid: tweet?.id ?? "")
                }
            }
            
            if icon == "message" {
                withAnimation {
                    detailTweetViewModel.openComment.toggle()
                }
            }
        } label: {
            if icon == "heart" {
                Image(systemName: detailTweetViewModel.stateLike == false ? icon : "heart.fill")
                    .font(.title2)
                    .symbolEffect(.bounce, value: detailTweetViewModel.stateLike)
                    .contentTransition(.symbolEffect(.replace))
                    .foregroundStyle(detailTweetViewModel.stateLike == false ? .black : .red)
            } else {
                Image(systemName: icon)
                    .font(.title2)
            }
        }
        .frame(width : (UIScreen.main.bounds.width - 20) / 4 )
        .tint(.black)
        .opacity(0.6)
    }
}

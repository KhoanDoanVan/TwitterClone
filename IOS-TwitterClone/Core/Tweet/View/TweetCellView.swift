//
//  TweetCellView.swift
//  IOS-TwitterClone
//
//  Created by Đoàn Văn Khoan on 17/04/2024.
//

import SwiftUI
import AVKit

enum ActionTweet {
    case like, comment, reupload
}

struct TweetCellView: View {
    
    var tweet : Tweet
    let managerCache = CacheManager.shared
    @StateObject private var viewModel = TweetCellViewModel()
    @State private var nextLink : Bool = false
    
    var body: some View {
        HStack(alignment : .top) {
            if let profileImage = tweet.user?.profileImageUrl {
                NavigationLink {
                    if tweet.user?.id == UserService.shared.currentUser?.id {
                        CurrentProfileView(user: tweet.user!)
                    } else {
                        ProfileView(user: tweet.user!)
                    }
                    
                } label: {
                    
                    if let cachedImage = managerCache.getImage(imageUrl: profileImage) {
                        Image(uiImage: cachedImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width:50, height: 50)
                            .cornerRadius(50)
                    } else {
                        RemoteImage(url: profileImage)
                        .scaledToFit()
                        .frame(width:50, height: 50)
                        .cornerRadius(50)
                        .onAppear {
                            let uiImageView = UIImageView()
                            uiImageView.loadImage(from: profileImage) { uiimage in
                                if let image = uiimage {
                                    managerCache.addImage(imageUrl: profileImage, values: image)

                                }
                            }
                        }
                    }
                }
            } else {
                ZStack{
                    Image("imageProfile")
                        .resizable()
                        .frame(width:50, height: 50)
                        .cornerRadius(50)
                }
            }
            
            VStack{
                HStack {
                    Text(tweet.user?.fullname ?? "User")
                        .font(.system(size: 15))
                        .fontWeight(.semibold)
                    Text("@\(tweet.user?.username.localizedLowercase ?? "simonisdev")")
                        .foregroundStyle(Color(.systemGray))
                    Image(systemName: "circle.fill")
                        .font(.system(size: 3))
                        .foregroundStyle(Color(.systemGray))
                    Text(tweet.createDate.timeAgoSinceNow(date : tweet.createDate))
                        .foregroundStyle(Color(.systemGray))
                    
                    Spacer()
                    Button {
                        
                    } label: {
                        Image(systemName: "chevron.down")
                            .foregroundStyle(Color(.systemGray))
                    }
                }
                VStack{
                    Text(tweet.content)
                        .multilineTextAlignment(.leading)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                
                VStack{
                    
                    if let imageUrl = tweet.imageUrl {
                        if let cachedImage = managerCache.getImage(imageUrl: imageUrl) {
                            Image(uiImage: cachedImage)
                                .resizable()
                                .scaledToFit()
                                .cornerRadius(10)
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
                    
                    if let videoUrl = tweet.videoUrl {
                        ZStack{
                            VideoPlayer(player: AVPlayer(url: URL(string: videoUrl)!))
                                .frame(height: 250)
                                .cornerRadius(10)
                            Image(systemName: "play.fill")
                                .font(.title)
                                .foregroundStyle(Color.blueMain)
                        }
                    }

                    Spacer()
                }
                
                HStack {
                    buttonTweetCell(icon: "message", amount: viewModel.postObject?.comments ?? 0, action: .comment)
                    Spacer()
                    buttonTweetCell(icon: "paperplane", amount: viewModel.postObject?.reupload ?? 0, action: .reupload)
                    Spacer()
                    buttonTweetCell(icon: "heart", amount: viewModel.postObject?.likes ?? 0, action: .like)
                    Spacer()
                    Button {

                    } label: {
                        Image(systemName: "square.and.arrow.up")
                            .foregroundStyle(Color.primary)
                            .opacity(0.6)
                    }
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 5)
            }
        }
        .frame(maxWidth: .infinity)
        .onAppear {
            viewModel.readValue(uidTweet: tweet.id)
            
            if !managerCache.getTweetLiked(uidTweet: tweet.id) {
                if viewModel.checkCacheLiked == false {
                    viewModel.checkPostLikedOrNot(uidPost: tweet.id)
                    viewModel.checkCacheLiked.toggle()
                } else {
                    viewModel.checkCacheLiked.toggle()
                }
            } else {
                viewModel.likeState = true
            }
        }
    }
    
    @ViewBuilder
    func buttonTweetCell(icon : String, amount : Int, action : ActionTweet) -> some View {
        Button {
            switch action {
                
            case .like:
                Task {
                    withAnimation {
                        Task {
                            // set ui
                            viewModel.setLikeValueOrUnlike(uidTweet: tweet.id)
                            
                            // set database
                            try await viewModel.updateLikeDatabase(uidTweet: tweet.id)
                        }
                    }
                }
            case .comment:
                print("comment")
            case .reupload:
                print("reupload")
            }
        } label: {
            switch action {
            case .like:
                HStack(spacing : -5) {
                    Image(systemName: viewModel.likeState == false ? icon : "heart.fill")
                        .symbolEffect(.bounce, value: viewModel.likeState)
                        .contentTransition(.symbolEffect(.replace))
                        .foregroundStyle(viewModel.likeState == false ? .black : .red)
                    Text("\(amount)")
                        .foregroundStyle(viewModel.likeState == false ? .black : .red)
                        .contentTransition(.numericText(value: CGFloat(amount)))
                        .animation(.snappy, value: amount)
                        .frame(width: 35)
                }
            case .comment:
                HStack(spacing : -5) {
                    Image(systemName: icon)
                    Text("\(amount)")
                        .frame(width: 35)
                }
            case .reupload:
                HStack(spacing : -5) {
                    Image(systemName: icon)
                    Text("\(amount)")
                        .frame(width: 35)
                }
            }
        }
        .foregroundColor(.primary)
        .opacity(0.6)
    }
}


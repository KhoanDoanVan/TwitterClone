//
//  ProfileView.swift
//  IOS-TwitterClone
//
//  Created by Đoàn Văn Khoan on 15/04/2024.
//

import SwiftUI

struct CurrentProfileView: View {
    @Namespace var animate
    @Environment(\.dismiss) private var dismiss
    let user : User
    @State private var isShowSheet : Bool = false
    private let managerCache = CacheManager.shared
    
    @State private var selectedFilter : ProfileTwitterFilter = .tweets
    
    @StateObject private var viewModel = CurrentProfileViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                
                if let backgroundImageUrl = user.backgroundImageUrl {
                    if let cachedImage = managerCache.getImage(imageUrl: backgroundImageUrl) {
                        Image(uiImage: cachedImage)
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: .infinity, maxHeight: 200)
                            .onAppear {
                                print("using cache")
                            }
                    } else {
                        RemoteImage(url: backgroundImageUrl)
                        .scaledToFit()
                        .frame(maxWidth: .infinity, maxHeight: 200)
                        .onAppear {
                            let uiImageView = UIImageView()
                            uiImageView.loadImage(from: backgroundImageUrl) { uiimage in
                                if let image = uiimage {
                                    managerCache.addImage(imageUrl: backgroundImageUrl, values: image)

                                }
                            }
                        }
                    }
                } else {
                    ZStack{
                        Rectangle()
                            .frame(maxWidth: .infinity, maxHeight: 200)
                            .foregroundStyle(Color(.systemGray3))
                        Image(systemName: "photo.badge.plus")
                            .font(.system(size: 50))
                            .foregroundStyle(Color(.systemGray))
                    }
                }
                
                HStack {
                    VStack(alignment : .leading){
                        ZStack {
                            Circle()
                                .frame(width: 80)
                                .foregroundStyle(.white)
                            
                            if let imageUrl = user.profileImageUrl {
                                if let cachedImage = managerCache.getImage(imageUrl: imageUrl) {
                                    Image(uiImage: cachedImage)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 70, height: 70)
                                        .cornerRadius(50)
                                        .onAppear {
                                            print("using cache")
                                        }
                                } else {
                                    RemoteImage(url: imageUrl)
                                    .scaledToFit()
                                    .frame(width: 70, height: 70)
                                    .cornerRadius(50)
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
                                ZStack{
                                    Image("imageProfile")
                                        .resizable()
                                        .frame(width: 70, height: 70)
                                        .cornerRadius(50)
                                }
                            }
                        }
                        VStack(alignment : .leading, spacing : 0){
                            Text(user.fullname)
                                .font(.title)
                                .fontWeight(.semibold)
                            Text("@\(user.username.lowercased(with: .autoupdatingCurrent))")
                                .foregroundStyle(Color(.systemGray))
                        }
                    }
                    
                    Spacer()
                    
                    Button {
                        isShowSheet.toggle()
                    } label: {
                        Text("Edit profile")
                            .padding(.vertical, 5)
                            .padding(.horizontal, 10)
                            .font(.footnote)
                            .fontWeight(.bold)
                            .overlay {
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color(.blue), lineWidth : 1)
                            }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, -50)
                
                VStack(alignment : .leading, spacing : 5){
                    Text("Digital Goodies Team - Web & Mobile UI/UX development; Graphics; Illustrations")
                        
                    HStack{
                        Image(systemName: "calendar")
                            .foregroundStyle(Color(.systemGray))
                        Text("Joined April 2024")
                            .font(.footnote)
                            .foregroundStyle(Color(.systemGray))
                    }
                    
                }
                .frame(maxWidth: .infinity, alignment : .leading)
                .padding(.horizontal, 20)
                
                HStack(alignment : .firstTextBaseline){
                    HStack(spacing : 5){
                        Text("\(user.following?.count ?? 0)")
                            .fontWeight(.semibold)
                        Text("Following")
                            .foregroundStyle(Color(.systemGray))
                    }
                    
                    HStack(spacing : 5){
                        Text("\(user.followers?.count ?? 0)")
                            .fontWeight(.semibold)
                        Text("Followers")
                            .foregroundStyle(Color(.systemGray))
                    }
                    Spacer()
                }
                .padding(.top, 5)
                .padding(.horizontal, 20)
                
                ZStack{
                    HStack(spacing : 0) {
                        ForEach(ProfileTwitterFilter.allCases) { filter in
                            VStack(spacing : 0) {
                                Text(filter.title)
                                    .font(.system(size: 18))
                                    .fontWeight(.semibold)
                                    .foregroundStyle(selectedFilter == filter ? Color.blueMain : .gray)
                                
                                if selectedFilter == filter {
                                    Rectangle()
                                        .frame(maxWidth: .infinity, maxHeight : 2)
                                        .foregroundStyle(Color.blueMain)
                                        .matchedGeometryEffect(id: "item", in: animate)
                                } else {
                                    Rectangle()
                                        .frame(maxWidth: .infinity, maxHeight : 2)
                                        .foregroundStyle(Color.white)
                                }
                            }
                            .onTapGesture {
                                withAnimation {
                                    selectedFilter = filter
                                }
                            }
                        }
                    }
                    Divider()
                        .padding(.top, 25)
                }
                
                ProfileCurrentListTweetView(viewModel: viewModel)
                
                Spacer()
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement : .topBarLeading) {
                    Button {
                        dismiss()
                        TweetService.lastDocumentSnapshot = nil
                    } label: {
                        Image(systemName: "chevron.left")
                            .foregroundStyle(.white)
                    }
                    .padding()
                }
            }
            .sheet(isPresented: $isShowSheet, content: {
                EditProfileView(user: user)
            })
            .ignoresSafeArea()
        }
    }
}

#Preview {
    CurrentProfileView(user : User(id: UUID().uuidString, email: "doanvankhoan@gmail.com", username: "Simonisdev", fullname: "Doan Van Khoan"))
}

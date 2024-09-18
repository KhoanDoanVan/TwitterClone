//
//  SideBarView.swift
//  IOS-TwitterClone
//
//  Created by Đoàn Văn Khoan on 16/04/2024.
//

import SwiftUI

struct SideBarView: View {
    
    let user : User
    @Binding var showMenu : Bool
    private let managerCache = CacheManager.shared
    
    var body: some View {
        VStack {
            HStack {
                if let imageUrl = user.profileImageUrl {
                    if let cachedImage = managerCache.getImage(imageUrl: imageUrl) {
                        Image(uiImage: cachedImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                            .cornerRadius(10)
                            .onAppear {
                                print("using cache")
                            }
                    } else {
                        RemoteImage(url: imageUrl)
                        .scaledToFit()
                        .frame(width: 50, height: 50)
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
                } else {
                    ZStack{
                        Image("imageProfile")
                            .resizable()
                            .frame(width: 70, height: 70)
                            .cornerRadius(50)
                    }
                }
                Spacer()
                Menu {
                    Section {
                        Button {
                            Task {
                                try AuthService.shared.signOut()
                            }
                            TweetService.lastDocumentSnapshot = nil
                            CacheManager.shared.clearAllData()
                        } label: {
                            Text("Sign out")
                        }
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .font(.title)
                        .foregroundStyle(.blueMain)
                }
            }
            
            VStack(alignment : .leading){
                Text(user.fullname)
                    .font(.title2)
                    .fontWeight(.semibold)
                Text("@\(user.username.lowercased(with: .autoupdatingCurrent))")
                    .font(.title3)
                    .foregroundStyle(Color(.systemGray))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack {
                Button {
                    
                } label: {
                    Label {
                        Text("Following")
                            .foregroundStyle(Color(.systemGray))
                    } icon: {
                        Text("\(user.following?.count ?? 0)")
                            .fontWeight(.semibold)
                    }
                }
                
                Button {
                    
                } label: {
                    Label {
                        Text("Followers")
                            .foregroundStyle(Color(.systemGray))
                    } icon: {
                        Text("\(user.followers?.count ?? 0)")
                            .fontWeight(.semibold)
                    }
                }
                Spacer()
            }
            .foregroundStyle(.primary)
            
            VStack(alignment : .leading, spacing : 20){
                buttonSideBar(title: "Profile", icon: "person", view: CurrentProfileView(user : user))
                buttonSideBar(title: "Lists", icon: "list.bullet.clipboard", view: ListView())
                buttonSideBar(title: "Topics", icon: "ellipsis.message", view: TopicView())
                buttonSideBar(title: "Bookmarks", icon: "bookmark", view: BookmarkView())
                buttonSideBar(title: "Moments", icon: "tag", view: MomentView())
            }
            .padding([.top])
            
            Divider()
            
            VStack(alignment : .leading){
                Button {
                    
                } label: {
                    Text("Settings and privacy")
                        .font(.title2)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                Button {
                    
                } label: {
                    Text("Help Center")
                        .font(.title2)
                        .foregroundStyle(.primary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .foregroundStyle(.primary)
            
            Spacer()
            HStack {
                Button{
                    
                } label: {
                    Image(systemName: "lightbulb.max")
                        .font(.title)
                        .foregroundStyle(.blueMain)
                }
                Spacer()
                Button{
                    
                } label: {
                    Image(systemName: "qrcode")
                        .font(.title)
                        .foregroundStyle(.blueMain)
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(width: getRect().width - 90)
        .frame(maxHeight: .infinity)
    }
    
    @ViewBuilder
    func buttonSideBar(title : String, icon : String,view : some View) -> some View {
        NavigationLink{
            view
        } label: {
            Label {
                Text(title)
                    .font(.title2)
                    .foregroundColor(.primary)
            } icon: {
                Image(systemName: icon)
                    .font(.title)
                    .foregroundStyle(Color(.systemGray))
                    .frame(width: 30, height: 40)
                    .padding(.trailing, 10)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    SideBarView(user : User(id: UUID().uuidString, email: "simonisdev", username: "simonisdev", fullname: "Simonisdev"),showMenu: .constant(true))
}

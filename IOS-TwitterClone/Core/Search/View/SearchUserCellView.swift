//
//  SearchUserCellVuew.swift
//  IOS-TwitterClone
//
//  Created by Đoàn Văn Khoan on 26/4/24.
//

import SwiftUI

struct SearchUserCellView: View {
    
    let user : User
    
    @State private var isLoading : Bool = false
    @State private var isFollow : Bool?
    
    var body: some View {
        NavigationLink {
            ProfileView(user : user)
        } label: {
            HStack {
                HStack(spacing : 20) {
                    if let profileImage = user.profileImageUrl {
                        RemoteImage(url: "\(profileImage)")
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                            .cornerRadius(50)
                    } else {
                        ZStack{
                            Image("imageProfile")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .cornerRadius(50)
                        }
                    }
                    VStack(alignment : .leading, spacing : 0) {
                        Text(user.fullname)
                            .font(.system(size: 18))
                            .fontWeight(.semibold)
                        Text("@\(user.username.localizedLowercase)")
                            .opacity(0.6)
                    }
                    .frame(maxWidth: .infinity, alignment : .leading)
                }
                
                
                // button follow
                Button {
                    withAnimation {
                        if isLoading == false {
                            if isFollow == true {
                                isLoading = true
                                Task {
                                    try await UserService.shared.unfollowUserUid(userUid: user.id)
                                    isFollow?.toggle()
                                }
                            } else {
                                Task {
                                    try await UserService.shared.followUserUid(userUid: user.id)
                                    guard let userCurrent = UserService.shared.currentUser?.id else { return }
                                    try await NotificationService.sendNotification(notification: Notification(id: UUID().uuidString, toId: user.id,fromId: userCurrent, type: NotificationType.follow))
                                    isFollow?.toggle()
                                }
                            }
                            isLoading = false
                            print("click")
                        }
                    }
                } label: {
                    
                    if isLoading == true  {
                        Rectangle()
                            .frame(width : 100, height : 30)
                            .overlay {
                                ProgressView()
                            }
                            .cornerRadius(20)
                            .foregroundStyle(Color(.blueMain))
                    } else {
                        Rectangle()
                            .frame(width : 100, height : 30)
                            .overlay {
                                Text(isFollow == true ? "Followed" : "Follow")
                                    .foregroundStyle(.white)
                                    .fontWeight(.semibold)
                            }
                            .cornerRadius(20)
                            .foregroundStyle(isFollow == true ? Color(.systemGray4) : Color(.blueMain))
                    }
                        
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal)
        .foregroundStyle(.primary)
        .onAppear {
            let userCurrent = UserService.shared.currentUser
            if userCurrent?.following?.contains(user.id) == true {
                isFollow = true
            } else {
                isFollow = false
            }
        }
    }
}

//
//  BaseView.swift
//  IOS-TwitterClone
//
//  Created by Đoàn Văn Khoan on 16/04/2024.


import SwiftUI

extension View {
    func getRect() -> CGRect {
        return UIScreen.main.bounds
    }
}

struct BaseView: View {
    @StateObject private var viewModel = BaseViewModel()
    @State private var showMenu : Bool = false
    
    init() {
        UITabBar.appearance().isHidden = true
    }
    
    @State private var currentTab : String = "house"
    
    @State private var offset : CGFloat = 0
    @State private var lastStoredOffset : CGFloat = 0
    
    var body: some View {
        
        let sideBarWidth = getRect().width - 90
        
        NavigationStack {
            HStack(spacing : 0) {
                // Side Menu
                SideBarView(user : viewModel.currentUser ?? User(id: UUID().uuidString, email: "doanvankhoan124@gmail.com", username: "simonsidev", fullname: "Doan Van Khoan"), showMenu : $showMenu)
                
                VStack(spacing : 0) {
                    TabView(selection : $currentTab) {
                        HomeView(showMenu: $showMenu, user : viewModel.currentUser)
                            .tag("house")
                        SearchView()
                            .tag("magnifyingglass")
                        NotificationView()
                            .tag("bell")
                        MessageView(user : viewModel.currentUser)
                            .tag("envelope")
                    }
                    
                    VStack{
                        Divider()
                        HStack{
                            buttonTabBar(image: "house")
                            buttonTabBar(image: "magnifyingglass")
                            buttonTabBar(image: "bell")
                            buttonTabBar(image: "envelope")
                        }
                        .padding([.top], 15)
                    }
                }
                .frame(width: getRect().width)
                .overlay (
                    Rectangle()
                        .fill(
                            Color.primary.opacity(Double(offset / sideBarWidth / 5))
                        )
                        .ignoresSafeArea(.container, edges: .vertical)
                        .onTapGesture {
                            withAnimation {
                                showMenu.toggle()
                            }
                        }
                )
            }
            .frame(width: getRect().width + sideBarWidth)
            .offset(x : -sideBarWidth / 2)
            .offset(x : offset)
            .animation(.easeInOut, value: offset == 0)
            .navigationBarBackButtonHidden(true)
        }
        .onChange(of: showMenu) {
            if showMenu && offset == 0 {
                offset = sideBarWidth
                lastStoredOffset = offset
            }
            
            if !showMenu && offset == sideBarWidth {
                offset = 0
                lastStoredOffset = 0
            }
        }
    }
    
    @ViewBuilder
    func buttonTabBar(image : String) -> some View {
        Button {
            withAnimation {
                currentTab = image
            }
        } label: {
            Image(systemName: image)
                .foregroundStyle(currentTab == image ? .blueMain : .gray)
                .environment(\.symbolVariants, currentTab == image ? .fill : .none)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    BaseView()
}


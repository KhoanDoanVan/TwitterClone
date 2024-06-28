//
//  SearchView.swift
//  IOS-TwitterClone
//
//  Created by Đoàn Văn Khoan on 16/04/2024.
//

import SwiftUI

struct SearchView: View {
    
    @StateObject private var viewModel = SearchViewModel()
    
    var body: some View {
        VStack{
            NavbarSearchView(search: $viewModel.search)
            ScrollView {
                LazyVStack {
                    ForEach(viewModel.users) { user in
                        VStack {
                            SearchUserCellView(user: user)
                            
                            Divider()
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    SearchView()
}

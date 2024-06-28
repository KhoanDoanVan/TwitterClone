//
//  NavbarSearch.swift
//  IOS-TwitterClone
//
//  Created by Đoàn Văn Khoan on 16/04/2024.
//

import SwiftUI

struct NavbarSearchView: View {
    
    @Binding var search : String
    
    var body: some View {
        ZStack{
            TextField("Search", text: $search)
                .padding(.horizontal)
                .padding(.vertical, 5)
                .padding(.trailing, 15)
                .frame(width: getRect().width - 40)
                .background(Color(.systemGray5))
                .cornerRadius(10)
                .padding(.vertical)
            if !search.isEmpty {
                Button {
                    withAnimation {
                        search = ""
                    }
                } label: {
                    Image(systemName: "xmark.circle.fill")
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.trailing, 30)
            }
        }
    }
}

#Preview {
    NavbarSearchView(search: .constant(""))
}

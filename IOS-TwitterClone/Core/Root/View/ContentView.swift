//
//  ContentView.swift
//  IOS-TwitterClone
//
//  Created by Đoàn Văn Khoan on 15/04/2024.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var viewModel = ContentViewModel()
    
    var body: some View {
        Group {
            if viewModel.userSession != nil {
                BaseView()
            } else {
                LoginView()
            }
        }
    }
}

#Preview {
    ContentView()
}

//
//  TwitterTextFieldModifier.swift
//  IOS-TwitterClone
//
//  Created by Đoàn Văn Khoan on 15/04/2024.
//

import SwiftUI

struct TwitterTextFieldModifier: ViewModifier {
    func body(content : Content) -> some View {
        content
            .font(.subheadline)
            .padding(22)
            .background(Color(.systemGray6))
            .cornerRadius(10)
            .padding(.horizontal, 25)
    }
}

//
//  MainButton.swift
//  Movia
//
//  Created by Sedat on 22.05.2025.
//

import SwiftUI

struct MainButton: View {
    var title: String
    var backgroundColor: Color = .blue
    var iconName: String? = nil
    var isLoading: Bool = false
    var isDisabled: Bool = false
    var action: () -> Void

    var body: some View {
        Button(action: {
            if !isLoading {
                action()
            }
        }) {
            HStack {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                } else {
                    if let iconName = iconName {
                        Image(systemName: iconName)
                            .foregroundColor(.white)
                    }
                    Text(title)
                        .foregroundColor(.white)
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(isDisabled ? Color.gray : backgroundColor)
            .cornerRadius(8)
            .opacity(isDisabled || isLoading ? 0.9 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(isDisabled || isLoading)
    }
}

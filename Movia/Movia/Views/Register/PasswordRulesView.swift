//
//  PasswordRulesView.swift
//  Movia
//
//  Created by Sedat on 22.05.2025.
//

import SwiftUI

struct PasswordRulesView: View {
    let password: String

    private var rules: [(String, Bool)] {
        PasswordValidator.validate(password: password)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            ForEach(rules, id: \.0) { rule, isValid in
                HStack(spacing: 6) {
                    Image(systemName: isValid ? "checkmark.circle.fill" : "xmark.circle")
                        .foregroundColor(isValid ? .green : .red)
                    Text(rule)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(.leading, 4)
    }
}

struct PasswordValidator {
    static func validate(password: String) -> [(String, Bool)] {
        return [
            ("En az 1 büyük harf", password.range(of: "[A-Z]", options: .regularExpression) != nil),
            ("En az 1 rakam", password.range(of: "[0-9]", options: .regularExpression) != nil),
            ("En az 8 karakter", password.count >= 8)
        ]
    }
}

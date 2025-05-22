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
                    Image(systemName: isValid ? IconNames.valid : IconNames.notValid)
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
            (Strings.atLeastOneBig, password.range(of: "[A-Z]", options: .regularExpression) != nil),
            (Strings.atLeastOneFigure, password.range(of: "[0-9]", options: .regularExpression) != nil),
            (Strings.atLeast8Characters, password.count >= 8)
        ]
    }
}

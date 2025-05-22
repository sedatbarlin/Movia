//
//  EmailRulesView.swift
//  Movia
//
//  Created by Sedat on 22.05.2025.
//

import SwiftUI

struct EmailValidationView: View {
    let email: String

    private var rules: [(String, Bool)] {
        return [
            ("Boşluk içermemeli", !email.contains(" ")),
            ("@ işareti içermeli", email.contains("@"))
        ]
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

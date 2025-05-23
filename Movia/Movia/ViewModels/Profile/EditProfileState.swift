//
//  EditProfileState.swift
//  Movia
//
//  Created by Sedat on 23.05.2025.
//

import Foundation

struct EditProfileState {
    var name: String = ""
    var surname: String = ""
    var email: String = ""
    var password: String = ""
    var isLoading: Bool = false
    var errorMessage: String? = nil
    var isSuccess: Bool = false
} 

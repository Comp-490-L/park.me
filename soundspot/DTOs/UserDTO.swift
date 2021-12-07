//
//  UserSignUpDTO.swift
//  soundspot
//
//  Created by Yassine Regragui on 11/11/21.
//

import Foundation
// Data transfer object
struct UserSignUpDTO : Codable{
    let email : String
    let username: String
    let password : String
    let confirmPassword : String
}

struct UserLoginDTO : Codable{
    let email: String
    let password : String
}

enum UserValidationError: Error {
    case invalidEmail(reason : String)
    case invalidUsername(reason : String)
    case invalidPassword(reason : String)
    case invalidUserId(reason : String)
    case confirmPasswordDoesNotMatch(reason : String)
}

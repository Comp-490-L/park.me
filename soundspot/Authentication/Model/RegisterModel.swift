//
//  Register.swift
//  soundspot
//
//  Created by Yassine Regragui on 11/7/21.
//

import Foundation

struct RegisterModel{
    var email : String
    var username: String
    var password : String
    var confirmPassword : String
    
    init(){
        email = ""
        username = ""
        password = ""
        confirmPassword = ""
    }
}

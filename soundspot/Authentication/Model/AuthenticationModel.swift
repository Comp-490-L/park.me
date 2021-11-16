//
//  Authentication.swift
//  soundspot
//
//  Created by Yassine Regragui on 11/10/21.
//

import Foundation

struct AuthenticationModel{
    
    /*var loginModel : LoginModel
    var registerModel : RegisterModel
    // used to show either login or sign up forms
    var formType : FormType
    
    init(){
        loginModel = LoginModel()
        registerModel = RegisterModel()
        // used to show either login or sign up forms
        formType = FormType.login
    }*/
    
    
    
    struct LoginModel : Identifiable{
        var id: String = "loginId"
        var username : String = ""
        var password : String = ""
        var hidePassword : Bool = true
        var usernameError = ""
        var passwordError = ""
        
        func AsLoginDTO() -> UserLoginDTO{
            return UserLoginDTO(Email: username, Password: password)
        }
    }
    
    struct SignUpModel : Identifiable{
        var id : String = "SignUpId"
        var email : String = ""
        var username: String = ""
        var password : String = ""
        var confirmPassword : String = ""
        var hidePassword : Bool = true
        var hideConfimPassword : Bool = true
        var emailError = ""
        var usernameError = ""
        var passwordError = ""
        var confirmPasswordError = ""
        
        func AsUserSignUpDTO() -> UserSignUpDTO{
            return UserSignUpDTO(email: email, username: username, password: password, confirmPassword: confirmPassword)
        }
    }
    
    enum FormType{
        case login
        case signup
    }
}

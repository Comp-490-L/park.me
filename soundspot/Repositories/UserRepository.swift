//
//  UserRepository.swift
//  soundspot
//
//  Created by Yassine Regragui on 11/11/21.
//

import Foundation

struct UserRepository{
    private var service = UserService()
    func createUser(user: UserSignUpDTO) throws -> Bool{
        var result : AuthResult?
        var success = false
        do {
            result = try service.createUserInRemoteDataSource(user: user)
        }catch{
            throw UserRepositoryError.UnableToCreateUser(errors: nil)
        }
        
        if(result!.errors != nil){
            throw UserRepositoryError.UnableToCreateUser(errors: result!.errors)
        }
        success = result!.success
        return success
    }
    
    
    func logInUser(user: UserLoginDTO) throws -> Bool {
        /*if(user.userId == ""){
            throw UserValidationError.invalidUserId(reason: "Username or email cannot be empty")
        }
        if(user.password == ""){
            throw UserValidationError.invalidPassword(reason: "Password cannot be empty")
        }*/
        
        return true
    }
}

enum UserRepositoryError: Error{
    case UnableToCreateUser(errors: AuthResult.Errors?)
}

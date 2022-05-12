//
//  UserRepository.swift
//  soundspot
//
//  Created by Yassine Regragui on 11/11/21.
//

import Foundation
import RealmSwift

struct UserAuthRepository{
    private var service = UserService()
    func createUser(_ user: UserSignUpDTO) throws -> Bool{
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
        
        if(result?.token != nil && result?.refreshToken != nil){
            do{
                try saveToken(token: (result?.token)!, refreshToken: (result?.refreshToken)!)
            }catch{}
            
            updateAppState()
        }
        
        success = result!.success
        return success
    }
    
    func removeSavedTokens(){
        do{
            try saveToken(token: "", refreshToken: "")
        }catch{}
    }
    
    private func saveToken(token : String, refreshToken: String) throws{
        
            let realm = try Realm()
            let tokenCollection = realm.objects(TokenData.self)
            
                let tokenData = TokenData(token: token, refreshToken: refreshToken)
                if(tokenCollection.count == 0){
                    try realm.write{
                        realm.add(tokenData)
                    }
                }else{
                    if let savedToken = tokenCollection.first{
                        try realm.write{
                            savedToken.token = tokenData.token
                            savedToken.refreshToken = tokenData.refreshToken
                        }
                    }
                }
    }
    
    private func updateAppState(){
        let appState = AppStateRepository()
        appState.updateAppStateAsync(appState: AppState(firstLaunch: false, userLoggedIn: true))
    }
    
    
    func logInUser(_ user: UserLoginDTO) throws -> Bool {
        if(user.email == ""){
            throw UserValidationError.invalidUserId(reason: "Username or email cannot be empty")
        }
        if(user.password == ""){
            throw UserValidationError.invalidPassword(reason: "Password cannot be empty")
        }
        var result : AuthResult?
        var success = false
        do{
            result = try service.AuthUserInRemoteDataSource(user: user)
        }catch{
            throw UserRepositoryError.UnableToAuthUser(errors: nil)
        }
        
        if(result?.errors != nil){
            throw UserRepositoryError.UnableToAuthUser(errors: result!.errors)
        }
        
        if(result?.token != nil && result?.refreshToken != nil){
            do{
                try saveToken(token: (result?.token)!, refreshToken: (result?.refreshToken)!)
            }catch{}
            
            updateAppState()
        }
        success = result!.success
        return success
    }
    
    
    private func InsertToken(){}
    
    static func getToken() -> String{
        do{
            let realm = try Realm()
            let tokenCollection = realm.objects(TokenData.self)
            if(tokenCollection.count == 0){
                return ""
            }
            else{
                return tokenCollection.first?.token ?? ""
            }
        }catch{}
        return ""
    }
}

enum UserRepositoryError: Error{
    case UnableToCreateUser(errors: AuthResult.Errors?)
    case UnableToAuthUser(errors: AuthResult.Errors?)
}

//
//  UserService.swift
//  soundspot
//
//  Created by Yassine Regragui on 11/13/21.
//

import Foundation

struct UserService{
    func createUserInRemoteDataSource(user: UserSignUpDTO) throws -> AuthResult{
        var result : AuthResult?
        guard let encoded = try? JSONEncoder().encode(user)
        else{
            print("Error encoding user")
            throw APIServiceError.FailedToSendRequest(reason: "Error encoding user")
        }
        
        print(String(data: encoded, encoding: .utf8)!)
        
        let sem = DispatchSemaphore.init(value: 0)
        
        let url = URL(string: "http://127.0.0.1:5000/Register")!
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = encoded
        
        //print("Sending request \n")
        let instance = session()
        let urlSession = URLSession(configuration: URLSessionConfiguration.default, delegate: instance, delegateQueue: nil)
        
        var responseError : Error?
        var httpResponse : HTTPURLResponse?
        
        urlSession.dataTask(with: request, completionHandler:{
            data, response, error in
            defer { sem.signal() }
            //print("Waiting for Response...")
            
            httpResponse = response as? HTTPURLResponse
            
            if let data = data {
                if let decoded = try? JSONDecoder().decode(AuthResult.self, from: data){
                    //print("Decoded the response, Request was Successful?: \(decoded.success)")
                    //print(String(data: data, encoding: .utf8))
                    result = decoded
                    
                }else{
                    //print("Unable to decode response")
                    //print(String(data: data, encoding: .utf8))
                }
            }else{
                responseError = error
                //print("Error getting data: \(error?.localizedDescription)")
            }
            
        }).resume()
        // used to wait for response when the task is finished
        sem.wait()
        
        if(httpResponse != nil){
            if(httpResponse?.statusCode == 500){
                throw APIServiceError.InvalidResponse(reason: "Internal server error")
            }
        }
        if(result == nil){
            print("Response is null")
            throw APIServiceError.InvalidResponse(reason: responseError?.localizedDescription ?? "Unknown error")
        }
        print("Received response success \(result!.success)")
        return result!
    }
}

struct AuthResult : Codable{
    init(token: String?, refreshToken: String?, success : Bool, errors: AuthResult.Errors?){
        self.token = token
        self.refreshToken = refreshToken
        self.success = success
        self.errors = errors
    }
    let token: String?
    let refreshToken: String?
    let success : Bool
    let errors : AuthResult.Errors?
    struct Errors : Codable{
        let username : String?
        let password : String?
        let email : String?
        let confirmPassword: String?
        let somethingWentWrong: String?
    }
}

enum APIServiceError: Error{
    case FailedToSendRequest(reason: String)
    case InvalidResponse(reason: String)
}


class session : NSObject, URLSessionDelegate{
    public func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
           //Trust the certificate even if not valid
           let urlCredential = URLCredential(trust: challenge.protectionSpace.serverTrust!)

           completionHandler(.useCredential, urlCredential)
        }
}

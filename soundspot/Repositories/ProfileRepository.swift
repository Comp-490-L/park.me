//
//  UserProfileRepository.swift
//  soundspot
//
//  Created by Yassine Regragui on 2/18/22.
//

import Foundation

struct ProfileRepository{
    
    func getUserProfile(completion: @escaping (Swift.Result<ProfileModel, Error>) -> Void){
        let url = URL(string: "\(Server.url)/api/Profile")!
        let task = DataTaskRequest()
        
        task.sendRequest(body: nil, url: url, method: "GET"){ data, response, error in
            let httpResponse = response as? HTTPURLResponse
			print("Profile RespCode: \(String(describing: httpResponse?.statusCode))")
            if let data = data {
                if let decoded = try? JSONDecoder().decode(ProfileModel.self, from: data){
                    completion(.success(decoded))
                }else{
                    completion(.failure(ProfileRepositoryError.UnableToDecodeResponse))
                    print("Unable to decode response")
                    print(String(data: data, encoding: .utf8)!)
                }
            }else{
                print("Error getting data: \(error?.localizedDescription ?? "Error is nil")")
                completion(.failure(error ?? ProfileRepositoryError.ResponseError))
            }
        }
    }
    
    func getPicture(url : URL, completion: @escaping (Swift.Result<Data, Error>) -> Void){
        let task = DataTaskRequest()
        task.sendRequest(body: nil, url: url, method: "GET"){ data, response, error in
            if let data = data {
                completion(.success(data))
            }else{
                completion(.failure(error ?? ProfileRepositoryError.ResponseError))
            }
        }
    }
}

enum ProfileRepositoryError : Error{
    case UnableToDecodeResponse
    case ResponseError
}


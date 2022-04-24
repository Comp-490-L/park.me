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
	
	func addTrackToLiked(trackId : String, completion: @escaping (Swift.Result<Void, Error>) -> Void){
		let url = URL(string: "\(Server.url)/api/likedTrack?trackId=\(trackId)")
		if let url = url {
			updateLiked(url: url, method: "POST", completion: completion)
		}else{
			completion(.failure(ProfileRepositoryError.UrlError))
		}
	}
	
	func addAlbumToLiked(albumId : String, completion: @escaping (Swift.Result<Void, Error>) -> Void){
		let url = URL(string: "\(Server.url)/api/likedAlbum?albumId=\(albumId)")
		if let url = url {
			updateLiked(url: url, method: "POST", completion: completion)
		}else{
			completion(.failure(ProfileRepositoryError.UrlError))
		}
	}
	
	private func updateLiked(url: URL, method: String, completion: @escaping (Swift.Result<Void, Error>) -> Void){
		let task = DataTaskRequest()
		task.sendRequest(body: nil, url: url, method: method){ data, response, error in
			if let httpResponse = response as? HTTPURLResponse{
				if(httpResponse.statusCode == 200){
					completion(.success(Void()))
				}else{
					completion(.failure(ProfileRepositoryError.ResponseError))
				}
			}else{
				completion(.failure(ProfileRepositoryError.ResponseError))
			}
		}
	}
	
	func removeTrackFromLiked(){
		
	}
    
}

enum ProfileRepositoryError : Error{
    case UnableToDecodeResponse
    case ResponseError
	case UrlError
}


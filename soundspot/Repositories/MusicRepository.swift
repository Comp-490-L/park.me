//
//  MusicRepository.swift
//  soundspot
//
//  Created by Yassine Regragui on 3/27/22.
//

import Foundation

struct MusicRepository{
	
	func getPicture(url : URL, completion: @escaping (Swift.Result<Data, Error>) -> Void){
		let task = DataTaskRequest()
		task.sendRequest(body: nil, url: url, method: "GET"){ data, response, error in
			if let data = data {
				completion(.success(data))
			}else{
				completion(.failure(error ?? ProfileRepositoryError.ResponseError))
			}
		}
		
		dataTask(url: url, method: "GET", body: nil){ result in
			switch(result){
			case .success(let data):
				completion(.success(data))
			case .failure(let error):
				completion(.failure(error))
			}
		}
	}
	
	func getAlbumTracks(url : URL, completion: @escaping (Swift.Result<[Track], Error>) -> Void){
		dataTask(url: url, method: "GET", body: nil){ result in
			switch(result){
			case .success(let data):
				do{
					let tracks = try JSONDecoder().decode([Track].self, from: data)
					completion(.success(tracks))
				}catch{
					completion(.failure(RepoError.ResponseError))
				}
			case .failure(let error):
				completion(.failure(error))
			}
		}
	}
	
	private func dataTask(url : URL, method : String, body: Data?, completion: @escaping (Swift.Result<Data, Error>) -> Void){
		let task = DataTaskRequest()
		task.sendRequest(body: body, url: url, method: "GET"){ data, response, error in
			
			if let response = response as? HTTPURLResponse {
				let status = ResponseStatus.translateReponseCode(statusCode: response.statusCode)
				if(status == ResponseStatus.StatusResult.Successful){
					if let data = data {
						completion(.success(data))
					}else{
						completion(.failure(RepoError.ResponseError))
					}
					
				}else{
					completion(.failure(error ?? RepoError.ResponseError))
				}
			}
			
			else{
				completion(.failure(error ?? RepoError.ResponseError))
			}
		}
	}
    
    
	func getAvailableTracks(loadMoreURL: URL?, completion: @escaping (Swift.Result<AvailableTracks, Error>) -> Void){
        var url = URL(string: "\(Server.url)/api/Music")
		if(loadMoreURL != nil){
			url = loadMoreURL
		}
        if let url = url{
            // GET request should not have a body
			dataTask(url: url, method: "GET", body: nil){ response in
				switch response{
				case .success(let data):
					do {
						let decoded = try JSONDecoder().decode(AvailableTracks.self, from: data)
						completion(.success(decoded))
					}catch{
						completion(.failure(RepoError.ResponseError))
					}
				case .failure(_):
					completion(.failure(RepoError.ResponseError))
				}
			}
            
		}else{completion(.failure(RepoError.RequestError))}
    }
	
}

enum RepoError : Error{
	case RequestError
	case ResponseError
	case ResponseBadStatusCode
}

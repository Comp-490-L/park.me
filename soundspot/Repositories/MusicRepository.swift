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
		
		dataTask(url: url, method: "GET"){ result in
			switch(result){
			case .success(let data):
				completion(.success(data))
			case .failure(let error):
				completion(.failure(error))
			}
		}
	}
	
	func getAlbumTracks(url : URL, completion: @escaping (Swift.Result<[Track], Error>) -> Void){
		dataTask(url: url, method: "GET"){ result in
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
	
	private func dataTask(url : URL, method : String, completion: @escaping (Swift.Result<Data, Error>) -> Void){
		let task = DataTaskRequest()
		task.sendRequest(body: nil, url: url, method: "GET"){ data, response, error in
			
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
	
}

enum RepoError : Error{
	case ResponseError
	case ResponseBadStatusCode
}

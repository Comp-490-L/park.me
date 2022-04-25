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
    
    
	func getAvailableTracks(newest: String?, oldest: String?, completion: @escaping (Swift.Result<AvailableTracks, Error>) -> Void){
        var url = URL(string: "\(Server.url)/api/Music")
		
		if(newest != nil && oldest != nil){
			let escapedNewest = newest!.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
			let escapedOldest = oldest!.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
			
			url = URL(string: "\(Server.url)/api/Music?newest=\(escapedNewest)&oldest=\(escapedOldest)")
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
	
	func createPlaylist(title: String, completion: @escaping (Swift.Result<String, Error>) -> Void){
		let escapedTitle = title.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
		let url = URL(string: "\(Server.url)/api/Playlist?title=\(escapedTitle ?? "")")
		if let url = url {
			dataTask(url: url, method: "POST", body: nil){ response in
				switch response{
				case .success(let data):
					do {
						let decoded = try JSONDecoder().decode(String.self, from: data)
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
	
	func getPlaylist(playlistId :String, completion: @escaping (Swift.Result<Playlist, Error>) -> Void){
		let url = URL(string: "\(Server.url)/api/Playlist?playlistId=\(playlistId)")
		if let url = url {
			dataTask(url: url, method: "GET", body: nil){ response in
				switch response{
					case .success(let data):
						do{
							let decoded = try JSONDecoder().decode(Playlist.self, from: data)
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
	
	func addToPlaylist(playlistId: String, trackId : String, completion: @escaping (Swift.Result<Void, Error>) -> Void){
		let url = URL(string: "\(Server.url)/api/AddToPlaylist?playlistId=\(playlistId)&trackId=\(trackId)")
		if let url = url {
			dataTask(url: url, method: "POST", body: nil){ response in
				switch response{
					case .success(_):
						completion(.success(Void()))
					case .failure(_):
						completion(.failure(RepoError.ResponseError))
					}
				}
		}else{completion(.failure(RepoError.RequestError))}
	}
	
	func removeFromPlaylist(playlistId: String, trackId : String, completion: @escaping (Swift.Result<Void, Error>) -> Void){
		let url = URL(string: "\(Server.url)/api/RemoveFromPlaylist?playlistId=\(playlistId)&trackId=\(trackId)")
		if let url = url {
			dataTask(url: url, method: "DELETE", body: nil){ response in
				switch response{
					case .success(_):
						completion(.success(Void()))
					case .failure(_):
						completion(.failure(RepoError.ResponseError))
					}
				}
		}else{completion(.failure(RepoError.RequestError))}
	}
	
	func renamePlaylist(playlistId: String, title: String, completion: @escaping (Swift.Result<Void, Error>) -> Void){
		let escapedTitle = title.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
		let url = URL(string: "\(Server.url)/api/RenamePlaylist?playlistId=\(playlistId)&title=\(escapedTitle ?? "")")
		if let url = url {
			dataTask(url: url, method: "PUT", body: nil){ response in
				switch response{
					case .success(_):
						completion(.success(Void()))
					case .failure(_):
						completion(.failure(RepoError.ResponseError))
					}
				}
		}else{completion(.failure(RepoError.RequestError))}
	}
	
	// If fileURL is nil the picture will be deleted
	func updatePlaylistPicture(playlistId : String, fileURL : URL?, completion: @escaping (Swift.Result<Void, Error>) -> Void){
		let url = URL(string: "\(Server.url)/api/PlaylistPicture?playlistId=\(playlistId)")
		guard let url = url else{
			completion(.failure(RepoError.RequestError))
			return
		}
		var requestBuilder = MultipartFormDataRequest(url: url)
		let service = MusicService()
		if let fileURL = fileURL {
			do{
				requestBuilder = try service.addFileToRequest(fileURL: fileURL, fieldName: "picture", fileName: "picture", requestBuilder: requestBuilder)
			}catch{
				completion(.failure(RepoError.RequestError))
				return
			}
		}
		
		var request = requestBuilder.getFinalRequest()
		request.addValue("Bearer \(UserAuthRepository.getToken())", forHTTPHeaderField: "Authorization")
		request.httpMethod = "PUT"
		
		let instance = Session()
		let urlSession = URLSession(configuration: URLSessionConfiguration.default, delegate: instance, delegateQueue: nil)
		
		let task = urlSession.dataTask(with: request){ _, response, error in
			if let httpResponse = response as? HTTPURLResponse{
				if(error != nil){
					completion(.failure(RepoError.ResponseError))
				}
				if(httpResponse.statusCode == 200){
					completion(.success(Void()))
				}
			}
		}
		
		task.resume()
		
	}
	
}

enum RepoError : Error{
	case RequestError
	case ResponseError
	case ResponseBadStatusCode
}

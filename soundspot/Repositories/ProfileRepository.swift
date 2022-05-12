//
//  UserProfileRepository.swift
//  soundspot
//
//  Created by Yassine Regragui on 2/18/22.
//

import Foundation

class ProfileRepository : ObservableObject{
    private init(){}
    @Published var profile : ProfileModel? = nil
    private static var instance = ProfileRepository()
    var profileUpdated = false
    //var queue = DispatchQueue(label: "sync update of profile", qos: .userInitiated)
    
    static func getInstance() -> ProfileRepository{
        return instance
    }
    
    func getUserProfile(completion: @escaping (Swift.Result<ProfileModel, Error>) -> Void){
        let url = URL(string: "\(Server.url)/api/Profile")!
        let task = DataTaskRequest()
        
        task.sendRequest(body: nil, url: url, method: "GET"){ data, response, error in
            let httpResponse = response as? HTTPURLResponse
			print("Profile RespCode: \(String(describing: httpResponse?.statusCode))")
            if let data = data {
                if let decoded = try? JSONDecoder().decode(ProfileModel.self, from: data){
                    self.setProfile(profile: decoded)
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
    
    private func setProfile(profile: ProfileModel){
        DispatchQueue.main.async {
            self.profile = profile
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
    
    
    func addToPlaylist(playlistId: String, trackId : String, track: Track, completion: @escaping (Swift.Result<Void, Error>) -> Void){
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
        addToPlaylist(playlistId: playlistId, track: track)
    }
    
    func createPlaylist(title: String, completion: @escaping (Swift.Result<String, Error>) -> Void){
        let escapedTitle = title.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        let url = URL(string: "\(Server.url)/api/Playlist?title=\(escapedTitle ?? "")")
        if let url = url {
            dataTask(url: url, method: "POST", body: nil){ response in
                switch response{
                case .success(let data):
                    let playlistId = String(decoding: data, as: UTF8.self)
                    self.createPlaylist(title: title, playlistId: playlistId)
                    if(playlistId == ""){
                        return completion(.failure(RepoError.ResponseError))
                    }
                    completion(.success(playlistId))
                    
                case .failure(_):
                    completion(.failure(RepoError.ResponseError))
                }
            }
            
        }else{completion(.failure(RepoError.RequestError))}
        
    }
    
    private func createPlaylist(title: String, playlistId: String){
        let url = "\(Server.url)/api/Playlist?playlistId=\(playlistId)"
        let playlist = Playlist(id: playlistId, title: title, link: url, pictureLink: nil, isLiked: false)
        DispatchQueue.main.async {
            [self] in
            profile!.playlistList.append(playlist)
        }
    }
    
    private func addToPlaylist(playlistId: String, track: Track){
        if(profile == nil){
            return
        }
        
        DispatchQueue.main.async {
            [self] in
            for (index, playlist) in profile!.playlistList.enumerated(){
                if(playlist.id == playlistId){
                    profile!.playlistList[index].tracks.append(track)
                }
            }
        }
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
    
    func deleteTrack(){}
    
    func deletePlaylist(){}
    
    func deleteAlbum(){}
    
    func renamePlaylist(){
        
    }
    
    func renameAlbum(){
        
    }
    
    func renameTrack(){
        
    }
    
    func removeFromAlbum(){
        
    }
    
    private func dataTask(url : URL, method : String, body: Data?, completion: @escaping (Swift.Result<Data, Error>) -> Void){
        let task = DataTaskRequest()
        task.sendRequest(body: body, url: url, method: method){ data, response, error in
            
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

enum ProfileRepositoryError : Error{
    case UnableToDecodeResponse
    case ResponseError
	case UrlError
}


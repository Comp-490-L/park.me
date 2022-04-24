//
//  MusicService.swift
//  soundspot
//
//  Created by Yassine Regragui on 12/1/21.
//

import Foundation
import SwiftUI
import Combine
struct MusicService{
	
	typealias ProgressPublisher = AnyPublisher<Double, Error>
	let fileUploader = FileUploader()
	
	func createAlbum(title: String, pictureURL: URL?, completionHander: @escaping (Data?, URLResponse?, Error?) -> Void)
	throws -> ProgressPublisher
	{
		let url = URL(string: "\(Server.url)/api/Album")!
		var requestBuilder = MultipartFormDataRequest(url: url)
		// Add title to request param
		
		requestBuilder.addTextField(named: "title", value: "{ \"title\" : \"\(title)\" }")
		// Add picture to request
		if let pictureURL = pictureURL {
			requestBuilder = try addFileToRequest(fileURL: pictureURL, fieldName: "picture", fileName: "picture.jpg", requestBuilder: requestBuilder)
		}
		
		var request = requestBuilder.getFinalRequest();
		request.addValue("Bearer \(UserAuthRepository.getToken())", forHTTPHeaderField: "Authorization")
		
		let publishers = fileUploader.send(request: request, completionHander: completionHander)
		return publishers
	}

	
	
	func uploadTrack(track : TrackUpload, albumId: String?, completionHander: @escaping (Data?, URLResponse?, Error?) -> Void) throws -> ProgressPublisher{
		let metadata = TrackMetadata(albumId: albumId, title: track.title, artists: track.artists)
		let url = URL(string: "\(Server.url)/api/track")
		guard let url = url else {
			throw APIServiceError.FailedToSendRequest(reason: "Invalid url")
		}

		var requestBuilder = MultipartFormDataRequest(url: url)
		
		guard let encoded = try? JSONEncoder().encode(metadata)
		else{throw APIServiceError.FailedToSendRequest(reason: "Unable to encode")}
		let encodedString = String(decoding: encoded, as: UTF8.self)
		requestBuilder.addTextField(named: "trackMetadata", value: encodedString)
		
		requestBuilder = try addFileToRequest(fileURL: track.fileURL, fieldName: "track", fileName: "track.mp3", requestBuilder: requestBuilder)
		if let pictureURL = track.pictureURL{
			requestBuilder = try addFileToRequest(fileURL: pictureURL, fieldName: "picture", fileName: "picture.jpeg", requestBuilder: requestBuilder)
		}
		var request = requestBuilder.getFinalRequest()
		request.addValue("Bearer \(UserAuthRepository.getToken())", forHTTPHeaderField: "Authorization")
		let publishers = fileUploader.send(request: request, completionHander: completionHander)
		return publishers
		
	}
	
	func addFileToRequest(fileURL : URL, fieldName: String, fileName: String, requestBuilder: MultipartFormDataRequest)
	throws -> MultipartFormDataRequest{
		guard let handle: FileHandle = try? FileHandle(forReadingFrom: fileURL)
		else{
			print("Cannot open file")
			throw APIServiceError.FailedToSendRequest(reason: "Cannot open file")
		}
	
	
		if let readData: Data = try handle.readToEnd(){
			requestBuilder.addDataField(fieldName: fieldName, fileName: fileName, fileData: readData, mimeType: "multipart/form-data")
			do{
				try handle.close()
			}catch{}
		}else{ throw APIServiceError.FailedToSendRequest(reason: "Cannot read from file") }
		return requestBuilder
	}

	private struct TrackMetadata : Codable{
		var albumId : String?
		var title: String
		var artists: String
	}
}
                

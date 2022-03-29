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
	typealias ResultPublisher = AnyPublisher<URLSession.DataTaskPublisher.Output, URLSession.DataTaskPublisher.Failure>
	let fileUploader = FileUploader()
	
	func createAlbum(title: String, pictureURL: URL?)
	throws -> (ProgressPublisher, ResultPublisher)
	{
		let url = URL(string: "\(Server.url)/api/Album")!
		var requestBuilder = MultipartFormDataRequest(url: url)
		// Add title to request param
		
		requestBuilder.addTextField(named: "title", value: "{ \"title\" : \"\(title)\" }")
		// Add picture to request
		if let pictureURL = pictureURL {
			guard let handle: FileHandle = try? FileHandle(forReadingFrom: pictureURL)
			else{
				print("Cannot open file")
				throw APIServiceError.FailedToSendRequest(reason: "Cannot open file")
			}
		
		
			if let readData: Data = try handle.readToEnd(){
				requestBuilder.addDataField(fieldName: "picture", fileName: "picture.jpg", fileData: readData, mimeType: "multipart/form-data")
				do{
					try handle.close()
				}catch{}
			}else{ throw APIServiceError.FailedToSendRequest(reason: "Cannot read from file") }
		}
		
		var request = requestBuilder.getFinalRequest();
		request.addValue("Bearer \(UserAuthRepository.getToken())", forHTTPHeaderField: "Authorization")
		
		let publishers = fileUploader.send(request: request)
		return publishers
	}

	
	
	func uploadTrack(track : TrackUpload, albumId: String?) throws -> (ProgressPublisher, ResultPublisher){
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
		
		requestBuilder = try addFileToRequest(fileURL: track.fileURL, fieldName: "track", fileName: "track", requestBuilder: requestBuilder)
		if let pictureURL = track.pictureURL{
			requestBuilder = try addFileToRequest(fileURL: pictureURL, fieldName: "picture", fileName: "picture.jpeg", requestBuilder: requestBuilder)
		}
		var request = requestBuilder.getFinalRequest()
		request.addValue("Bearer \(UserAuthRepository.getToken())", forHTTPHeaderField: "Authorization")
		let publishers = fileUploader.send(request: request)
		return publishers
		
	}
	
	private func addFileToRequest(fileURL : URL, fieldName: String, fileName: String, requestBuilder: MultipartFormDataRequest)
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
    
	
	
    struct Download{
        
        var downloadTask: URLSessionDownloadTask? = nil
        var progressLabel: UILabel? = nil
        
        mutating func tracks(trackId: String){
            let instance = Session()
            lazy var urlSession = URLSession(configuration: URLSessionConfiguration.default, delegate: instance, delegateQueue: nil)
            
            let requestUrl = URL(string: "\(Server.url)/api/StreamTrack?id=\(trackId)")!
            
            var request = URLRequest(url: requestUrl)
            request.httpMethod = "GET"
            request.addValue("Bearer \(UserAuthRepository.getToken())", forHTTPHeaderField: "Authorization")
            
            let downloadTask = urlSession.downloadTask(with: request){
                fileurl, response, error in
                
                if(error != nil){
                    print(error!)
                }
                if(response != nil){
                    print(response!)
                }
                
                guard let fileURL = fileurl
                else {
                    print("URL is nil")
                    return
                }
                print(fileURL)
                do {
                    let documentsURL = try
                    FileManager.default.url(for: .documentDirectory,
                                               in: .userDomainMask,
                                               appropriateFor: nil,
                                               create: false)
                        // TODO fix file already exists
                    var fileName = ""
                    if (response?.suggestedFilename != nil || response?.suggestedFilename != ""){
                        fileName = response!.suggestedFilename!
                    }else{fileName = fileURL.lastPathComponent}
                    
                    let savedURL = documentsURL.appendingPathComponent(fileName)
                    try FileManager.default.moveItem(at: fileURL, to: savedURL)
                    print("File moved to : \(savedURL)")
                } catch {
                    print ("file error: \(error)")
                }
            }
            downloadTask.resume()
            self.downloadTask = downloadTask
        }
        
        func urlSession(_ session: URLSession,
                        downloadTask: URLSessionDownloadTask,
                        didWriteData bytesWritten: Int64,
                        totalBytesWritten: Int64,
                        totalBytesExpectedToWrite: Int64) {
            
            if downloadTask == self.downloadTask {
                var calculatedProgress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
                DispatchQueue.main.async {
                    //self.progressLabel.text = self.percentFormatter.string(from:
                                                                            //NSNumber(value: calculatedProgress))
                }
            }
        }
    }
	
	
	
	struct Album{
		
	}
    
}
                

//
//  DownloadService.swift
//  soundspot
//
//  Created by Yassine Regragui on 12/3/21.
//

import Foundation

class DownloadService {

var activeDownloads: [URL: Download] = [:]


  var downloadsSession: URLSession!

  func cancelDownload(_ track: Track) {
  }
  

  func pauseDownload(_ track: Track) {
  }
  

  func resumeDownload(_ track: Track) {
  }
  

    func startDownload(_ track: Track) -> URL?{
  
      let download = Download(track: track)
  
		let url = URL(string: track.link)
		guard let url = url else {
			return nil
		}
		
		var request = URLRequest(url: url)
		request.httpMethod = "GET"
        request.addValue("Bearer \(UserAuthRepository.getToken())", forHTTPHeaderField: "Authorization")
        
    var fileOutput : URL? = nil
      
      let sem = DispatchSemaphore.init(value: 0)
      
         download.task = downloadsSession.downloadTask(with: request) {
          fileurl, response, error in
          
          
          if(error != nil){
              print(error!)
          }
          if(response != nil){
              print(response!)
          }
          
          guard let storedURL = fileurl
          else {
              print("URL is nil")
              return
          }
          print(storedURL)
          do {
              let documentsURL = try
              FileManager.default.url(for: .documentDirectory,
                                         in: .userDomainMask,
                                         appropriateFor: nil,
                                         create: false)
              
              var fileName = storedURL.lastPathComponent
              if (response?.suggestedFilename != nil || response?.suggestedFilename != ""){
                  fileName = response?.suggestedFilename ?? "file.mp3"
              }
              let savedURL = documentsURL.appendingPathComponent(fileName)
              // remove file if it exist
              let fileManager = FileManager.default
              try? fileManager.removeItem(at: savedURL)
              // move file from tmp
              try fileManager.moveItem(at: storedURL, to: savedURL)
              print("File moved from tmp to : \(savedURL)")
              fileOutput = savedURL
              defer { sem.signal() }
          } catch {
              print ("file error: \(error)")
          }
      }
      
      download.task?.resume()
      
      download.isDownloading = true
      
     // activeDownloads[download.track.previewURL] = download
      sem.wait()
        return fileOutput
  }
}

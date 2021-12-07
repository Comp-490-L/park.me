//
//  DownloadService.swift
//  soundspot
//
//  Created by Yassine Regragui on 12/3/21.
//

import Foundation


//
// MARK: - Download Service
//

/// Downloads song snippets, and stores in local file.
/// Allows cancel, pause, resume download.
class DownloadService {
  //
  // MARK: - Variables And Properties
  //
  // TODO 4
    
    var activeDownloads: [URL: Download] = [:]

  
  /// SearchViewController creates downloadsSession
  var downloadsSession: URLSession!
  
  //
  // MARK: - Internal Methods
  //
  // TODO 9
  func cancelDownload(_ track: Track) {
  }
  
  // TODO 10
  func pauseDownload(_ track: Track) {
  }
  
  // TODO 11
  func resumeDownload(_ track: Track) {
  }
  
  // TODO 8
    func startDownload(_ track: Track) -> URL?{
      // 1
      let download = Download(track: track)
      // 2
      // Token valid for 12 month since we don't have neither the code to update it every 5 min
      // nor the local db to save it in
      
      var request = URLRequest(url: track.previewURL)
      request.httpMethod = "GET"
        request.addValue("Bearer \(Server.token)", forHTTPHeaderField: "Authorization")
        
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
      // 3
      download.task?.resume()
      // 4
      download.isDownloading = true
      // 5
      activeDownloads[download.track.previewURL] = download
      sem.wait()
        return fileOutput
  }
}

//
//  MusicService.swift
//  soundspot
//
//  Created by Yassine Regragui on 12/1/21.
//

import Foundation
import SwiftUI
struct MusicService{

    struct Upload{
        func tracks(urls: [URL]){

            
            print("upload tracks called")
            let uploader = FileUploader()
            let url = URL(string: "\(Server.url)/api/UploadTracks")!
            // if let audioFileURL = Bundle.main.url(forResource: "p3", withExtension: ".pdf")
            let audioFileURL = urls[0]
            
            print(audioFileURL)
            do{
                let publisher = try uploader.uploadFile(at: audioFileURL, to: url, accessToken: Server.token)
                if(publisher != nil){
                    let subscription = publisher!.sink(receiveCompletion: { print ("completion: \($0)") },
                                                       receiveValue: { print ("receive value: \($0)") })
                    //TODO cancel subscription on completion
                }else {
                    print("publisher is nil")
                }
                
            }catch let error{
                print("Error: \(error)")
            }
        }
        
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
            request.addValue("Bearer \(Server.token)", forHTTPHeaderField: "Authorization")
            
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
    
}
                

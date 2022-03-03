//
//  MusicUploadViewModel.swift
//  soundspot
//
//  Created by Yassine Regragui on 3/2/22.
//

import Foundation
import MediaPlayer
import SwiftUI

class MusicUploadViewModel : ObservableObject{
    
    init(uploadChoice : UploadChoice, selectedFiles : [URL]){
        self.uploadChoice = uploadChoice
        filesURL = selectedFiles
        processFiles()
    }
    
    @Published var uploadChoice : UploadChoice
    @Published var album : AlbumUpload = AlbumUpload()
    @Published var tracks : [TrackUpload] = []
    @Published var processing = false
    // List of the stored files the user selected in drawer
    private var filesURL : [URL]
    
    private func processFiles(){
        processing = true
        DispatchQueue.global(qos: .userInitiated).async {
            [self] in
            var selectedTracks : [TrackUpload] = [TrackUpload]()
            for (i, url) in self.filesURL.enumerated(){
                let fileManager = FileManager.default
                if fileManager.fileExists(atPath: url.path){
                    let playerItem = AVPlayerItem(url: url)
                    let metadataList = playerItem.asset.metadata

                    let metadata = extractMetadata(metadataList: metadataList)
                    var title : String? = metadata.title
                    let picture : Data? = metadata.picture
                    
        
                    if(title == nil){
                        let fileName = getFileName(url: url) as NSString
                        title = fileName.deletingPathExtension
                    }
                    var pictureURL : URL? = nil
                    if let picture = picture {
                        do {
                            pictureURL = try saveFile(fileName: "picture\(i)", data: picture)
                        }catch{}
                    }
                    let track = TrackUpload(name: title ?? "", picture: pictureURL, file: url)
                    selectedTracks.append(track)
                }
            }
            DispatchQueue.main.async{
                tracks = selectedTracks
                processing = false
            }
            
        }
    }
    
    private func extractMetadata(metadataList : [AVMetadataItem]) ->(title : String?, picture : Data?){
        var title : String? = nil
        var picture : Data? = nil
        
           for item in metadataList {
               guard let key = item.commonKey?.rawValue, let value = item.value else{
                      continue
                  }

                 switch key {
                  case "title" :
                     title = value as? String
                 case "artwork" where value is Data : picture = value as? Data
                  default:
                    continue
                 }
           }
        return(title, picture)
    }
    
    private func getFileName(url : URL) -> String{
        return (url.path as NSString).lastPathComponent
    }
    
    private func saveFile(fileName : String, data : Data) throws -> URL{
        
        let documentDirectoryUrl = try! FileManager.default.url(
           for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true
        )
        let fileUrl = documentDirectoryUrl.appendingPathComponent(fileName)
        // prints the file path
        print("File path \(fileUrl.path)")
        
        try data.write(to: fileUrl)
        
        return fileUrl
    }
    
}

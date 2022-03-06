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
		let a = AlbumUpload()
		album = a
		uphViewModel = UPHViewModel(placeholder: "Album title", headerData: a)
    }
    
    @Published var uploadChoice : UploadChoice
    @Published var album : AlbumUpload
    @Published var tracks : [TrackUpload] = []
    @Published var processing = false
	@Published var showPhotoLibrary = false
	@Published var albumImage : Image = Image("defaultTrackImg")
	var uphViewModel : UPHViewModel
	
	// Shows the file picker to choose picture for album artwork
	@Published var showImageFilePicker = false
    // List of the stored files the user selected in drawer
    private var filesURL : [URL]
	
	var clickedTrack : TrackUpload? = nil
	@Published var navigateToModifyTrack = false
	
	// Block processing files when coming back from ModifyTrackView
	private var firstTimeLoad = true
	
	func onEvent(event : MusicUploadEvent){
		switch(event){
		case .trackClicked(let track):
			clickedTrack = track
			navigateToModifyTrack = true
		case .onAppear:
			if(firstTimeLoad){
				processFiles()
			}
			firstTimeLoad = false
		}
	}
    
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
							pictureURL = try FileManager.saveAsJPEGFile(fileName: FileManager.getRandomJPEGFileName(), data: picture)
                        }catch{}
                    }
					
                    let track = TrackUpload(
						name: title ?? "",
						pictureURL: pictureURL,
						fileURL: url,
						artists: Artists(uploader: getUsername(), collaborators: [String]()))
                    selectedTracks.append(track)
                }
            }
            DispatchQueue.main.async{
                tracks = selectedTracks
                processing = false
            }
            
        }
    }
    
	private func getUsername() -> String{
		return "username"
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
}



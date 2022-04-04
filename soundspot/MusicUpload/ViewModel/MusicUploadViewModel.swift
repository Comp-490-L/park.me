//
//  MusicUploadViewModel.swift
//  soundspot
//
//  Created by Yassine Regragui on 3/2/22.
//

import Foundation
import MediaPlayer
import SwiftUI
import Combine

class MusicUploadViewModel : ObservableObject{
    
    init(uploadChoice : UploadChoice, selectedFiles : [URL]){
        self.uploadChoice = uploadChoice
        filesURL = selectedFiles
		let a = AlbumUpload()
		album = a
		self.titleErrorPassthrough = PassthroughSubject<Bool, Never>()
		uphViewModel = UHViewModel(placeholder: "Album title", headerData: a, titleError: titleErrorPassthrough.eraseToAnyPublisher())
    }
    
    @Published var uploadChoice : UploadChoice
    @Published var album : AlbumUpload
    @Published var tracks : [TrackUpload] = []
    @Published var processing = false
	@Published var showPhotoLibrary = false
	@Published var albumImage : Image = Image("defaultTrackImg")
	@Published private (set) var showUploadBtn = true

	var uphViewModel : UHViewModel
	var titleErrorPassthrough : PassthroughSubject<Bool, Never>
	
	
	// Shows the file picker to choose picture for album artwork
	@Published var showImageFilePicker = false
    // List of the stored files the user selected in drawer
    private var filesURL : [URL]
	
	var clickedTrack : TrackUpload? = nil
	@Published var navigateToModifyTrack = false
	
	// Block processing files when coming back from ModifyTrackView
	private var firstTimeLoad = true
	
	// Testing for bug
	private var createAlbumCalled = false
	private var createAlbumQueue = DispatchQueue(label: "a")
	
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
			
		case .removeTrackClicked(let index):
			removeTrackAt(index)
			
		case .uploadClicked:
			uploadClicked()
		}
	}
	

	private func uploadClicked(){
		createAlbumQueue.sync{
			if(createAlbumCalled){
				return
			}else{
				if(uploadChoice == UploadChoice.album){
					if(album.title == ""){
						titleErrorPassthrough.send(true)
						return
					}
					showUploadBtn = false
					createAlbum() // Track will be uploaded when the album is created
					return
					
				}else{
					showUploadBtn = false
					uploadTracks()
				}
				createAlbumCalled = true
			}
		}
	}
	
	private func uploadTracks(){
		let musicService = MusicService()
		for i in tracks.indices{
			tracks[i].uploading = true
		DispatchQueue.global(qos: .userInitiated).async{
			[self] in
			var publishers : AnyPublisher<Double, Error>?
			= nil
			do{
				publishers = try musicService.uploadTrack(track: tracks[i], albumId: album.id){_,_,_ in } // TODO show error
			}catch{}
			DispatchQueue.main.async {
				guard let publishers = publishers else {
					return //TODO show error
				}

				publishers.subscribe(Subscribers.Sink(
					receiveCompletion: { result in
					switch result{
					case .finished:
						tracks[i].uploading = false
						tracks[i].uploaded = true
					case .failure(_):
						tracks[i].uploading = false
						print("completion failure")
					}
				},
					receiveValue: {
						tracks[i].uploadProgress = $0
					}))
			}
		}
		}
	}
	
	private func createAlbum(){
		let musicService = MusicService()
		do{
			_ = try musicService.createAlbum(title: album.title, pictureURL: album.pictureURL){data, response, error in
				if let httpResponse = response as? HTTPURLResponse{
					if(httpResponse.statusCode == 200){
						if let data = data {
							if let decoded = try? JSONDecoder().decode(CreateAlbumResult.self, from: data){
								self.album.id = decoded.albumId
								self.uploadTracks()
							} // TODO show error
						}
					}
				}
			}
		}catch{}
	}
	
    
    private func processFiles(){
        processing = true
        DispatchQueue.global(qos: .userInitiated).async {
            [self] in
            var selectedTracks : [TrackUpload] = [TrackUpload]()
			for (_, url) in self.filesURL.enumerated(){
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
						title: title ?? "",
						pictureURL: pictureURL,
						fileURL: url,
						artists: "")
					
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
	
	private func removeTrackAt(_ index : Int){
		do{
			let fileManager = FileManager.default
			if let pictureURL = tracks[index].pictureURL{
				try fileManager.removeItem(at: pictureURL)
			}
		}catch{}
		tracks.remove(at: index)
	}
}



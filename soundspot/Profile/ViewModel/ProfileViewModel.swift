//
//  ProfileViewModel.swift
//  soundspot
//
//  Updated by Yassine Regragui on 2/20/22.
//

import Foundation
import SwiftUI
import Combine
import UniformTypeIdentifiers

class ProfileViewModel: ObservableObject{
  
	@Published var profile: ProfileModel? = nil
    @Published var showFilePicker = false
    @Published var clickedTrack :Int? = nil
    @State var tracksList = Array<MusicModel>()
    @Published var uploadingFile = false
    @Published var uploadProgress : Double = 0.0
    @Published var navigateToUploadView = false
    
    private var localString = ""
    private var profileRepo = ProfileRepository()
    private var profileFirstLoad = true
    var uploadChoice : UploadChoice = UploadChoice.tracks
    var selectedFiles : [URL] = [URL]()
    
    private var functionCalled = false
	func testUpload(){
		
		if(functionCalled){return}
		functionCalled = true
		
		var filesURL = [URL]()
		var f : URL = URL(string: "file:///Users/yassineregragui/Library/Developer/CoreSimulator/Devices/CB67FC80-ADA1-4179-8906-EC30F271B58D/data/Containers/Shared/AppGroup/C01D9C52-3FD1-4ABA-9CA0-887EEA24A32E/File%20Provider%20Storage/DVRST%20-%20REASON%20TO%20LIVE.mp3")!
		filesURL.append(f)
		
		f = URL(string: "file:///Users/yassineregragui/Library/Developer/CoreSimulator/Devices/CB67FC80-ADA1-4179-8906-EC30F271B58D/data/Containers/Shared/AppGroup/C01D9C52-3FD1-4ABA-9CA0-887EEA24A32E/File%20Provider%20Storage/Ty%20Dolla%20$ign%20-%20Clout%20(feat.%2021%20Savage).mp3")!
		filesURL.append(f)
		
		f = URL(string:
					"file:///Users/yassineregragui/Library/Developer/CoreSimulator/Devices/CB67FC80-ADA1-4179-8906-EC30F271B58D/data/Containers/Shared/AppGroup/C01D9C52-3FD1-4ABA-9CA0-887EEA24A32E/File%20Provider%20Storage/Young%20Scooter%20-%20Diamonds.mp3")!
		filesURL.append(f)
		selectedFiles = filesURL
		uploadChoice = UploadChoice.album
		navigateToUploadView = true
	}
	
    func onEvent(event : ProfileEvents){
        switch(event){
        case .ProfileViewLoaded:
			getUserProfile()
        case .UploadAlbumClicked:
            uploadChoice = UploadChoice.album
            showFilePicker.toggle()
        case .UploadTracksClicked:
            uploadChoice = UploadChoice.tracks
            showFilePicker.toggle()
        }
    }
    
    private func getUserProfile(){
        profileRepo.getUserProfile{ result in
            DispatchQueue.main.async {
                switch result{
                case .success(let savedProfile):
                    self.profile = savedProfile
                    print("Got user profile, list count \(savedProfile.singlesList?.count ?? 0)")
                    self.getPictures()
                case .failure(_):
                    self.showErrorLoadingProfile()
                }
            }
        }
    }
    
    
    private func getPictures(){
        print("Getting pictures")
        for (index, _) in profile!.singlesList!.enumerated(){
            if(profile?.singlesList![index].pictureLink != nil){
                profileRepo.getTrackPicture(url: URL(string: (profile?.singlesList![index].pictureLink)!)!) { result in
                    switch result{
                    case .success(let data):
						DispatchQueue.main.async {
							self.profile?.singlesList?[index].pictureData = data
							self.profile?.singlesList![index].pictureDownloaded = true
						}
                    case .failure(_):
                        print("Failed to get picture of track ")
                    }
                }
            }
        }
    }
    
    private func showErrorLoadingProfile(){
        
    }
    
    
    private func launchPlayer(index: Int){
        @State var isActive = true
        _ = NavigationLink(self.localString, destination: PlayerView(viewModel: PlayerViewModel(trackList: (self.profile?.singlesList!)!, trackIndex: index)), isActive: $isActive)
    }
    
    
    func showDocumentPicker() -> some UIViewControllerRepresentable{
		return DocumentPicker(onDocPicked: launchUploadView, contentType: UTType.mp3, allowMutipleSelection: true)
    }
    

    
    private func launchUploadView(urls: [URL]){
        selectedFiles = urls
        navigateToUploadView = true
    }
    
    
    func uploadTracks(url: URL){
        uploadingFile = true
        DispatchQueue.global(qos: .userInitiated).async{
            let musicService = MusicService()
			let publisher = musicService.uploadTrack(fileURL: url)
            DispatchQueue.main.async {
                publisher?.subscribe(Subscribers.Sink(
                    receiveCompletion: { result in
                    switch result{
                    case .finished:
                        self.uploadingFile = false
                        self.getUserProfile()
                    case .failure(_):
                        self.uploadingFile = false
                        print("completion failure")
                    }
                },
                receiveValue: {
                    self.uploadProgress = $0
                }))
            }
        }
    }
}

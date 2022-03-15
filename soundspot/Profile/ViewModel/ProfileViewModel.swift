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
    @State var tracksList = Array<Track>()
    @Published var uploadingFile = false
    @Published var uploadProgress : Double = 0.0
    @Published var navigateToUploadView = false
    
    private var localString = ""
    private var profileRepo = ProfileRepository()
    private var profileFirstLoad = true
    var uploadChoice : UploadChoice = UploadChoice.tracks
    var selectedFiles : [URL] = [URL]()
    
    private var functionCalled = false

	
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
		guard let profile = profile else {
			return
		}

		guard var list = profile.singlesList else { return }
        for (index, _) in list.enumerated(){
            if(profile.singlesList![index].pictureLink != nil){
                profileRepo.getTrackPicture(url: URL(string: (list[index].pictureLink)!)!) { result in
                    switch result{
                    case .success(let data):
						DispatchQueue.main.async {
							list[index].pictureData = data
							list[index].pictureDownloaded = true
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
    
}

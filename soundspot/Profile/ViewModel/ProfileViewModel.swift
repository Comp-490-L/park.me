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
	
	@Published var clickedTrack :Int = 0
	
	@Published var uploadingFile = false
	@Published var uploadProgress : Double = 0.0
	@Published var navigateToUploadView = false
	
	private var localString = ""
	private var profileRepo = ProfileRepository()
	private var profileFirstLoad = true
	
	var uploadChoice : UploadChoice = UploadChoice.tracks
	var selectedFiles : [URL] = [URL]()
	// Used for navigation link
	@Published var navigateToPlayerView = false
	
	@Published var navigateToPlaylistView = false
	var clickedAlbum : Int = 0
	
	var loading = true
	
	
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
					print("Got user profile, list count \(savedProfile.singlesList.count)")
					self.getPictures()
				case .failure(_):
					self.showErrorLoadingProfile()
				}
			}
		}
	}
	
	
	private func getPictures(){
		print("Getting pictures")
		
		if(profile == nil || profile!.singlesList.count == 0){
			loading = false
			return
		}
		
		
		
		for (index, _) in profile!.singlesList.enumerated(){
			if let link = profile!.singlesList[index].pictureLink {
				if let url = URL(string: link){
					profileRepo.getPicture(url:  url){ result in
						switch result{
						case .success(let data):
							DispatchQueue.main.async {
								self.profile!.singlesList[index].pictureData = data
								self.profile!.singlesList[index].pictureDownloaded = true
							}
						case .failure(_):
							print("Failed to get picture of track ")
						}
						
						DispatchQueue.main.async {
							self.loading = false
						}
					}
				}
			}
		}
	}
	
	private func showErrorLoadingProfile(){
		
	}
	
	/*
	private func launchPlayer(index: Int){
		if(profile == nil){return}
		@State var isActive = true
		_ = NavigationLink(self.localString, destination: PlayerView(viewModel: PlayerViewModel(trackList: (self.profile?.singlesList)!, trackIndex: index)), isActive: $isActive)
	}
	*/
	
	func showDocumentPicker() -> some UIViewControllerRepresentable{
		return DocumentPicker(onDocPicked: launchUploadView, contentType: UTType.mp3, allowMutipleSelection: true)
	}
	
	
	
	private func launchUploadView(urls: [URL]){
		selectedFiles = urls
		navigateToUploadView = true
	}
	
	func navigateToPlayerView(index : Int){
		if let profile = profile {
			if(index < profile.singlesList.count){
				clickedTrack = index
				navigateToPlayerView = true
			}
		}
	}
	
	func navigateToPlaylistView(index : Int){
		if let profile = profile {
			if(index < profile.albumsList.count){
				clickedAlbum = index
				navigateToPlaylistView = true
			}
		}
	}
	
}

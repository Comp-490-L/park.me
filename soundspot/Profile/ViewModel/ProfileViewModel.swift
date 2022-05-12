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
    init(){
        profileRepo = ProfileRepository.getInstance()
    }
    
    //var profile: Published<ProfileModel?>.Publisher
    @Published var showFilePicker = false
    
    
    @Published var clickedTrack :Int = 0
    
    @Published var uploadingFile = false
    @Published var uploadProgress : Double = 0.0
    @Published var navigateToUploadView = false
    @Published var updateProfilePic = false
    

    private var profileRepo : ProfileRepository
    private var profileFirstLoad = true
    
    var uploadChoice : UploadChoice = UploadChoice.tracks
    var selectedFiles : [URL] = [URL]()
    // Used for navigation link
    @Published var navigateToPlayerView = false
    @Published var navigateToCreatePlaylistView = false
    @Published var navigateToSettingsView = false
    
    @Published var navigateToPlaylistView = false
    var clickedAlbum : Int = 0
    
    @Published var loading = true
    @Published private (set) var errorLoading = false
    
    // queue used to increament picture loaded and removes loading from view
    private var processQueue = DispatchQueue(label: "load queue")
    private var processed = 0
    
    var clickedPlaylist = 0
    @Published var navigateToPlaylist = false
    
    var didAppear = false
    
    func onEvent(event : ProfileEvents){
        switch(event){
        case .LoadProfile:
            getUserProfile()
        case .UploadAlbumClicked:
            uploadChoice = UploadChoice.album
            showFilePicker.toggle()
        case .UploadTracksClicked:
            uploadChoice = UploadChoice.tracks
            showFilePicker.toggle()
        case .PictureClicked:
            updateProfilePic = true
        }
    }
    
    private func getProfilePic(){
        
        guard let profile = profileRepo.profile else{return}
        guard let link = profileRepo.profile?.pictureLink else {return}
        let url = URL(string: link)
        if let url = url {
            profileRepo.getPicture(url: url){
                result in
                switch result{
                
                    case .success(let data):
                    let image = UIImage(data: data)
                    if let image = image{
                        profile.image = Image(uiImage: image)
                    }
                    case .failure(_):
                        return
                
                
                    
                }
            }
        }
        
    }
    
    private func getUserProfile(){
        if(didAppear){
            return
        }else{
            didAppear = true
        }
        print("\nLoad Profile\n")
        if(profileRepo.profile != nil){ //TODO check if data has changed on the server
            loading = false
            errorLoading = false
            return
        }
        loading = true
        errorLoading = false
        profileRepo.getUserProfile{ result in
            DispatchQueue.main.async {
                switch result{
                case .success(let savedProfile):
                    //self.profile = self.profileRepo.profile
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
        
        if(profileRepo.profile == nil || profileRepo.profile!.singlesList.count == 0){
            loading = false
            return
        }
        
        var processed = 0
        
        for (index, _) in profileRepo.profile!.singlesList.enumerated(){
            if let link = profileRepo.profile!.singlesList[index].pictureLink {
                processed += 1
                if let url = URL(string: link){
                    profileRepo.getPicture(url:  url){ result in
                        DispatchQueue.main.async {
                            switch result{
                                    case .success(let data):
                                        self.profileRepo.profile!.singlesList[index].pictureData = data
                                        self.profileRepo.profile!.singlesList[index].pictureDownloaded = true
                                        print("Got pictures")
                                        
                                    case .failure(_):
                                        print("Failed to get picture of track ")
                                        break
                            }
                            self.incrementProcessedPictures()
                        }
                    }
                }
            }else{
                self.incrementProcessedPictures()
            }
        }
        
        // Case list is empty
        if(processed == 0){
            self.loading = false
            print("removing loading")
        }
    }
    
    /**
     Pictures are the last to be loaded on the view
     The function removes the loading view from the screen
     when counter reaches total tracks by incrementing the integer atomicaly
     **/
    private func incrementProcessedPictures(){
        processQueue.sync {
            processed += 1
            if(processed == profileRepo.profile?.singlesList.count){
                loading = false
                processed = 0
                print("removing loading in incrementProcessedPictures")
            }
        }
    }
    
    private func showErrorLoadingProfile(){
        errorLoading = true
        loading = false
    }
    
    
    func showDocumentPicker() -> some UIViewControllerRepresentable{
        return DocumentPicker(onDocPicked: launchUploadView, contentType: UTType.mp3, allowMutipleSelection: true)
    }
    
    
    
    private func launchUploadView(urls: [URL]){
        selectedFiles = urls
        navigateToUploadView = true
    }
    
    func navigateToPlayerView(index : Int){
        if let profile = profileRepo.profile {
            if(index < profile.singlesList.count){
                clickedTrack = index
                navigateToPlayerView = true
            }
        }
    }
    
    func navToCreatePlaylistView()
    {
        navigateToCreatePlaylistView = true
    }
    
    func navigateToPlaylistView(index : Int){
        if let profile = profileRepo.profile {
            if(index < profile.albumsList.count){
                clickedAlbum = index
                navigateToPlaylistView = true
            }
        }
    }
    
    func navigateToPlaylist(index : Int){
        if let profile = profileRepo.profile {
            if(index < profile.playlistList.count){
                clickedPlaylist = index
                navigateToPlaylist = true
            }
        }
    }
    
}


//
//  PlaylistViewModel.swift
//  soundspot
//
//  Created by Yassine Regragui on 3/25/22.
//

import Foundation
import SwiftUI

class PlaylistViewModel : ObservableObject{
	init(album : Album){
		self.album = album
	}
	
	@Published var album : Album
	@Published var loading = true
	@Published var tracksList = [Track]()
	private lazy var repo = MusicRepository()
	// just temp
	let playerView = PlayerView(viewModel: PlayerViewModel(trackList: [Track](), trackIndex: 0))
    
	private var loadedPictures : Int32 = 0
	private var picturesToLoad : Int32 = 0
	
	// Used for navigation link
	var clickedTrack : Int? = nil
	@Published var navigateToPlayerView = false
	
	func onEvent(event : PlaylistEvent){
		switch event {
		case .onLoad:
			loadAlbum()
		}
	}
	
	private func loadAlbum(){
		
		if(album.pictureLink != nil){
			picturesToLoad = 1
		}else{
			picturesToLoad = 0
		}
		
		if let url = URL(string: album.link){
			repo.getAlbumTracks(url: url) { result in
				switch(result){
				case .success(let trackList):
					DispatchQueue.main.async {
						self.picturesToLoad = self.picturesToLoad + Int32(trackList.count)
						self.tracksList = trackList
					}
					self.loadPictures()
				case .failure(_):
					self.failedToLoad()
				}
			}
		}
	}
	
	private func loadPictures(){
		getAlbumPicture()
		
		for(i, track) in tracksList.enumerated() {
			if let link = track.pictureLink{
				if let url = URL(string: link){
					
					repo.getPicture(url: url){ result in
						switch(result){
						case .success(let data):
							DispatchQueue.main.async {
								self.tracksList[i].pictureData = data
								self.tracksList[i].pictureDownloaded = true
							}
						case .failure(_):
							break;
						}
						// Views wait for all pictures to be loaded to remove loading view
						DispatchQueue.main.async {
							self.pictureLoaded()
						}
					}
					
				}
			}
		}
	}
	
	private func getAlbumPicture(){
		if let link = album.pictureLink{
			if let url = URL(string: link){
				
				repo.getPicture(url: url){ result in
					switch(result){
					case .success(let data):
						DispatchQueue.main.async {
							self.album.pictureData = data
							self.album.pictureDownloaded = true
						}
					case .failure(_):
						break;
					}
					
					DispatchQueue.main.async {
						self.pictureLoaded()
					}
				}
				
			}
		}
	}
    
    // Used to keep count of loaded picture
    // in the playlist to remove the loading from the view
    private func pictureLoaded(){
		OSAtomicIncrement32(&loadedPictures)
		if(loadedPictures == picturesToLoad){
			loading = false
		}
    }
	
	private func failedToLoad(){
		
	}
	
	func navigateToPlayerView(index : Int){
		if(index < tracksList.count){
			clickedTrack = index
			navigateToPlayerView = true
			
		}
	}
}

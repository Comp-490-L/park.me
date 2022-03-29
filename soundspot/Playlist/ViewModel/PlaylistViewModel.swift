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
		if let url = URL(string: album.link){
			repo.getAlbumTracks(url: url) { result in
				switch(result){
				case .success(let trackList):
					DispatchQueue.main.async {
						self.loading = false
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
				}
			}
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

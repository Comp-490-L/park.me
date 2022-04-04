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
	
    
	// queue used to increament picture loaded and removes loading from view
	private var processQueue = DispatchQueue(label: "load queue")
	private var processed = 0
	private var picturesToBeProcessed = 0
	
	// Used for navigation link
	var clickedTrack = 0
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
		picturesToBeProcessed = 0
		processed = 0
		getAlbumPicture()
		
		for(i, track) in tracksList.enumerated() {
			if let link = track.pictureLink{
				if let url = URL(string: link){
					picturesToBeProcessed += 1
					repo.getPicture(url: url){ result in
						DispatchQueue.main.async {
							switch(result){
							case .success(let data):
								self.tracksList[i].pictureData = data
								self.tracksList[i].pictureDownloaded = true
							case .failure(_):
								break
							}
							self.incrementProcessedPictures()
						}
					}
					
				}
			}
		}
	}
	
	private func getAlbumPicture(){
		if let link = album.pictureLink{
			if let url = URL(string: link){
				picturesToBeProcessed += 1
				repo.getPicture(url: url){ result in
					DispatchQueue.main.async {
						switch(result){
							case .success(let data):
									self.album.pictureData = data
									self.album.pictureDownloaded = true
								
							case .failure(_):
								break;
						}
						self.incrementProcessedPictures()
					}
				}
				
			}
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
			if(processed == picturesToBeProcessed){
				loading = false
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

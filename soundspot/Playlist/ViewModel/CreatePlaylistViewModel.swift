//
//  CreatePlaylistViewModel.swift
//  soundspot
//
//  Created by Yassine Regragui on 4/22/22.
//

import Foundation

class CreatePlaylistViewModel : ObservableObject{
	
	@Published var title = ""
	@Published var creatingPlaylist = false
	var playlistViewModel = PlaylistViewModel(music: Playlist(id: "", title: "", link: "", pictureLink: nil, isLiked: false))
	@Published var navigateToPlaylist = false
	private lazy var musicRepo = MusicRepository()
	
	func onEvent(event: CreatePlaylistEvents){
		switch event {
		case .createPlaylist:
			createPlaylist()
		}
	}
	
	private func createPlaylist(){
		musicRepo.createPlaylist(title: title){ result in
			DispatchQueue.main.async {
				switch(result){
				case .success(let id):
					self.playlistViewModel.music.title = self.title
                    self.playlistViewModel.music.link = "\(Server.url)/api/Playlist?playlistId=\(id)"
                    self.playlistViewModel.music.id = id
					self.navigateToPlaylist = true
				case .failure(_):
					self.creatingPlaylist = false
				}
			}
		}
	}
}

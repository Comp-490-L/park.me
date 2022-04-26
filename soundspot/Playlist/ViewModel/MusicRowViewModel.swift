//
//  MusicRowViewModel.swift
//  soundspot
//
//  Created by Yassine Regragui on 4/20/22.
//

import Foundation
import SwiftUI

class MusicRowViewModel : ObservableObject{
	
	init(music : Music, index : Int, onClick : @escaping (Int) -> Void){
		self.music = music
		self.index = index
		self.onClick = onClick
	}
	
	// Music means track or album
	var music : Music

	var index : Int
	var onClick : (Int) -> Void
	
	
	private lazy var profileRepo = ProfileRepository()
	
	func onEvent(event : MusicRowEvents){
		switch event {
		case .heartClicked:
			if(music.isLiked){
				removeFromLiked()
			}else{
				addToLiked()
			}
		case .onClick:
			onClick(index)
		}
	}
	
	private func addToLiked(){
		music.isLiked = true
		switch music.self {
		case is Track:
			profileRepo.addTrackToLiked(trackId: music.id){ result in
				self.addToLikedResult(result: result)
			}
		case is Album:
			profileRepo.addAlbumToLiked(albumId: music.id){result in
				self.addToLikedResult(result: result)
			}
		default:
			return
		}
	}
	
	private func addToLikedResult(result: Swift.Result<Void, Error>){
		DispatchQueue.main.async {
			switch result{
			case .success(_):
				return
			case .failure(_):
				self.music.isLiked = false
			}
		}
	}
	
	private func removeFromLiked(){
		
	}
}

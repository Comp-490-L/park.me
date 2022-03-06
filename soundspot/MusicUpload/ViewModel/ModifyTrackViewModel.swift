//
//  ModifyTrackViewModel.swift
//  soundspot
//
//  Created by Yassine Regragui on 3/4/22.
//

import Foundation
import SwiftUI

class ModifyTrackViewModel : ObservableObject{
	init(_ track : TrackUpload){
		self.track = track
		
		if let pictureURL = track.pictureURL{
			let fileManager = FileManager.default
			if fileManager.fileExists(atPath: pictureURL.path){
				do{
					trackImage = try getImage(url: pictureURL)
				}catch{}
			}
		}

		self.uphViewModel = UPHViewModel(placeholder: "Track title", title: track.name , pictureURL: track.pictureURL)
	}
	var track : TrackUpload
	@Published var showPhotoLibrary = false
	@Published var trackImage : Image = Image("defaultTrackImg")
	
	// Shows the file picker to choose picture for album artwork
	@Published var showImageFilePicker = false
	var uphViewModel : UPHViewModel = UPHViewModel(placeholder: "Track title", title: "", pictureURL: nil)
	
	/*
	func picturePicked(_ image : UIImage){
		trackImage = Image(uiImage: image)
	}
	
	func picturePicked(_ imageList : [URL]){
		if(imageList.isEmpty){
			return
		}
		
		do{
			trackImage = try getImage(url: imageList[0])
		}catch{}
	}
	*/
	
	private func getImage(url : URL) throws -> Image{
		let fileManager = FileManager.default
		if fileManager.fileExists(atPath: url.path){
			let imageData = UIImage(contentsOfFile: url.path)
				if let imageData = imageData{
					return Image(uiImage: imageData)
				}
		}
		throw ModifyTrackError.NoSuchFileExists 
	}
	
	private enum ModifyTrackError : Error{
		case NoSuchFileExists
	}
}

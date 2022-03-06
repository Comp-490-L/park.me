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
		self.uphViewModel = UPHViewModel(placeholder: "Track title", headerData: track)
		
		if let pictureURL = track.pictureURL{
			let fileManager = FileManager.default
			if fileManager.fileExists(atPath: pictureURL.path){
				do{
					trackImage = try getImage(url: pictureURL)
				}catch{}
			}
		}
	}
	
	
	var track : TrackUpload
	@Published var showPhotoLibrary = false
	@Published var trackImage : Image = Image("defaultTrackImg")
	
	// Shows the file picker to choose picture for album artwork
	@Published var showImageFilePicker = false
	var uphViewModel : UPHViewModel
	
	
	
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

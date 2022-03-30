//
//  UPHViewModel.swift
//  soundspot
//
//  Created by Yassine Regragui on 3/4/22.
//

import Foundation
import SwiftUI
import Combine

class UHViewModel : ObservableObject{
	init(placeholder : String, headerData: PageHeaderData, titleError :  AnyPublisher<Bool, Never>){
		self.placeholder = placeholder
		self.headerData = headerData
		self.titleError = titleError
		if let pictureURL = headerData.pictureURL {
			if let image = UIImage(contentsOfFile: pictureURL.path){
				self.picture = Image(uiImage: image)
			}
		}
	}
	
	let placeholder : String
	@Published var headerData : PageHeaderData
	
	var titleError : AnyPublisher<Bool, Never>
	@Published var showTitleError = false
	
	@Published var picture : Image = Image("defaultTrackImg")

	func onLoad(){
		titleError.subscribe(Subscribers.Sink<Bool, Never>(
			receiveCompletion: {_ in },
			receiveValue:{ hasError in
				if(hasError){
					self.showTitleError = true
				}
			}
		))
	}

	func picturePicked(_ image : UIImage){
		if let imageData = image.jpegData(compressionQuality: 1){
			do{
				if let pictureURL = headerData.pictureURL {
					try FileManager.overwriteFile(overwrite: pictureURL, data: imageData)
				}else{
					
					headerData.pictureURL = try FileManager.saveAsJPEGFile(fileName: FileManager.getRandomJPEGFileName(), data: imageData)
				}
				picture = Image(uiImage: image)
			}catch{
				print("\nImage cannot be saved\n")
			} // TODO show error: Image cannot be saved to be uploaded later to server
		}
	}
	
	func picturePicked(_ imageList : [URL]){
		if(imageList.isEmpty){
			return
		}
		
		
		let fileManager = FileManager.default
		if fileManager.fileExists(atPath: imageList[0].path){
			
			// Track does not have artwork
			if(headerData.pictureURL == nil){
				let documentDirectoryUrl = try! FileManager.default.url(
				   for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
				
				let pictureURL = documentDirectoryUrl.appendingPathComponent(FileManager.getRandomJPEGFileName())
				let fileManager = FileManager.default
				
					do{
						try fileManager.copyItem(at: imageList[0], to: pictureURL)
						let imageData = try SwiftUI.Data(contentsOf: pictureURL)
						if let uiImage = UIImage(data: imageData){
							picture = Image(uiImage: uiImage)
						}
						headerData.pictureURL = pictureURL
					}catch{} // TODO show error
				
				return
			}
			
			
			// Replace Artwork
			else if let savedPictureURL = headerData.pictureURL {
				do{
					try FileManager.overwriteFile(overwrite: savedPictureURL, with: imageList[0])
					let imageData = try SwiftUI.Data(contentsOf: savedPictureURL)
					if let uiImage = UIImage(data: imageData){
						picture = Image(uiImage: uiImage)
					}
				}catch{
					print("\nImage cannot be saved\n")
				} // TODO show error: Image cannot be saved to be uploaded later to server
			}
		}
	}
}

enum UPHError : Error{
	case ErrorSavingFile
}

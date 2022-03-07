//
//  UPHViewModel.swift
//  soundspot
//
//  Created by Yassine Regragui on 3/4/22.
//

import Foundation
import SwiftUI

class UPHViewModel : ObservableObject{
	init(placeholder : String, headerData : PageHeaderData){
		print("UPH called \(placeholder)")
		self.placeholder = placeholder
		self.headerData = headerData
		if let pictureURL = headerData.pictureURL {
			if let image = UIImage(contentsOfFile: pictureURL.path){
				self.picture = Image(uiImage: image)
			}
		}
	}
	
	let placeholder : String
	@Published var headerData : PageHeaderData
	@Published var picture : Image = Image("defaultTrackImg")


	func picturePicked(_ image : UIImage){
		if let imageData = image.jpegData(compressionQuality: 1){
			do{
				if let pictureURL = headerData.pictureURL {
					try FileManager.overwriteFile(fileURL: pictureURL, data: imageData)
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
				headerData.pictureURL = documentDirectoryUrl.appendingPathComponent(FileManager.getRandomJPEGFileName())
				let fileManager = FileManager.default
				if let pictureURL = headerData.pictureURL {
					do{
						try fileManager.copyItem(at: imageList[0], to: pictureURL)
						let imageData = try SwiftUI.Data(contentsOf: pictureURL)
						if let uiImage = UIImage(data: imageData){
							picture = Image(uiImage: uiImage)
						}
					}catch{} // TODO show error
				} // TODO show error
				return
			}
			
			
			// Replace Artwork
			else if let pictureURL = headerData.pictureURL {
				do{
					try FileManager.overwriteFile(fileURL: pictureURL, replacementURL: imageList[0])
					let imageData = UIImage(contentsOfFile: imageList[0].path)
						if let imageData = imageData{
							picture = Image(uiImage: imageData)
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

//
//  TrackUpload.swift
//  soundspot
//
//  Created by Yassine Regragui on 3/2/22.
//

import Foundation

class TrackUpload : HashableClass, PageHeaderData, ObservableObject{
	
	init(name: String, pictureURL: URL?, fileURL: URL, artists: String){
		self.name = name
		self.pictureURL = pictureURL
		self.fileURL = fileURL
		self.artists = artists
	}
	
	static func == (lhs: TrackUpload, rhs: TrackUpload) -> Bool {
		false
	}
	
	@Published var name : String = ""
	@Published var pictureURL : URL?
    var fileURL : URL
	var artists : String
	@Published var uploadProgress : Double = 0.0
	@Published var uploading = false
}

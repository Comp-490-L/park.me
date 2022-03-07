//
//  TrackUpload.swift
//  soundspot
//
//  Created by Yassine Regragui on 3/2/22.
//

import Foundation

class TrackUpload : HashableClass, PageHeaderData{
	init(name: String, pictureURL: URL?, fileURL: URL, artists: [String]){
		self.name = name
		self.pictureURL = pictureURL
		self.fileURL = fileURL
		self.artists = artists
	}
	
	static func == (lhs: TrackUpload, rhs: TrackUpload) -> Bool {
		false
	}
	
	var name : String = ""
    var pictureURL : URL?
    var fileURL : URL
	var artists : [String]
}

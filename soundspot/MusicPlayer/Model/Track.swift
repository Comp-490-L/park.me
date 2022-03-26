//
//  Track.swift
//  soundspot
//
//  Created by Yassine Regragui on 3/15/22.
//

import Foundation

struct Track : Music, Codable, Hashable{
	
	init(name : String, link: String, trackDownloaded : Bool, pictureLink : String?, pictureDownloaded : Bool, pictureData: Data? ){
		self.title = name
		self.link = link
		self.trackDownloaded = trackDownloaded
		self.pictureLink = pictureLink
		self.pictureDownloaded = pictureDownloaded
		self.pictureData = pictureData
	}
	
	var title: String
	var link: String
	var trackDownloaded: Bool = false
	var pictureLink: String?
	var pictureDownloaded: Bool = false
	var pictureData: Data? = nil
	
	// Decode only the following
	private enum CodingKeys: String, CodingKey {
			case title, link, pictureLink
		}
}

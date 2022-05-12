//
//  Track.swift
//  soundspot
//
//  Created by Yassine Regragui on 3/15/22.
//

import Foundation

class Track : Music, Codable, Hashable{
	static func == (lhs: Track, rhs: Track) -> Bool {
		false
	}
	
	
	func hash(into hasher: inout Hasher) {
		hasher.combine(id)
	}
	
	init(id: String, name : String, link: String, trackDownloaded : Bool, pictureLink : String?, pictureDownloaded : Bool, pictureData: Data?,
         isLiked : Bool, owner: Bool, streams: Int){
		self.id = id
		self.title = name
		self.link = link
		self.trackDownloaded = trackDownloaded
		self.pictureLink = pictureLink
		self.pictureDownloaded = pictureDownloaded
		self.pictureData = pictureData
		self.isLiked = isLiked
        self.owner = owner
        self.streams = streams
	}
	

	
	var id: String
	var title: String
	var link: String
	var trackDownloaded: Bool = false
	var pictureLink: String?
	var pictureDownloaded: Bool = false
	var pictureData: Data? = nil
	var isLiked: Bool
    var owner : Bool
    var streams: Int
	
	// Decode only the following
	private enum CodingKeys: String, CodingKey {
        case id, title, link, pictureLink, isLiked, owner, streams
		}
}

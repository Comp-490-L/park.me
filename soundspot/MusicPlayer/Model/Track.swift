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
		 isLiked : Bool){
		self.id = id
		self.title = name
		self.link = link
		self.trackDownloaded = trackDownloaded
		self.pictureLink = pictureLink
		self.pictureDownloaded = pictureDownloaded
		self.pictureData = pictureData
		self.isLiked = isLiked
	}
	
	/*
	// Encodable
	func encode(to encoder : Encoder) throws{
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(id, forKey: .id)
		try container.encode(title, forKey: .title)
		try container.encode(link, forKey: .link)
		try container.encode(pictureLink, forKey: .pictureLink)
		try container.encode(isLiked, forKey: .isLiked)
	}
	
	// Decodable
	required init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decode(String.self, forKey: .id)
		title = try values.decode(String.self, forKey: .title)
		link = try values.decode(String.self, forKey: .link)
		pictureLink = try values.decode(String.self, forKey: .pictureLink)
		isLiked = try values.decode(Bool.self, forKey: .isLiked)
	}
	*/
	
	var id: String
	var title: String
	var link: String
	var trackDownloaded: Bool = false
	var pictureLink: String?
	var pictureDownloaded: Bool = false
	var pictureData: Data? = nil
	var isLiked: Bool
	
	// Decode only the following
	private enum CodingKeys: String, CodingKey {
			case id, title, link, pictureLink, isLiked
		}
}

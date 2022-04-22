//
//  Album.swift
//  soundspot
//
//  Created by Yassine Regragui on 3/25/22.
//

import Foundation

struct Album : Music, Codable, Hashable{
	static func == (lhs: Album, rhs: Album) -> Bool {
		return false
	}
	
	
	init(id: String, name : String, link: String, pictureLink : String?, pictureDownloaded : Bool, pictureData: Data?, isLiked: Bool ){
		self.id = id
		self.title = name
		self.link = link
		self.pictureLink = pictureLink
		self.pictureDownloaded = pictureDownloaded
		self.pictureData = pictureData
		self.isLiked = isLiked
	}
	
	var id: String
	var title: String
	var link: String
	var pictureLink: String?
	var pictureDownloaded: Bool = false
	var pictureData: Data? = nil
	var isLiked: Bool
	
	// Decode only the following
	private enum CodingKeys: String, CodingKey {
			case id, title, link, pictureLink, isLiked
		}
}

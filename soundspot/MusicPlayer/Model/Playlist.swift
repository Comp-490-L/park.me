//
//  Playlist.swift
//  soundspot
//
//  Created by Yassine Regragui on 4/22/22.
//

import Foundation

class Playlist : Music, Codable{
	init(id: String, title: String, link: String, pictureLink: String?, isLiked: Bool){
		self.id = id
		self.title = title
		self.link = link
		self.pictureLink = pictureLink
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

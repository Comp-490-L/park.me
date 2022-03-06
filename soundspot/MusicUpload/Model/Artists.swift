//
//  Artists.swift
//  soundspot
//
//  Created by Yassine Regragui on 3/4/22.
//

import Foundation

class Artists : HashableClass{
	init(uploader: String, collaborators: [String]){
		self.uploader = uploader
		self.collaborators = collaborators
	}
	var uploader : String
	var collaborators: [String]
}

//
//  AvailableTracksRequest.swift
//  soundspot
//
//  Created by Yassine Regragui on 4/25/22.
//

import Foundation

class AvailableTrackRequest : Codable{
	init(newestTrack: String, oldestTrack: String){
		self.newestTrack = newestTrack
		self.oldestTrack = oldestTrack
	}
	var newestTrack = ""
	var oldestTrack = ""
}

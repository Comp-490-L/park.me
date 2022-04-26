//
//  AvailableTracks.swift
//  soundspot
//
//  Created by Yassine Regragui on 4/5/22.
//

import Foundation


class AvailableTracks : Decodable{
    var tracks = Array<Track>()
	var newest : String? = nil
	var oldest : String? = nil
}

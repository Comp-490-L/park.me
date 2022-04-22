//
//  AvailableTracks.swift
//  soundspot
//
//  Created by Yassine Regragui on 4/5/22.
//

import Foundation


struct AvailableTracks : Decodable{
    var tracks = [Track]()
	var loadMoreURL : URL? = nil
}

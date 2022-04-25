//
//  ProfileModel.swift
//  soundspot
//
//  Created by Yassine Regragui on 12/5/21.
//

import Foundation
import SwiftUI

class ProfileModel : Codable{
	static func == (lhs: ProfileModel, rhs: ProfileModel) -> Bool {
		return false
	}
    
    init(
     profileLink: String,
     displayName: String,
     biography: String,
     singlesList:  Array<Track>,
     albumsList: Array<Album>,
     playlistList: Array<Playlist>,
     pictureLink : String,
     image : Image? ){
         self.profileLink = profileLink
         self.displayName = displayName
         self.biography = biography
         self.singlesList = singlesList
         self.albumsList = albumsList
         self.playlistList = playlistList
         self.pictureLink = pictureLink
         self.image = image
     }
    
	
    var profileLink: String = ""
    var displayName: String = ""
    var biography: String = ""
    var singlesList = Array<Track>()
    var albumsList = Array<Album>()
	var playlistList = Array<Playlist>()
    var pictureLink : String? = ""
    var image : Image? = nil
    
    private enum CodingKeys: String, CodingKey{
        case profileLink
        case displayName
        case biography
        case singlesList
        case albumsList
        case playlistList
        case pictureLink
    }
}





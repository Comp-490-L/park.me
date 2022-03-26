//
//  ProfileModel.swift
//  soundspot
//
//  Created by Yassine Regragui on 12/5/21.
//

import Foundation

struct ProfileModel : Codable, Hashable{
    var profileLink: String
    var displayName: String
    var biography: String
    var singlesList: Array<Track>
    var albumsList: Array<Album>
}





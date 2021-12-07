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
    var singlesList: Array<MusicModel>?
    var albumsList: Array<MusicModel>?
}

struct MusicModel : Codable, Hashable{
    var name: String
    var link: String
    var trackDownloaded: Bool = false
    var pictureLink: String?
    var pictureDownloaded: Bool = false
    var pictureData: Data? = nil
    
    // Decode only the following
    private enum CodingKeys: String, CodingKey {
            case name, link, pictureLink
        }
}


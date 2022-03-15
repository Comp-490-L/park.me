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
    var singlesList: Array<Track>?
    var albumsList: Array<Track>?
}

struct Track : Codable, Hashable{
    
    init(name : String, link: String, trackDownloaded : Bool, pictureLink : String?, pictureDownloaded : Bool, pictureData: Data? ){
        self.name = name
        self.link = link
        self.trackDownloaded = trackDownloaded
        self.pictureLink = pictureLink
        self.pictureDownloaded = pictureDownloaded
        self.pictureData = pictureData
    }
    
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



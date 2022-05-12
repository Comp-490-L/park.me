//
//  ContainedIn.swift
//  soundspot
//
//  Created by Yassine Regragui on 5/11/22.
//

import Foundation

struct ContainedIn{
    var container : Container
    var id : String
}

enum Container{
    case Track, Playlist, Album
}

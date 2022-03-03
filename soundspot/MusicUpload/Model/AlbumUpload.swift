//
//  AlbumUpload.swift
//  soundspot
//
//  Created by Yassine Regragui on 3/2/22.
//

import Foundation

class AlbumUpload : ObservableObject{
    @Published var name : String = ""
    var albumId: String? = nil
}

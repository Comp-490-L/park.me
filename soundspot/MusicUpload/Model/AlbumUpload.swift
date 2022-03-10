//
//  AlbumUpload.swift
//  soundspot
//
//  Created by Yassine Regragui on 3/2/22.
//

import Foundation

class AlbumUpload : PageHeaderData, ObservableObject{
    @Published var title : String = ""
    var albumId: String? = nil
	var pictureURL: URL? = nil
}

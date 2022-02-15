//
//  Track.swift
//  soundspot
//
//  Created by Yassine Regragui on 12/3/21.
//

import Foundation.NSURL

//
// MARK: - Track
//

class Track {
  //
  // MARK: - Constants
  //
  let artist: String
  let index: Int
  let name: String
  let previewURL: URL
  
  //
  // MARK: - Variables And Properties
  //
  var downloaded = false
  
  //
  // MARK: - Initialization
  //
  init(name: String, artist: String, previewURL: URL, index: Int) {
    self.name = name
    self.artist = artist
    self.previewURL = previewURL
    self.index = index
  }
}

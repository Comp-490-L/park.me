//
//  Downlod.swift
//  soundspot
//
//  Created by Yassine Regragui on 12/3/21.
//

import Foundation

class Download {
  var isDownloading = false
  var progress: Float = 0
  var resumeData: Data?
  var task: URLSessionDownloadTask?
  var track: Track
  
  init(track: Track) {
    self.track = track
  }
}

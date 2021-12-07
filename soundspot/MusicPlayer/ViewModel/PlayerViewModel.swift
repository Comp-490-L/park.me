//
//  ViewModel.swift
//  soundspot
//
//  Created by Yassine Regragui on 12/3/21.
//

import Foundation
import AVFoundation


class PlayerViewModel : ObservableObject{
    init(trackList: Array<MusicModel>, trackIndex: Int){
        self.trackList = trackList
        current = trackIndex
        //player = nil
        //isPlaying = false
    }
    @Published var trackList: Array<MusicModel>
    @Published var current: Int
    //var player: AVPlayer? = nil
    //@Published var isPlaying : Bool = false
    
    var downloadService = DownloadService()
    let instance = Session()
    lazy var downloadsSession: URLSession = URLSession(configuration: URLSessionConfiguration.default, delegate: instance, delegateQueue: nil)
    
    func PlayTrack() -> URL?{
        let url = trackList[current].link
        if(url == ""){
            print("Track url is empty")
            return nil
        }
            
        print("Downloading \(url)")
        let track = Track(name: "", artist: "", previewURL: URL(string: url)!, index: 0)
        return downloadService.startDownload(track)
    }
    
    // After the view is loaded load downloadTask
    func LoadSession(){
        print("Load Session called")
        downloadService.downloadsSession = downloadsSession
    }
    
    func downloadComplete (data: Data?, response: URLResponse?, error: Error?) {
        
    }
}

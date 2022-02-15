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
        self.trackIndex = trackIndex
    }
    @Published var trackList: Array<MusicModel>
    @Published var trackIndex: Int
    @Published var isPlaying : Bool = false
    // Slider progress in percent
    @Published var progressPercentage : Double = 0
    private var player: AVPlayer? = nil
    private var timeObserverToken : Any?
    @Published var trackLength = "0:00"
    @Published var progress = "0:00"
    private var trackLengthInSeconds : Double = 0
    
    
    var downloadService = DownloadService()
    let instance = Session()
    lazy var downloadsSession: URLSession = URLSession(configuration: URLSessionConfiguration.default, delegate: instance, delegateQueue: nil)
    
    
    func onEvent(event : MusicPlayerEvent) -> Void{
        switch event {
        case .Launched:
            playTrack()
        case .PlayPausePressed:
            playPause()
        case .PreviousPressed:
            playPreviousTrack()
        case .NextPressed:
            playNextTrack()
        case .SliderChanged:
            print(progressPercentage)
        }
    }
    
    private func playTrack() {
        loadSession()
        // Track download link
        guard let trackLink = getCurrentTrackURL() else {return}
        let fileURL = downloadTrack(link: trackLink)
        if(fileURL != nil){
            do{
                try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            }
            catch{}
            print("\n\n Playing fileURL \(fileURL)")
           
            player = AVPlayer(url: fileURL!)
            playPause()
            addPeriodicTimeObserver()
            if let duration = player?.currentItem?.asset.duration {
                trackLength = duration.positionalTime
                trackLengthInSeconds = duration.roundedSeconds
            }
            if(player == nil){
                print("player is nil")
            }
            
        }else{
            print("Audio file is nil")
        }
    }
    
    private func addPeriodicTimeObserver() {
        if(player == nil){return}
        // Notify every half second
        let timeScale = CMTimeScale(NSEC_PER_SEC)
        let time = CMTime(seconds: 0.5, preferredTimescale: timeScale)

        timeObserverToken = player!.addPeriodicTimeObserver(forInterval: time,
                                                          queue: .main) {
            [weak self] time in
            // update player transport UI
            self?.progress = time.positionalTime
            if let seconds = self?.trackLengthInSeconds{
                self?.progressPercentage = (((time.roundedSeconds / seconds) * 100).rounded())
                
            }
        }
    }

    private func removePeriodicTimeObserver() {
        if(player == nil){return}
        if let timeObserverToken = timeObserverToken {
            player!.removeTimeObserver(timeObserverToken)
            self.timeObserverToken = nil
        }
    }
    
    private func playNextTrack(){}
    
    private func playPreviousTrack(){}
    
    private func getCurrentTrackURL() -> String? {
        if(trackList.count - 1 < trackIndex){
            return nil
        }
        let link = trackList[trackIndex].link
        if(link == ""){
            print("Track url is empty")
            return nil
        }
        return link
    }
    
    private func downloadTrack(link : String) -> URL? {
        print("Downloading \(link)")
        let track = Track(name: "", artist: "", previewURL: URL(string: link)!, index: 0)
        return downloadService.startDownload(track)
    }
    
    private func playPause()
    {
        isPlaying.toggle()
        if isPlaying == false{
            player?.pause()
        }else{
            player?.play()
        }
    }
    
   
    
    // After the view is loaded load downloadTask
    private func loadSession(){
        print("Load Session called")
        downloadService.downloadsSession = downloadsSession
    }
    
    /*func downloadComplete (data: Data?, response: URLResponse?, error: Error?) {
        
    }*/
}



extension CMTime {
    var roundedSeconds: TimeInterval {
        return seconds.rounded()
    }
    var hours:  Int { return Int(roundedSeconds / 3600) }
    var minute: Int { return Int(roundedSeconds.truncatingRemainder(dividingBy: 3600) / 60) }
    var second: Int { return Int(roundedSeconds.truncatingRemainder(dividingBy: 60)) }
    var positionalTime: String {
        return hours > 0 ?
            String(format: "%d:%02d:%02d",
                   hours, minute, second) :
            String(format: "%02d:%02d",
                   minute, second)
    }
}

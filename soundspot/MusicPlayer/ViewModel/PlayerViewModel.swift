//
//  ViewModel.swift
//  soundspot
//
//  Created by Yassine Regragui on 12/3/21.
//

import Foundation
import AVFoundation
import UIKit


class PlayerViewModel : ObservableObject{
    init(trackList: Array<Track>, trackIndex: Int){
        self.trackList = trackList
        self.trackIndex = trackIndex
    }
    @Published var trackList: Array<Track>
    @Published var trackIndex: Int
    @Published var isPlaying : Bool = false
    // Slider progress from 0 to 100
    @Published var progressPercentage : Double = 0
    private var player: AVPlayer? = nil
    private var timeObserverToken : Any?
    @Published var trackLength = "00:00"
    @Published var progress = "00:00"
    private var trackLengthInSeconds : Double = 0
    private var isDraggingSlider : Bool = false
    private var trackEnded = false
    
    
    var downloadService = DownloadService()
    let instance = Session()
    lazy var downloadsSession: URLSession = URLSession(configuration: URLSessionConfiguration.default, delegate: instance, delegateQueue: nil)
    
    /*override func willMove(toParent parent: UIViewController?){
        super.willMove(toParent: parent)
        if parent == nil {
            
        }
    }*/
    
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
            updatePlayerProgress()
        case .DraggingSlider:
            DraggingSlider()
        }
    }
    
    private func playTrack() {
        loadSession()
        // Track download link
	
        let fileURL = downloadTrack(index: trackIndex)
        if(fileURL != nil){
            do{
                try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            }
            catch{}
            
            player = AVPlayer(url: fileURL!)
            // Adds an observer to the player state that will call playerDidFinishPlaying() when the track end
            NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
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
    
    @objc func playerDidFinishPlaying(){
        trackEnded = true
        playPause()
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
            // if the user is not dragging the slider
            if(!(self?.isDraggingSlider ?? true)){
                self?.progress = time.positionalTime
                if let seconds = self?.trackLengthInSeconds{
                    self?.progressPercentage = (((time.roundedSeconds / seconds) * 100).rounded())
                    }
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
    
    private func updatePlayerProgress(){
        let newProgress = (trackLengthInSeconds * (progressPercentage / 100)).rounded()
        let timeScale = CMTimeScale(NSEC_PER_SEC)
        let time = CMTime(seconds: newProgress, preferredTimescale: timeScale)
        if let player = player {
            player.seek(to: time)
        }
        progressPercentage = newProgress
        isDraggingSlider = false
    }
    
    private func DraggingSlider(){
        isDraggingSlider = true
        // gets slider progress and formats it to string
        let newProgress = (trackLengthInSeconds * (progressPercentage / 100)).rounded()
        let timeScale = CMTimeScale(NSEC_PER_SEC)
        let time = CMTime(seconds: newProgress, preferredTimescale: timeScale)
        // update time text to match slider progress
        progress = time.positionalTime
    }
    
    
    
    private func playNextTrack() {
		let fileURL = downloadTrack(index: increaseIndex()) // TODO don't download if next track is current track (same for previous)
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
    
    private func playPreviousTrack() {
        let fileURL = downloadTrack(index: decreaseIndex())
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
    
    
    private func increaseIndex() -> Int {
        if (trackIndex + 1 > trackList.count) {
			trackIndex = 0
        }
        else {
            trackIndex = trackIndex + 1
        }
        
        return trackIndex
    }
    
    private func decreaseIndex() -> Int {
  
        if (trackIndex - 1 < 0) {
            trackIndex = trackList.count - 1
        }
        else {
            trackIndex = trackIndex - 1
        }
        return trackIndex
    }
    
	private func downloadTrack(index : Int) -> URL? {
        return downloadService.startDownload(trackList[index])
    }
    
    private func playPause()
    {
        isPlaying.toggle()
        if isPlaying == false{
            player?.pause()
        }else{
            if(trackEnded){
                progressPercentage = 0
                updatePlayerProgress()
                trackEnded.toggle()
            }
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

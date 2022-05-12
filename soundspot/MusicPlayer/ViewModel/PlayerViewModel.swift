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
    
	/**
	 This class is used as a singleton
	 Use PlayerViewModel.getInstance()
	 */
	private init(){}
	
    @Published var trackList = Array<Track>()
    @Published var trackIndex: Int = 0
    @Published var isPlaying : Bool = false
    @Published var isShuffle : Bool = false
    @Published var isLiked   : Bool = false
    // Slider progress from 0 to 100
    @Published var progressPercentage : Double = 0
	
	private lazy var player = AVPlayer()
	
    private var timeObserverToken : Any?
    @Published var trackLength = "00:00"
    @Published var progress = "00:00"
    private var trackLengthInSeconds : Double = 0
    private var isDraggingSlider : Bool = false
    private var trackEnded = false
    private var streamed : Double = 0.0
    private var streamCounterUpdated = false
    
    private lazy var musicRepo = MusicRepository()

	private static var instance = PlayerViewModel()
	
	static func getInstance() -> PlayerViewModel{
		return instance
	}
	
	static func instancePlayTracks(tracksList: [Track], index : Int) -> PlayerViewModel{
		instance.trackList = tracksList
		instance.trackIndex = index
		instance.playTrack()
		return instance
	}
    
    func onEvent(event : MusicPlayerEvent) -> Void{
        switch event {
        case .Launched:
            PlayerLaunched()
        case .PlayPausePressed:
            playPauseBtnPressed()
        case .PreviousPressed:
            playPreviousTrack()
        case .NextPressed:
            playNextTrack()
        case .ShufflePressed:
            shuffleSongs()
        case .LikePressed:
            likeSong()
        case .SliderChanged:
            updatePlayerProgress()
        case .DraggingSlider:
            DraggingSlider()
        }
    }
    
	func resetPlayer(tracks: [Track]){
		playerPause()
		trackList = tracks
		trackIndex = 0
	}
	
	func setTrackIndex(_ index : Int){
		trackIndex = index
	}
	
	func addToQueue(track : Track){
		trackList.append(track)
	}
	
	func addToQueue(tracks : [Track]){
		trackList.append(contentsOf: tracks)
	}
	
	private func PlayerLaunched(){
		playTrack()
	}
	
	/**
	 Starts a track from the begining based on trackIndex
	 Change trackIndex before calling
	 */
	private func playTrack(){
		if let url = URL(string: trackList[trackIndex].link) {

			let urlAsset = AVURLAsset(url: url, options: ["AVURLAssetHTTPHeaderFieldsKey": ["Authorization": "Bearer \(UserAuthRepository.getToken())"]])
			
			let playerItem = AVPlayerItem(asset: urlAsset)
			player.replaceCurrentItem(with: playerItem)
			
			// Adds an observer to the player state that will call playerDidFinishPlaying() when the track end
			NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
			if(!isPlaying){
				playerPlay()
			}
			addPeriodicTimeObserver()
			if let duration = player.currentItem?.asset.duration {
				trackLength = duration.positionalTime
				trackLengthInSeconds = duration.roundedSeconds
			}
		}else{
			print("wrong url")
		}
	}
    
    @objc func playerDidFinishPlaying(){
        trackEnded = true
        streamed = 0.0
        streamCounterUpdated = false
        playPauseBtnPressed()
    }
    
    private func addPeriodicTimeObserver() {
        // Notify every half second
        let timeScale = CMTimeScale(NSEC_PER_SEC)
        let time = CMTime(seconds: 0.5, preferredTimescale: timeScale)

        timeObserverToken = player.addPeriodicTimeObserver(forInterval: time,
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
        if let timeObserverToken = timeObserverToken {
            player.removeTimeObserver(timeObserverToken)
            self.timeObserverToken = nil
        }
    }
    
    private func addStreamedSeconds(){
        if(isPlaying){
            streamed = streamed + 0.5
        }
        if(streamed > 10 && !streamCounterUpdated){
            DispatchQueue.global().async {
                [self] in
                musicRepo.increaseStreamCount(trackId: trackList[trackIndex].id)
            }
        }
        
    }
    
    private func updatePlayerProgress(){
        let newProgress = (trackLengthInSeconds * (progressPercentage / 100)).rounded()
        let timeScale = CMTimeScale(NSEC_PER_SEC)
        let time = CMTime(seconds: newProgress, preferredTimescale: timeScale)
        
		player.seek(to: time)
        
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
		increaseIndex()
		playTrack()
	}
    private func playPreviousTrack() {
		decreaseIndex()
		playTrack()
    }
    
    
    private func increaseIndex(){
        if (trackIndex + 1 >= trackList.count) {
			trackIndex = 0
        }
        else {
            trackIndex = trackIndex + 1
        }
    }
    
    private func decreaseIndex() {
  
        if (trackIndex - 1 < 0) {
            trackIndex = trackList.count - 1
        }
        else {
            trackIndex = trackIndex - 1
        }
    }
    
    
	private func playerPlay(){
		player.play()
		isPlaying = true
	}
	
	private func playerPause(){
		player.pause()
		isPlaying = false
	}
	
	/**
	 function used by play pause button only
	 */
    private func playPauseBtnPressed()
    {
        isPlaying.toggle()
        if isPlaying == false{
            player.pause()
        }else{
            if(trackEnded){
                progressPercentage = 0
                updatePlayerProgress()
                trackEnded.toggle()
				trackEnded = false
				playNextTrack()
            }
            player.play()
        }
    }
    
    private func shuffleSongs()
    {
        if (isShuffle == false)
        {
            isShuffle = true
        }
        else
        {
            isShuffle = false
        }
    }
    
    private func likeSong()
    {
        if (isLiked == false)
        {
            isLiked = true
        }
        else
        {
            isLiked = false
        }
    }
    
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

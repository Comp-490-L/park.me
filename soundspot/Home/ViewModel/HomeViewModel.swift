//
//  HomeViewModel.swift
//  soundspot
//
//  Created by Yassine Regragui on 3/10/22.
//

import Foundation

class HomeViewModel : ObservableObject{
	
	@Published var availableTracks = AvailableTracks()
    @Published var loadingAvailableTracks = true
    private (set) var clickedTrack = 0
    @Published var navigateToPlayer = false
	private lazy var musicRepo = MusicRepository()
	@Published private (set) var endOfTracks = false
    @Published var trending = [Track]()
    
    func onEvent(event : HomeViewEvent){
        switch event {
        case .onLoad:
            onLoad()
        case .viewMoreTracks:
            loadMoreTracks()
        }
    }
    
    private func onLoad(){
        loadTrending()
		getAvailableTracks(newest: nil, oldest: nil, append: false)
    }
    
    func onTrackClicked(index: Int){
        clickedTrack = index
        _ = PlayerViewModel.instancePlayTracks(tracksList: availableTracks.tracks, index: index)
    }
	
	private func getAvailableTracks(newest: String?, oldest: String?, append : Bool){
		musicRepo.getAvailableTracks(newest: newest, oldest: oldest){ result in
			DispatchQueue.main.async{
				switch result{
				case .success(let availableTracks):
					if(availableTracks.tracks.count == 0){
						self.endOfTracks = true
						return
					}
					
					if(!append){
						self.availableTracks = availableTracks
                        self.loadPictures(tracks: self.availableTracks.tracks, start: 0)
					}else{
						let start = self.availableTracks.tracks.count
						self.availableTracks.tracks.append(contentsOf: availableTracks.tracks)
						self.availableTracks.newest = availableTracks.newest
						self.availableTracks.oldest = availableTracks.oldest
                        self.loadPictures(tracks: self.availableTracks.tracks, start: start)
					}
					self.endOfTracks = false
				case .failure(_):
					print("Failed to get pictures")
					break
				}
			}

		}
    }
	
	private func loadMoreTracks(){
		getAvailableTracks(newest: availableTracks.newest, oldest: availableTracks.oldest, append: true)
	}
	
    private func loadPictures(tracks: [Track], start : Int){
		for i in start..<tracks.count{
			if let pictureLink = tracks[i].pictureLink{
				let url = URL(string: pictureLink)
				guard let url = url else {
					return
				}
				musicRepo.getPicture(url: url){ result in
					DispatchQueue.main.async {
						[self] in
						switch result{
						case .success(let data):
							tracks[i].pictureData = data
							objectWillChange.send()
							tracks[i].pictureDownloaded = true
						case .failure(_):
							return
						}
					}
				}
			}
		}
	}
    
    private func loadTrending(){
        musicRepo.getTrending{ response in
            DispatchQueue.main.async {
                [self] in
                switch(response){
                case .success(let tracks):
                    trending = tracks
                    loadPictures(tracks: tracks, start: 0)
                case .failure(_):
                    return;
                }
            }
        }
    }
}

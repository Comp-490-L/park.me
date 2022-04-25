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
    
    func onEvent(event : HomeViewEvent){
        switch event {
        case .onLoad:
            onLoad()
        case .viewMoreTracks:
            loadMoreTracks()
        }
    }
    
    private func onLoad(){
		getAvailableTracks(newest: nil, oldest: nil, append: false)
    }
    
    func onTrackClicked(index: Int){
        clickedTrack = index
        navigateToPlayer = true
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
					}else{
						self.availableTracks.tracks.append(contentsOf: availableTracks.tracks)
						self.availableTracks.newest = availableTracks.newest
						self.availableTracks.oldest = availableTracks.oldest
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
		getAvailableTracks(newest: availableTracks.newest, oldest: availableTracks.newest, append: true)
		
	}
}

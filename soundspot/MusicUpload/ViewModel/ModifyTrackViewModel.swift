//
//  ModifyTrackViewModel.swift
//  soundspot
//
//  Created by Yassine Regragui on 3/4/22.
//

import Foundation
import SwiftUI
import Combine

class ModifyTrackViewModel : ObservableObject{
	init(_ track : TrackUpload){
		self.track = track
		self.errorPassthrough = PassthroughSubject<Bool, Never>()
		self.uphViewModel = UHViewModel(
			placeholder: "Track title",
			headerData: track,
			titleError: self.errorPassthrough.eraseToAnyPublisher())
	}
	
	@Published var track : TrackUpload
	var uphViewModel : UHViewModel
	var errorPassthrough : PassthroughSubject<Bool, Never>

	
	func backPressed(view : ModifyTrackView){
		if(track.title == ""){
			errorPassthrough.send(true)
		}else{
			view.mode.wrappedValue.dismiss()
		}
	}
}

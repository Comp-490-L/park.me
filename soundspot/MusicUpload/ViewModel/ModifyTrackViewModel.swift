//
//  ModifyTrackViewModel.swift
//  soundspot
//
//  Created by Yassine Regragui on 3/4/22.
//

import Foundation
import SwiftUI

class ModifyTrackViewModel : ObservableObject{
	init(_ track : TrackUpload){
		self.track = track
		self.uphViewModel = UPHViewModel(placeholder: "Track title", headerData: track)
	}
	
	@Published var track : TrackUpload
	var uphViewModel : UPHViewModel

}

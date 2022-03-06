//
//  ModifyTrack.swift
//  soundspot
//
//  Created by Yassine Regragui on 3/4/22.
//

import Foundation
import SwiftUI
import UniformTypeIdentifiers

struct ModifyTrack : View{
	@ObservedObject var viewModel : ModifyTrackViewModel
	var body: some View {
		VStack{
			VStack{
				UploadPageHeader(viewModel: viewModel.uphViewModel)
				Spacer()
				
			}.padding(.top, 60)
		}
		.background(Color.backgroundColor)
		.ignoresSafeArea(.all)
			.navigationBarHidden(false)
			.navigationBarBackButtonHidden(false)
	}
}





struct ModifyTrack_Previous : PreviewProvider{
	
	private static func getTrack() -> TrackUpload {
		let f = URL(string:
							"file:///Users/yassineregragui/Library/Developer/CoreSimulator/Devices/CB67FC80-ADA1-4179-8906-EC30F271B58D/data/Containers/Shared/AppGroup/C01D9C52-3FD1-4ABA-9CA0-887EEA24A32E/File%20Provider%20Storage/Young%20Scooter%20-%20Diamonds.mp3")!
		
		let a = Artists(uploader: "Username", collaborators: [String]())
		let track = TrackUpload(name: "Track name",
								pictureURL: nil,
								fileURL: f,
								artists: a)
		return track
	}
	
	static var previews: some View {
		ModifyTrack(viewModel: ModifyTrackViewModel(getTrack()))
	}
}

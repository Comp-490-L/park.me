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
			VStack(alignment: .leading){
				UploadPageHeader(viewModel: viewModel.uphViewModel)
				HStack{
					Text("Artists:").font(.title3)
				}
					ForEach(viewModel.track.artists.indices, id: \.self){ i in
						artistsCard(
							name: viewModel.track.artists[i],
							index: i,
							onXMarkClick: viewModel.onEvent)
						.padding(4)
						.overlay(RoundedRectangle(cornerRadius: 5)
									.stroke(Color.purple, lineWidth: 1))
					}
				
				HStack{
					TextField("Name", text: $viewModel.artist)
						.disableAutocorrection(true)
						.autocapitalization(UITextAutocapitalizationType.none)
					Spacer()
					Image(systemName: "plus").onTapGesture {
						viewModel.onEvent(event: ModifyTrackEvents.addArtist)
					}
				}.padding(.top, 10)
					.padding(.bottom, 10)
					.padding(.leading, 5)
					.padding(.trailing, 5)
				
				Spacer()
				
			}.padding(.top, 100)
				.padding(.horizontal)
		}
		.background(Color.backgroundColor)
		.ignoresSafeArea(.all)
			//.navigationBarHidden(true)
			//.navigationBarBackButtonHidden(false)
	}
}

struct artistsCard : View {
	var name : String
	var index: Int
	var onXMarkClick: (_ : ModifyTrackEvents) ->()
	@ViewBuilder var body: some View{
		HStack{
			Text(name)
			Image(systemName: "xmark").onTapGesture {
				onXMarkClick(ModifyTrackEvents.removeArtist(index: index))
			}
		}
	}
}






struct ModifyTrack_Previews : PreviewProvider{
	
	private static func getTrack() -> TrackUpload {
		let f = URL(string:
							"file:///Users/yassineregragui/Library/Developer/CoreSimulator/Devices/CB67FC80-ADA1-4179-8906-EC30F271B58D/data/Containers/Shared/AppGroup/C01D9C52-3FD1-4ABA-9CA0-887EEA24A32E/File%20Provider%20Storage/Young%20Scooter%20-%20Diamonds.mp3")!
		
	
		let track = TrackUpload(name: "Track name",
								pictureURL: nil,
								fileURL: f,
								artists: ["Yassine", "Mo"])
		return track
	}
	
	static var previews: some View {
		ModifyTrack(viewModel: ModifyTrackViewModel(getTrack())).previewDevice("iPhone 13 Pro")
	}
}

//
//  ModifyTrack.swift
//  soundspot
//
//  Created by Yassine Regragui on 3/4/22.
//

import Foundation
import SwiftUI
import UniformTypeIdentifiers

struct ModifyTrackView : View{
	@Environment(\.presentationMode) var mode: Binding<PresentationMode>
	@ObservedObject var viewModel : ModifyTrackViewModel
	
	var body: some View {
		
		VStack{
			
			VStack(alignment: .leading){
				Button("Back"){
					viewModel.backPressed(view: self)
				}
				
				VStack(alignment: .center){
				UploadHeaderView(viewModel: viewModel.uphViewModel)
					
				HStack{
					Text("Artists:").font(.title3)
					TextField("Names", text: $viewModel.track.artists)
						.disableAutocorrection(true)
						.autocapitalization(UITextAutocapitalizationType.none)
						.font(.title3)
				}
				
				
				Spacer()
				}
			}.padding(.top, 100)
				.padding(.horizontal)
		}
		.background(Color.backgroundColor)
		//.ignoresSafeArea(.all)
		.navigationBarTitle("")
		.navigationBarBackButtonHidden(true)
		 .navigationBarHidden(true)
		  .ignoresSafeArea(.all)
	}
}





struct ModifyTrack_Previews : PreviewProvider{
	
	private static func getTrack() -> TrackUpload {
		let f = URL(string:
							"file:///Users/yassineregragui/Library/Developer/CoreSimulator/Devices/CB67FC80-ADA1-4179-8906-EC30F271B58D/data/Containers/Shared/AppGroup/C01D9C52-3FD1-4ABA-9CA0-887EEA24A32E/File%20Provider%20Storage/Young%20Scooter%20-%20Diamonds.mp3")!
		
	
		let track = TrackUpload(title: "Track name",
								pictureURL: nil,
								fileURL: f,
								artists: "Yassine")
		return track
	}
	
	static var previews: some View {
		ModifyTrackView(viewModel: ModifyTrackViewModel(getTrack())).previewDevice("iPhone 13 Pro")
	}
}

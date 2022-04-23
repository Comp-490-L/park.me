//
//  PlaylistList.swift
//  soundspot
//
//  Created by James Maturino on 3/7/22.
//

import Foundation
import SwiftUI

struct PlaylistView: View
{
	@ObservedObject var viewModel : PlaylistViewModel
	var body: some View
	{
		VStack
		{
			if(viewModel.loading){
				ProgressView()
			}else{
				if(viewModel.music.pictureLink == nil){
					Image("defaultTrackImg")
						.resizable()
                        .frame(maxWidth: 150, maxHeight: 150)
				}else{
					if let data = viewModel.music.pictureData{
						if let image = UIImage(data: data){
							Image(uiImage: image)
                                .resizable()
                                .frame(maxWidth: 150, maxHeight: 150)
						}
					}
				}
				
				
				Text(viewModel.music.title)
				
				Text("Playlist Description")
					.font(.system(size:10))
				
				HStack
				{
					Spacer()
					Button(action:{})
					{
						Image(systemName: "play.circle.fill")
							.resizable()
							.frame(width: 60, height: 60, alignment: .leading)
					}
					
					Spacer()
					
					Menu
					{
						Button("Add songs", action:{})
						Button("Edit", action:{})
						Button("Make private", action:{})
						Button("Delete playlist", action:{})
					} label:
					{
						Label("", systemImage: "ellipsis").padding(15)
					}
					Spacer()
				}
				
				ForEach(0..<viewModel.tracksList.count, id: \.self){
					i in
					/*
					 MusicRow(
						 music: Binding(get: {
							 viewModel.tracksList[i]
						 }, set: {
							 viewModel.tracksList[i] = $0 as! Track
						 }),
						 heart: "", index: i,
						 onClick: viewModel.navigateToPlayerView)
					 */
					MusicRow(viewModel: MusicRowViewModel(
						music: viewModel.tracksList[i] as Music,
						index: i,
						onClick: viewModel.navigateToPlayerView))
				}
				Spacer()
			}
		}.onLoad{
			viewModel.onEvent(event: PlaylistEvent.onLoad)
		}
		
		NavigationLink(destination: PlayerView(viewModel: PlayerViewModel.instancePlayTracks(tracksList: viewModel.tracksList, index: viewModel.clickedTrack)), isActive: $viewModel.navigateToPlayerView){}
	}
}

struct PlaylistView_Previews: PreviewProvider
{
	static var previews: some View
	{
		PlaylistView(viewModel: PlaylistViewModel (
			music: Album(
			id: "",
			name: "Title",
			link: "",
			pictureLink: nil,
			pictureDownloaded: false,
			pictureData: nil,
			isLiked: true))).previewDevice("iPhone 13")
	}
}

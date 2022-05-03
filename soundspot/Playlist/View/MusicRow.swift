//
//  PlaylistRow.swift
//  soundspot
//
//  Created by James Maturino on 3/7/22.
//

import Foundation
import SwiftUI

struct MusicRow: View
{
	@StateObject var viewModel : MusicRowViewModel
	
	var body: some View
	{
		HStack{
			HStack
			{
				if (!viewModel.music.pictureDownloaded)
				{
					Image("defaultTrackImg")
						.resizable()
						.frame(width: 50, height: 50)
				}
				else if let data = viewModel.music.pictureData
				{
					if let image = UIImage(data: data)
					{
						Image(uiImage: image)
							.resizable()
							.frame(width: 50, height: 50)
					}else {
						Image("defaultTrackImg")
							.resizable()
							.frame(width: 50, height: 50)
					}
				}
				
				Text(viewModel.music.title)
					.foregroundColor(.white)
					.lineLimit(2)
				Spacer()
				
				
				
				
				Button(
					action:{
						withAnimation(.spring(dampingFraction: 0.5)){ viewModel.onEvent(event: MusicRowEvents.heartClicked) }
					}
				){
					HStack
					{
						if(viewModel.music.isLiked){
							Image(systemName: "heart.fill")
								.foregroundColor(.purple)
						}else{
							Image(systemName: "heart")
								.foregroundColor(.purple)
						}
						
					}
				}
				
				
			}.onTapGesture {
				viewModel.onEvent(event: MusicRowEvents.onClick)
			}
			
			Menu
			{
				Button("Add to queue", action:{})
				Button("Add to playlist", action:
                {
                    if(true)
                    {
                        /*// Playlists
                        ForEach(0..<ProfileModel.playlistList.count, id: \.self)
                        { index in
                            MusicRow(viewModel: MusicRowViewModel.init(
                                music: ProfileViewModel.profile!.playlistList[index],
                                index: index,
                                onClick: ProfileViewModel.navigateToPlaylist))
                        }*/
                    }
                })
               
                if(viewModel.music.isLiked)
                {
                    Button("Unlike Song", action: {viewModel.onEvent(event: MusicRowEvents.heartClicked)})
                }
                else
                {
                    Button("Like Song", action:{viewModel.onEvent(event: MusicRowEvents.heartClicked)})
                }
			} label:
			{
				Label("", systemImage: "ellipsis").padding(15)
			}
		}.padding(.top, 3)
			.padding(.bottom, 3)
	}
	
	
}


/*
 struct SongRow_Previews: PreviewProvider
 {
 static var previews: some View
 {
 SongRow()
 .previewDevice(PreviewDevice("iPhone 13"))
 }
 }*/

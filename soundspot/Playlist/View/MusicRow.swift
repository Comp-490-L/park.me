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
    @State var showPlaylists = false
	
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
			
            if(viewModel.music is Track){
                Menu
                {
                    Button("Add to queue", action:{})
                    Button("Add to playlist", action:
                    {
                        showPlaylists = true
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
            }
		}.padding(.top, 3)
			.padding(.bottom, 3)
            .sheet(isPresented: $showPlaylists){
                PickPlaylistView(music: viewModel.music)
            }
	}
	
}

struct PickPlaylistView: View{
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @ObservedObject var profileRepo = ProfileRepository.getInstance()
    var music : Music
    var body: some View{
        VStack(){
            if let profile = profileRepo.profile{
                if(profile.playlistList.count != 0){
                    Text("Choose playlist")
                        .foregroundColor(.white)
                    
                }
                ForEach(0..<profile.playlistList.count, id: \.self){ i in
                    HStack{
                        if let data = profile.playlistList[i].pictureData{
                            if let uiImage = UIImage(data: data){
                                Image(uiImage: uiImage).resizable()
                                    .frame(maxWidth: 150, maxHeight: 150)
                            }else{
                                Image("defaultTrackImg")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                            }
                        }else{
                            Image("defaultTrackImg")
                                .resizable()
                                .frame(width: 50, height: 50)
                        }
                        
                        Text(profile.playlistList[i].title)
                        Spacer()
                    }.onTapGesture {
                        profileRepo.addToPlaylist(
                            playlistId: profile.playlistList[i].id, trackId: music.id, track: music as! Track) {_ in}
                        self.mode.wrappedValue.dismiss()
                    }.padding(10)
                }
                
            }
            Spacer()
        }.padding(.top, 20)
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

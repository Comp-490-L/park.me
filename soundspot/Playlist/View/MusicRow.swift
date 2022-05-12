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
    var profileRepo = ProfileRepository.getInstance()
	
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
                    if(viewModel.music is Track){
                        Button("Add to queue", action:{})
                        Button("Add to playlist", action:
                        {
                            showPlaylists = true
                        })
                    }
                    
                    if(viewModel.music is Track){
                        switch viewModel.containedIn.container{
                        case .Playlist:
                            Button("Remove from playlist", action: {
                                profileRepo.removeFromPlaylist(
                                    playlistId: viewModel.containedIn.id, trackId: viewModel.music.id){ _ in}
                            })
                        case .Album:
                            Button("Remove from album", action:{
                                profileRepo.removeFromAlbum()
                            })
                        default:
                            VStack{} // not needed
                        }
                        
                    }
                    
                    Button("Delete", action: {
                        switch viewModel.music{
                        case is Track:
                            // TODO check if track is in playlist and if it needs to be removed from playlist
                            profileRepo.deleteTrack()
                        case is Playlist:
                            profileRepo.deletePlaylist()
                        case is Album:
                            profileRepo.deleteAlbum()
                        default:
                            break
                        }
                    })
                    
                    Button("Rename", action: {
                        switch viewModel.music{
                        case is Track:
                            // TODO check if track is in playlist and if it needs to be removed from playlist
                            profileRepo.renameTrack()
                        case is Playlist:
                            profileRepo.renamePlaylist()
                        case is Album:
                            profileRepo.renameTrack()
                        default:
                            break
                        }
                    })
                    
                   
                } label:
                {
                    Label("", systemImage: "ellipsis").padding(15)
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

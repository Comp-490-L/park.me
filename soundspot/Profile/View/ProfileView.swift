//
//  ProfileView.swift
//  soundspot
//
//  Created by Yassine Regragui on 12/4/21.
//

import Foundation
import SwiftUI
import AudioToolbox


struct ProfileView: View{
	
    @ObservedObject var profileRepo = ProfileRepository.getInstance()
	@StateObject var viewModel: ProfileViewModel
	@State var didTap = false
	@State var showUpload = false
	
	var body: some View{
		NavigationView{
			VStack{
				ScrollView{
					ZStack{
						
						Banner()
                        HStack
                        {
                            Spacer()
                            Spacer()
                            VStack
                            {
                                Spacer()
                                NavigationLink(destination: SettingsPage(viewModel: self.viewModel), isActive: $viewModel.navigateToSettingsView)
                                {
                                    Button(action:{viewModel.navigateToSettingsView = true})
                                    {
                                        VStack(alignment: .center)
                                        {
                                            Image(systemName: "gear")
                                                .resizable()
                                              //  .padding(25)
                                                .scaledToFit()
                                                .frame(width: 50, height: 50).foregroundColor(.white)
                                        }
                                    }
                                }
                            }
                        }
						
						VStack(alignment: .center){
							
                            if (!viewModel.loading){
                                if let profile = profileRepo.profile{
                                    if let image = profile.image{
                                        image
                                            .resizable()
                                            .clipShape(Circle())
                                            .shadow(radius: 10)
                                            .overlay(Circle()
                                                        .stroke(Color(#colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)), lineWidth: 5))
                                            .frame(width: 200, height: 200)
                                            .scaledToFit()
                                            .padding(.top, 40)
                                            .onTapGesture{}

                                    }
                                    
                                }else{
                                    Image("FLCL")
                                        .resizable()
                                        .clipShape(Circle())
                                        .shadow(radius: 10)
                                        .overlay(Circle()
                                                    .stroke(Color(#colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)), lineWidth: 5))
                                        .frame(width: 200, height: 200)
                                        .scaledToFit()
                                        .padding(.top, 40)
                                }
                                Text(profileRepo.profile?.displayName ?? "Username")
                                    .font(.title2)
                                    .foregroundColor(.white)
                                    .fontWeight(.bold)
                                
                                if(viewModel.updateProfilePic){
                                    Menu{
                                        Button("updatePicture", action: {})
                                    } label:{
                                        Label("",systemImage: "ellipsis")
                                    }
                                }
                                
                            }
                                
                            }
                            
						
					}    // End of Zstack
					
					
					
					VStack(alignment: .leading)
					{
						if(viewModel.loading){
							HStack{
								ProgressView()
									.padding(.trailing, 5)
								Text("Loading...")
							}.padding(.top, 150)
							
						}
						else if(viewModel.errorLoading){
							VStack(alignment: .center){
								Text("Error loading your profile")
									.font(.headline)
								Button("Try Again ?"){
									viewModel.onEvent(event: ProfileEvents.LoadProfile)
								}
								.font(.headline)
								.padding(.horizontal, 10.0)
								 .padding(.vertical, 10.0)
								 .foregroundColor(.white)
								 .background(Color.pink)
								 .cornerRadius(10)
								
							}.padding(.top, 150)
						}
						else{
							HStack
							{
								
								Button(action:{self.didTap = true})
								{
									SwiftUI.Text("Playlists")
									//.font(.headline)
										.font(.system(size: 25))
										.fontWeight(.bold)
										.frame(maxWidth: .infinity, alignment: .leading)
										//.padding(.vertical, 10.0)
										.foregroundColor( .white)
										.background(didTap ? Color(#colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)): Color(#colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)) ).onTapGesture {
											showUpload.toggle()
										}
									
									
								}
								Spacer()
                                //Navigate to CreatePlaylistView
                                NavigationLink(destination: CreatePlaylistView(viewModel: CreatePlaylistViewModel() ), isActive: $viewModel.navigateToCreatePlaylistView)
                                {
                                    Button(action:{viewModel.navigateToCreatePlaylistView = true})
                                    {
                                        Image(systemName: "plus")
                                            .foregroundColor(.white)
                                            .font(.title2)
                                    }
                                }
							}
							
							if(profileRepo.profile != nil){
								// Playlists
								ForEach(0..<profileRepo.profile!.playlistList.count, id: \.self){ index in
									MusicRow(viewModel: MusicRowViewModel.init(
										music: profileRepo.profile!.playlistList[index],
										index: index,
										onClick: viewModel.navigateToPlaylist,
                                        containedIn: ContainedIn(container: Container.Playlist, id: profileRepo.profile!.playlistList[index].id)))
								}
                                
                                NavigationLink(destination: PlaylistView(
                                    viewModel: PlaylistViewModel(
                                        music: profileRepo.profile!.playlistList[viewModel.clickedPlaylist])),
                                               isActive: $viewModel.navigateToPlaylist){}
								//TODO add navigation for playlists here
							}
							
							
							Spacer()
							
                            if(profileRepo.profile?.singlesList.count == 0
							   && profileRepo.profile?.albumsList.count == 0){
								Text("Uploaded music will be shown here.")
									.frame(maxWidth: .infinity)
							}else{
								
								HStack{
									
									Button(action: {
										self.didTap = true
									}){
										SwiftUI.Text("Your Music")
										//.font(.headline)
											.font(.system(size: 25))
											.fontWeight(.bold)
											.frame(alignment: .leading)
											.padding(.vertical, 10.0)
											.foregroundColor( .white)
											.background(didTap ? Color(#colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)): Color(#colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)) )
									}
									Spacer()
								}
								
								
								// Check if profile is found and user has some music uploaded
								if(profileRepo.profile != nil){
									
									ForEach(0..<profileRepo.profile!.singlesList.count, id: \.self)
									{
										index in
	
										MusicRow(viewModel: MusicRowViewModel.init(
											music: profileRepo.profile!.singlesList[index],
											index: index,
											onClick: viewModel.navigateToPlayerView,
                                            containedIn: ContainedIn(container: Container.Track, id: profileRepo.profile!.singlesList[index].id)))
									}
									
									// Navigate to PlayerView
									if(viewModel.navigateToPlayerView){
										if let profile = profileRepo.profile{
											NavigationLink(destination :
															PlayerView(viewModel:
																		PlayerViewModel.instancePlayTracks(tracksList: profile.singlesList, index: viewModel.clickedTrack)
																	  ), isActive: $viewModel.navigateToPlayerView){}
										}
									}
									
									
									
									// Albums
									ForEach(0..<profileRepo.profile!.albumsList.count, id: \.self)
									{
										index in

										MusicRow(viewModel: MusicRowViewModel.init(
											music: profileRepo.profile!.albumsList[index],
											index: index,
											onClick: viewModel.navigateToPlaylistView,
                                            containedIn: ContainedIn(container: Container.Album, id: profileRepo.profile!.albumsList[index].id)))
									}
									// Navigate to playlistView
									if(viewModel.navigateToPlaylistView){
										if let profile = profileRepo.profile{
											
											NavigationLink(destination :
															PlaylistView(
																viewModel: PlaylistViewModel(
																	music: profile.albumsList[viewModel.clickedAlbum])
															),
														   isActive: $viewModel.navigateToPlaylistView){}
											
										}
									}
									
								}
								
							}
						}
						
					}.background(Color(#colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)))
						.padding(.leading, 10)
						.onLoad{
							viewModel.onEvent(event: ProfileEvents.LoadProfile)
						}
					
				}.background(Color(#colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)))
					.edgesIgnoringSafeArea(.all)
                
				
				
				
				HStack{
					
					if(viewModel.uploadingFile){
						VStack(alignment : .leading){
							Text("Upload Progress")
							ProgressBar(currentProgress: $viewModel.uploadProgress)
								.frame(height : 20)
						}
					}else{
						
						Menu{
							Button("Tracks"){
								viewModel.onEvent(event: ProfileEvents.UploadTracksClicked)
							}
							Button("Album"){
								viewModel.onEvent(event: ProfileEvents.UploadAlbumClicked)
							}
							
						} label: {
							SwiftUI.Text("Upload music")
								.font(.headline)
								.padding(.horizontal, 60.0)
								.padding(.vertical, 10.0)
								.foregroundColor(.white)
								.background(Color.purple)
								.cornerRadius(10)
						}
						.sheet(isPresented: $viewModel.showFilePicker){
							viewModel.showDocumentPicker()
						}
						
					}
					
				}
				.padding(.bottom, 10)
				.background(Color(#colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)))
				
				
				NavigationLink(
					destination: MusicUploadView(viewModel: MusicUploadViewModel(uploadChoice: viewModel.uploadChoice, selectedFiles: viewModel.selectedFiles)),
					isActive: $viewModel.navigateToUploadView){}
				
				
                //VideoControls()
				
				
				
			}.background(Color(#colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)))
				
		}.navigationBarTitle("")
			.navigationBarHidden(true)
			.navigationBarBackButtonHidden(true)
		
	}
	
	
	struct trackCard : View
	{
		
		@Binding var single : Track
		var body: some View
		{
			VStack
			{
				if(!single.pictureDownloaded)
				{
					Image("defaultTrackImg")
						.resizable()
						.frame(width: 150, height: 150)
				}
				
				else if let data = single.pictureData{
					if let image = UIImage(data: data){
						Image(uiImage: image)
							.resizable()
							.frame(width: 150, height: 150)
					}
				}
				
				
				Text(single.title)
					.foregroundColor(Color.gray)
					.font(.system(size:10))
			}
		}
	}
	
	
	struct ProgressBar : View{
		@Binding var currentProgress : Double
		var body: some View{
			
			GeometryReader{
				geometry in
				ZStack{
					ZStack(alignment: .leading){
						RoundedRectangle(cornerRadius: 20)
							.foregroundColor(.purple)
							.frame(width: geometry.size.width,
								   height: geometry.size.height,
								   alignment: .center)
							.opacity(0.5)
						
						RoundedRectangle(cornerRadius: 20)
							.foregroundColor(.purple)
							.frame(width: min(currentProgress * geometry.size.width, geometry.size.width),
								   height: geometry.size.height,
								   alignment: .center)
							.animation(.linear)
					}
					Text("\(String(format: "%.2f", currentProgress * 100)) %")
				}
			}
		}
	}
}


struct Banner : View
{
	var body: some View
    {
        VStack
        {
            Rectangle()
                .strokeBorder(Color(#colorLiteral(red: 0.5, green: 0, blue: 1, alpha: 1))
                              , lineWidth: 10)
                .frame(width: .infinity, height: 20)
            Rectangle()
                .strokeBorder(Color(#colorLiteral(red: 0.6, green: 0.1, blue: 1, alpha: 1)), lineWidth: 10)
                .frame(width: .infinity, height: 22)
            Rectangle()
                .strokeBorder(Color(#colorLiteral(red: 0.7, green: 0.2, blue: 1, alpha: 1)), lineWidth: 8)
                .frame(width: .infinity, height: 24)
            Rectangle()
                .strokeBorder(Color(#colorLiteral(red: 0.8, green: 0.3, blue: 1, alpha: 1)), lineWidth: 6)
                .frame(width: .infinity, height: 26)
            Rectangle()
                .strokeBorder(Color(#colorLiteral(red: 0.9, green: 0.4, blue: 1, alpha: 1)), lineWidth: 4)
                .frame(width: .infinity, height: 28)
            Rectangle()
                .strokeBorder(Color(#colorLiteral(red: 0.9, green: 0.4, blue: 1, alpha: 1)), lineWidth: 4)
                .frame(width: .infinity, height: 28)
            Rectangle()
                .strokeBorder(Color(#colorLiteral(red: 0.8, green: 0.3, blue: 1, alpha: 1)), lineWidth: 6)
                .frame(width: .infinity, height: 26)
            Rectangle()
                .strokeBorder(Color(#colorLiteral(red: 0.7, green: 0.2, blue: 1, alpha: 1)), lineWidth: 8)
                .frame(width: .infinity, height: 24)
            Rectangle()
                .strokeBorder(Color(#colorLiteral(red: 0.6, green: 0.1, blue: 1, alpha: 1)), lineWidth: 10)
                .frame(width: .infinity, height: 22)
            Rectangle()
                .strokeBorder(Color(#colorLiteral(red: 0.5, green: 0, blue: 1, alpha: 1)), lineWidth: 10)
                .frame(maxWidth: .infinity).frame(height : 20)
        }
	}
}

struct ProfileView_Previews: PreviewProvider {
	static var previews: some View {
		ProfileView(viewModel: ProfileViewModel()).previewDevice("iPhone 13")
	}
}


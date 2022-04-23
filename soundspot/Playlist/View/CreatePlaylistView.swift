//
//  CreatePlaylistView.swift
//  soundspot
//
//  Created by James Maturino on 4/19/22.
//

import Foundation
import SwiftUI

struct CreatePlaylistView : View
{
	@ObservedObject var viewModel : CreatePlaylistViewModel
    @State private var playlistName: String = ""
    
    var body : some View
    {
        VStack
        {
            Spacer()
            Text("Give your playlist a name.")
                .bold()
                .font(.system(size: 27))
                .multilineTextAlignment(.center)
            Spacer()
                .frame(height: 30)
            
			
			if(viewModel.creatingPlaylist){
				Text(viewModel.title).multilineTextAlignment(.center)
					.font(.system(size: 25))
			}else{
				//TODO add max characters
				TextField("Name Me!", text: $viewModel.title)
					.multilineTextAlignment(.center)
					.font(.system(size: 25))
			}
            Rectangle()
                .frame(height: 1)
                .foregroundColor(.gray)
                .padding(.leading, 16)
                .padding(.trailing, 16)
            
            Spacer()
                .frame(height: 30)
			if(viewModel.creatingPlaylist){
				HStack{
					ProgressView().padding(.trailing, 10)
					Text("Creating playlist")
				}
			}else{
				HStack
				{
					
					Button("Cancel", action: {})
					Spacer()
						.frame(width: 30)
					if(viewModel.title == ""){
						Button("Skip", action:{ viewModel.onEvent(event: CreatePlaylistEvents.createPlaylist) })
					}else{
						Button("Next", action:{ viewModel.onEvent(event: CreatePlaylistEvents.createPlaylist) })
						Spacer()
					}
				}
			}
            
            Spacer()
                .frame(height: 400)
			
			NavigationLink(
				destination : PlaylistView(viewModel: self.viewModel.playlistViewModel),
						   isActive: $viewModel.navigateToPlaylist){}

        }
    }
    

}

struct CreatePlaylistView_Previews: PreviewProvider
{
    static var previews: some View
    {
        CreatePlaylistView(viewModel: CreatePlaylistViewModel())
            .previewDevice(PreviewDevice(rawValue: "iPhone 13"))
    }
}

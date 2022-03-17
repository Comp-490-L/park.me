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
	var body: some View
	{
		VStack
		{
			Image("SadMachineSingleCover")
					.resizable()
					.frame(width: 150, height: 150)
			Text("Playlist Title")
			
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
			
			//Change to for loop
			List
			{
				
			}
		}
	}
}

struct PlaylistView_Previews: PreviewProvider
{
	static var previews: some View
	{
		PlaylistView()
	}
}

//
//  PlaylistRow.swift
//  soundspot
//
//  Created by James Maturino on 3/10/22.
//

import Foundation
import SwiftUI

struct PlaylistRow: View
{
	//var rowThing: PlaylistThing
	let title : String
	
	var body: some View
	{
		Button(action:{})
		{
			HStack
			{
				Image("SadMachineSingleCover")
					.resizable()
					.frame(width: 50, height: 50)
				Text(title)
			
				Spacer()
				
				/*:Menu
				{
					Button("Add to queue", action:{})
					Button("Add to playlist", action:{})
					Button("Like", action:{})
				} label:
				{
					Label("", systemImage: "ellipsis").padding(15)
				}*/
			}
		}
	}
}

struct PlaylistRow_Previews: PreviewProvider
{
	static var previews: some View
	{
		PlaylistRow(title: "ThingTest")
			.previewDevice(PreviewDevice(rawValue: "iPhone 13"))
	}
}

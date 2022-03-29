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
	// Music means track or album
	@Binding var music : Music
	@State var heart = "heart"
	var index : Int
	var onClick : (Int) -> Void
	
	var body: some View
	{
		HStack{
			HStack
			{
				if (!music.pictureDownloaded)
				{
					Image("defaultTrackImg")
						.resizable()
						.frame(width: 50, height: 50)
				}
				else if let data = music.pictureData
				{
					if let image = UIImage(data: data)
					{
						Image(uiImage: image)
							.resizable()
							.frame(width: 50, height: 50)
					}
				}
				
				Text(music.title)
					.foregroundColor(.white)
					.lineLimit(2)
				Spacer()
				
				
				
				
				Button(
					action:{
						withAnimation(.spring(dampingFraction: 0.5)){ isLiked() }
					}
				){
					HStack
					{
						Image(systemName: heart)
							.foregroundColor(.purple)
					}
				}
				
				
			}.onTapGesture {
				onClick(index)
			}
			
			Menu
			{
				Button("Add to queue", action:{})
				Button("Add to playlist", action:{})
				Button("Like", action:{})
			} label:
			{
				Label("", systemImage: "ellipsis").padding(15)
			}
		}
	}
	
	
	func isLiked()
	{
		if (heart == "heart")
		{
			heart = "heart.fill"
		}
		else
		{
			heart="heart"
		}
		
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

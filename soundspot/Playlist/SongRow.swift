//
//  PlaylistRow.swift
//  soundspot
//
//  Created by James Maturino on 3/7/22.
//

import Foundation
import SwiftUI

struct SongRow: View
{
	//var rowThing: PlaylistThing
    @Binding var single : Track
    @State var heart = "heart"
    @StateObject var viewModel : PlayerViewModel
	
	var body: some View
	{
        HStack
        {
            NavigationLink(destination:PlayerView(viewModel : viewModel))
            {
                if (!single.pictureDownloaded)
                {
                    Image("defaultTrackImg")
                        .resizable()
                        .frame(width: 50, height: 50)
                }
                else if let data = single.pictureData
                {
                    if let image = UIImage(data: data)
                    {
                        Image(uiImage: image)
                            .resizable()
                            .frame(width: 50, height: 50)
                    }
                }
                
                Text(single.name)
                    .foregroundColor(.white)
                Spacer()
            }
            
            
            
            Button(action:{withAnimation(.spring(dampingFraction: 0.5))
                {
                    isLiked()
                }})
            {
                HStack
                {
                    Image(systemName: heart)
                        .foregroundColor(.purple)
                }
            }
                                 

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


/*:
struct SongRow_Previews: PreviewProvider
{
	static var previews: some View
	{
		SongRow(title: "ThingTest")
			.previewDevice(PreviewDevice(rawValue: "iPhone 13"))
	}
}*/

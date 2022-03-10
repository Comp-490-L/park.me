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
    }
}

struct SongRow_Previews: PreviewProvider
{
    static var previews: some View
    {
        SongRow(title: "ThingTest")
            .previewDevice(PreviewDevice(rawValue: "iPhone 13"))
    }
}

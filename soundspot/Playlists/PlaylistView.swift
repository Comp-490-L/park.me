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
                SongRow(title: "Test Song 1")
                SongRow(title: "Test Song 2")
                SongRow(title: "Test Song 3")
                SongRow(title: "Test Song 4")
                SongRow(title: "Test Song 5")
                SongRow(title: "Test Song 6")
                SongRow(title: "Test Song 7")
                SongRow(title: "Test Song 8")
                SongRow(title: "Test Song 9")
                SongRow(title: "Test Song 10")
                
            }
        }
    }
}

struct PlaylistList_Previews: PreviewProvider
{
    static var previews: some View
    {
        PlaylistView()
    }
}

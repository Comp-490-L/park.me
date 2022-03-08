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
            
            List
            {
                PlaylistRow(title: "Test Song 1")
                PlaylistRow(title: "Test Song 2")
                PlaylistRow(title: "Test Song 3")
                PlaylistRow(title: "Test Song 4")
                PlaylistRow(title: "Test Song 5")
                PlaylistRow(title: "Test Song 6")
                PlaylistRow(title: "Test Song 7")
                PlaylistRow(title: "Test Song 8")
                PlaylistRow(title: "Test Song 9")
                PlaylistRow(title: "Test Song 10")
                
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

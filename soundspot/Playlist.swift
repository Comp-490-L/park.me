
//
//  Playlist.swift
//  soundspot
//
//  Created by Mohamed Balushi on 2/22/22.
//

import Foundation
import SwiftUI
 
struct playlistview : View {
var body: some View {
        Button(action:{}) {
        HStack {
            
        Image("SadMachineSingleCover")
                .resizable()
                .frame(width: 60, height: 60)
                .aspectRatio(contentMode: .fit)
                .padding(.leading, 10)
           Text("SAD MACHINE")
            .foregroundColor(.white)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.trailing)
            Spacer()
        }
    }
            Spacer()
        Button(action:{}) {
        HStack {
                Image(systemName: "ellipsis").padding(15)
                }
            }

}
}

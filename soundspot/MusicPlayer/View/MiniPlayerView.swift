//
//  MiniPlayerView.swift
//  soundspot
//
//  Created by James Maturino on 4/21/22.
//

import Foundation
import SwiftUI

struct MiniPlayerView: View
{
    var body: some View
    {
        VStack
        {
            
        }
    }
}

struct VideoControls: View
{
    //@EnvironmentObject var player: PlayerView
    var body: some View
    {
        HStack
        {
            //PlayerView...
            Rectangle()
                .fill(Color.white)
                .frame(width: 150, height: 70)
            
            VStack(alignment: .leading, spacing: 6, content:
                    {
                Text("Song Title")
                    .font(.callout)
                    .foregroundColor(.white)
                    .lineLimit(1)
                
                Text("Song Artist")
                    .fontWeight(.bold)
                    .font(.caption)
                    .foregroundColor(.gray)
                })
            
            
            Button(action: {}, label: {
                Image(systemName: "backward.end.fill")
                    .font(.title2)
                    .foregroundColor(.white)
            })
            
            Button(action: {}, label: {
                Image(systemName: "pause.fill")
                    .font(.title2)
                    .foregroundColor(.white)
            })
            
            Button(action: {}, label: {
                Image(systemName: "forward.end.fill")
                    .font(.title2)
                    .foregroundColor(.white)
            })
            
            Button(action: {}, label: {
                Image(systemName: "xmark")
                    .font(.title2)
                    .foregroundColor(.white)
            })
        }
        .padding(.trailing)
    }
}

struct MiniPlayerView_Previews: PreviewProvider
{
    static var previews: some View
    {
        VideoControls()
    }
}

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
    @StateObject var viewModel : PlayerViewModel
    
    var body: some View
    {
        HStack
        {
            Spacer()
            //PlayerView...
            if(viewModel.trackList[viewModel.trackIndex].pictureData == nil && !viewModel.trackList[viewModel.trackIndex].pictureDownloaded){
                Image("defaultTrackImg")
                    .resizable()
                    .frame(width: 70, height: 70)
            }else{
                if let data = viewModel.trackList[viewModel.trackIndex].pictureData{
                    if let uiImage = UIImage(data: data){
                        Image(uiImage: uiImage)
                            .resizable()
                            .frame(width: 70, height: 70)
                    }
                }
            }
            
            VStack(alignment: .leading, spacing: 6, content:
                    {
                Text(viewModel.trackList[viewModel.trackIndex].title)
                    .font(.callout)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .lineLimit(1)
                
                /*Text("Song Artist")
                    //.fontWeight(.bold)
                    .font(.caption)
                    .foregroundColor(.black)*/
                })
            
            Spacer()
            
            Button(action: {viewModel.onEvent(event: MusicPlayerEvent.PreviousPressed)}, label: {
                Image(systemName: "backward.end.fill")
                    .font(.title2)
                    .foregroundColor(.black)
            })
            Spacer()
            
            Button(action: {viewModel.onEvent(event: MusicPlayerEvent.PlayPausePressed)},
                   label: {
                Image(systemName: viewModel.isPlaying ? "pause.fill" : "play.fill")
                    .font(.title2)
                    .foregroundColor(.black)
            })
            Spacer()
            Button(action: {viewModel.onEvent(event: MusicPlayerEvent.NextPressed)},
                   label: {
                Image(systemName: "forward.end.fill")
                    .font(.title2)
                    .foregroundColor(.black)
            })
            /*
            Button(action: {}, label: {
                Image(systemName: "xmark")
                    .font(.title2)
                    .foregroundColor(.black)
            })*/
            Spacer()
        }
        .padding(.trailing)
        .background(Color.gray)
        .frame(maxWidth: .infinity)
    }

}


//Delete this code after properly implementing the MiniPlayerView
struct VideoControls: View
{
    //@EnvironmentObject var player: PlayerView
    var body: some View
    {
        HStack
        {
            Spacer()
            //PlayerView...
            Image("defaultTrackImg")
                .resizable()
                .frame(width: 70, height: 70)
            
            VStack(alignment: .leading, spacing: 6, content:
                    {
                Text("Song Title")
                    .font(.callout)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .lineLimit(1)
                
                Text("Song Artist")
                    //.fontWeight(.bold)
                    .font(.caption)
                    .foregroundColor(.black)
                })
            
            Spacer()
            
            Button(action: {}, label: {
                Image(systemName: "backward.end.fill")
                    .font(.title2)
                    .foregroundColor(.black)
            })
            Spacer()
            
            Button(action: {}, label: {
                Image(systemName: "pause.fill")
                    .font(.title2)
                    .foregroundColor(.black)
            })
            Spacer()
            Button(action: {}, label: {
                Image(systemName: "forward.end.fill")
                    .font(.title2)
                    .foregroundColor(.black)
            })
            /*
            Button(action: {}, label: {
                Image(systemName: "xmark")
                    .font(.title2)
                    .foregroundColor(.black)
            })*/
            Spacer()
        }
        .padding(.trailing)
        .background(Color.gray)
        .frame(maxWidth: .infinity)
    }
}

struct MiniPlayerView_Previews: PreviewProvider
{
    static var previews: some View
    {
        VideoControls()
    }
}

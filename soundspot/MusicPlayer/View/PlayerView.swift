//
//  PlayerView.swift
//  soundspot
//
//  Created by James Maturino on 10/17/21.
//

import Foundation
import SwiftUI
import AVFoundation


struct PlayerView : View
{
    @StateObject var viewModel : PlayerViewModel
    @State var player: AVPlayer? = nil
    @State var isPlaying : Bool = false
    
    var body: some View
    {
        
        VStack
        {
            //edgesIgnoringSafeArea(.all)
            if(!viewModel.trackList[viewModel.current].pictureDownloaded){
                Image("defaultTrackImg")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .background(Color.white)
                    .shadow(radius: 1)
            }else{
                Image(uiImage: UIImage(data: viewModel.trackList[viewModel.current].pictureData!)!)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .shadow(radius: 1)
                //.aspectRatio(2/3, contentMode: .fit)
            }
            
            Text(viewModel.trackList[viewModel.current].name)
                .foregroundColor(Color.gray).padding().font(.title2)
           
            ZStack
            {
                Spacer()
                Text(viewModel.trackList[viewModel.current].name).font(.title).fontWeight(.light).foregroundColor(.white)
                Spacer()
                ZStack
                {
                    Color.white.cornerRadius(20).shadow(radius: 10)
                    HStack
                    {
                        Button(action: self.previous,  label: {
                            Image("previousTrack").resizable()
                        }).frame(width: 50, height: 50, alignment: .center).foregroundColor(Color.gray.opacity(0.2))
                           
                        
                        Button(action: self.playPause, label: {
                            Image(systemName: isPlaying ? "pause.circle.fill" : "play.circle.fill")
                                .resizable()
                                .foregroundColor(Color.pink)
                        }).frame(width: 70, height: 70, alignment: .center)
                        
                        Button(action: self.next, label: {
                            Image("nextTrack").resizable()
                        }).frame(width: 50, height: 50, alignment: .center).foregroundColor(Color.gray.opacity(0.2))
                    }
                }.edgesIgnoringSafeArea(.bottom).frame(height: 200, alignment: .center)
            }
        }.onAppear{
            
            viewModel.LoadSession()
            let fileURL = viewModel.PlayTrack()
            if(fileURL != nil){
                do{
                    try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
                    //player = try AVAudioPlayer(contentsOf: fileURL!)
                    //player?.play()
                }
                catch{}
                print("\n\n Playing fileURL \(fileURL)")
                //player = AVPlayer(playerItem: AVPlayerItem(url: fileURL!))
                player = AVPlayer(url: fileURL!)
                playPause()
                if(player == nil){
                    print("player is nil")
                }
                
            }else{
                print("Audio file is nil")
            }
            
        }
    }
    
    
    func playPause()
    {
        isPlaying.toggle()
        if isPlaying == false{
            player?.pause()
        }else{
            player?.play()
        }
    }
    
    func next()
    {
        
    }
    
    func previous()
    {
        
    }
}








struct ViewDidLoadModifier: ViewModifier {
    @State private var didLoad = false
    private let action: (() -> Void)?

    init(perform action: (() -> Void)? = nil) {
        self.action = action
    }
    
    func body(content: Content) -> some View {
        content.onAppear {
            if didLoad == false {
                didLoad = true
                action?()
            }
        }
    }
}

extension View {
    func onLoad(perform action: (() -> Void)? = nil) -> some View {
        modifier(ViewDidLoadModifier(perform: action))
    }
}



struct PlayerView_Previews: PreviewProvider {
    static var previews: some View {
       
        PlayerView(viewModel: PlayerViewModel(trackList: Array<MusicModel>(), trackIndex: 0))
                .previewDevice("iPhone 13")
    }
}


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
    
    
    var body: some View
    {
        
        VStack
        {
            if(viewModel.trackList[viewModel.trackIndex].pictureData == nil && !viewModel.trackList[viewModel.trackIndex].pictureDownloaded){
                Image("defaultTrackImg")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .background(Color.white)
                    .shadow(radius: 1)
            }else{
                Image(uiImage: UIImage(data: viewModel.trackList[viewModel.trackIndex].pictureData!)!)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .shadow(radius: 1)
            }
            
            Text(viewModel.trackList[viewModel.trackIndex].name)
                .foregroundColor(Color.gray).padding().font(.title2)
           
           
            ZStack
            {
                Spacer()
                ZStack
                {
                    Color.white.cornerRadius(20).shadow(radius: 10)
                    
                    VStack{
                        PlayerSlider(viewModel: viewModel)
                        HStack{
                            Text(viewModel.progress)
                            Spacer()
                            Text(viewModel.trackLength)
                        }.padding(.leading).padding(.trailing)
                        PlayerControllers(viewModel: viewModel)
            
                    }
                    
                }.edgesIgnoringSafeArea(.bottom).frame(height: 200, alignment: .center)
            }
        }.onAppear{
            viewModel.onEvent(event: MusicPlayerEvent.Launched)
        }
    }
    
    struct PlayerSlider : View {
        @ObservedObject var viewModel : PlayerViewModel
        var body: some View{
            Slider(value: $viewModel.progressPercentage,
                   in: 0 ... 100, step: 1){
                // if dragging ended update value
                if !$0 {
                       viewModel.onEvent(event: MusicPlayerEvent.SliderChanged)
                   }
            }.padding(.leading).padding(.trailing)
        }
    }
    
    struct PlayerControllers : View {
        @ObservedObject var viewModel : PlayerViewModel
        var body: some View{
            HStack
            {
                Button(action: {
                    viewModel.onEvent(event: MusicPlayerEvent.PreviousPressed)
                },  label: {
                    Image("previousTrack").resizable()
                }).frame(width: 50, height: 50, alignment: .center).foregroundColor(Color.gray.opacity(0.2))
                   
                
                Button(
                    action: {viewModel.onEvent(event: MusicPlayerEvent.PlayPausePressed)},
                       label: {
                    Image(systemName: viewModel.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                        .resizable()
                        .foregroundColor(Color.pink)
                }).frame(width: 70, height: 70, alignment: .center)
                
                Button(action: {
                    viewModel.onEvent(event: MusicPlayerEvent.NextPressed)
                }, label: {
                    Image("nextTrack").resizable()
                }).frame(width: 50, height: 50, alignment: .center).foregroundColor(Color.gray.opacity(0.2))
            }
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
     
    static func getMusicModel() ->  Array<MusicModel>{
        var model = MusicModel(name: "music Name", link: "", trackDownloaded: false, pictureLink: nil, pictureDownloaded: false, pictureData: nil)
        
        var list = Array<MusicModel>()
        list.append(model)
        return list
    }
    
    static var previews: some View {
    
    let list = PlayerView_Previews.getMusicModel()
    PlayerView(viewModel: PlayerViewModel(trackList: list, trackIndex: 0))
                .previewDevice("iPhone 13 Pro")
    }
}



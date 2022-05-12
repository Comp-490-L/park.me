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
    
    @ObservedObject var viewModel = PlayerViewModel.getInstance()
    
    
    var animation: Namespace.ID
    @Binding var expand : Bool
    @Environment(\.presentationMode) var presentationMode
    
    var height = UIScreen.main.bounds.height / 3
    
    var safeArea = UIApplication.shared.windows.first?.safeAreaInsets
    

    
    //Volume Slider
    @State var volume : CGFloat = 0
    
    //Gesture Offset
    @State var offset : CGFloat = 0
    
    //Notification Center Observer
    

    
    @State var didRecieveModel = false
    
    
    var body: some View
    {
        //if (viewModel.show == true)
        if (viewModel.trackList.count > 0)
        {
            VStack
            {
                Capsule()
                    .fill(Color.gray)
                    .frame(width: expand ? 60 : 0, height: expand ? 4 : 0)
                    .opacity(expand ? 1 : 0)
                    .padding(.top,expand ? safeArea?.top : 0)
                    .padding(.vertical,expand ? 30 : 0)
                
                HStack(spacing: 15)
                {
                    if expand{Spacer(minLength: 0)} //Change to song image
                    
                    if(viewModel.trackList[viewModel.trackIndex].pictureData == nil || !viewModel.trackList[viewModel.trackIndex].pictureDownloaded){
                        Image("defaultTrackImg")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: expand ? height : 55, height: expand ? height : 55)
                            .cornerRadius(15)
                    }else{
                        if let data = viewModel.trackList[viewModel.trackIndex].pictureData{
                            if let uiImage = UIImage(data: data){
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: expand ? height : 55, height: expand ? height : 55)
                                    .cornerRadius(15)
                            }
                        }
                    }
                    
                    if !expand      //Change to Song Title
                    {
                        Text(viewModel.trackList[viewModel.trackIndex].title)
                            .font(.title2)
                            .fontWeight(.bold)
                            .matchedGeometryEffect(id: "Label", in: animation)
                    }
                    
                    Spacer(minLength: 0)
                    
                    //LAST WORKING ON ADDING FUNCTIONALITY TO BUTTONS
                    
                    if !expand
                    {
                        Button(action: {
                            viewModel.onEvent(event: MusicPlayerEvent.PreviousPressed)
                        },  label: {
                            Image(systemName: "backward.end.fill")
                                .font(.title2)
                                .foregroundColor(.primary)
                        })
                        
                        Button(
                            action: {viewModel.onEvent(event: MusicPlayerEvent.PlayPausePressed)},
                               label: {
                            Image(systemName: viewModel.isPlaying ? "pause.fill" : "play.fill")
                                .font(.title2)
                                .foregroundColor(.primary)
                        })
                        
                        Button(action: {
                            viewModel.onEvent(event: MusicPlayerEvent.NextPressed)
                        }, label: {
                            Image(systemName: "forward.end.fill")
                                .font(.title2)
                                .foregroundColor(.primary)
                        })
                    }
                }.padding(.horizontal)
                
                VStack(spacing: 15)
                {
                    Spacer(minLength: 0)
                    
                    HStack
                    {
                        if expand
                        {
                            Text(viewModel.trackList[viewModel.trackIndex].title)
                                .font(.title2)
                                .foregroundColor(.primary)
                                .fontWeight(.bold)
                                .matchedGeometryEffect(id: "Label", in: animation)
                        }
                        
                        Spacer(minLength: 0)
                        
                        Button(action: {})
                        {
                            Image(systemName: "ellipsis.circle")
                                .font(.title2)
                                .foregroundColor(.primary)
                        }
                        
                        Spacer(minLength: 0)
                        
                        Button(action: {viewModel.onEvent(event: MusicPlayerEvent.LikePressed)
                            }, label: {
                                Image(systemName: viewModel.isLiked ? "heart.fill" : "heart")
                                    .font(.title2)
                                    .foregroundColor(.purple)
                        })
                    }
                    .padding()
                    .padding(.top, 20)
                    
                                        
                    HStack
                    {
                        Capsule()
                            .fill(
                                LinearGradient(gradient: .init(colors: [Color.white.opacity(0.7),Color.white.opacity(0.1)]), startPoint: .leading, endPoint: .trailing)
                            )
                            .frame(height: 4)
                        
                        Text("Now Playing")
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                        
                        Capsule()
                            .fill(
                                LinearGradient(gradient: .init(colors: [Color.white.opacity(0.1),Color.white.opacity(0.7)]), startPoint: .leading, endPoint: .trailing)
                            )
                            .frame(height: 4)
                    }
                    .padding()
                    
                    ZStack
                    {
                        VStack{
                            PlayerSlider(viewModel: viewModel)
                            HStack{
                                Text(viewModel.progress)
                                Spacer()
                                Text(viewModel.trackLength)
                            }.padding(.leading).padding(.trailing)
                        }
                    }
                    
                    HStack(spacing: 15)
                    {
                        Button(action: {
                            viewModel.onEvent(event: MusicPlayerEvent.PreviousPressed)
                        },  label: {
                            Image(systemName: "backward.end.fill")
                                .font(.largeTitle)
                                .foregroundColor(.primary)
                        })
                        .padding()
                        
                        Button(
                            action: {viewModel.onEvent(event: MusicPlayerEvent.PlayPausePressed)},
                               label: {
                            Image(systemName: viewModel.isPlaying ? "pause.fill" : "play.fill")
                                .font(.largeTitle)
                                .foregroundColor(.primary)
                        })
                        .padding()
                        
                        Button(action: {
                            viewModel.onEvent(event: MusicPlayerEvent.NextPressed)
                        }, label: {
                            Image(systemName: "forward.end.fill")
                                .font(.largeTitle)
                                .foregroundColor(.primary)
                        })
                        .padding()
                    }
                    
                    Spacer(minLength: 0)
                    
                    HStack(spacing: 15)
                    {
                        Image(systemName: "speaker.fill")
                        
                        Slider(value: $volume)
                        
                        Image(systemName: "speaker.wave.2.fill")
                    }
                    .padding()
                    
                    HStack(spacing: 22)
                    {
                        Button(action: {})
                        {
                            Image(systemName: "arrow.up.message")
                                .font(.title2)
                                .foregroundColor(.primary)
                        }
                        
                        Button(action: {})
                        {
                            Image(systemName: "airplayaudio")
                                .font(.title2)
                                .foregroundColor(.primary)
                        }
                        
                        Button(action: {})
                        {
                            Image(systemName: "list.bullet")
                                .font(.title2)
                                .foregroundColor(.primary)
                        }
                    }
                    .padding(.bottom, safeArea?.bottom == 0 ? 15 : safeArea?.bottom)
                }
                //Stretch Effect
                .frame(height: expand ? nil : 0)
                .opacity(expand ? 1 : 0)
                
                
            }
            .frame(maxHeight: expand ? .infinity : 80)
            .background(
                VStack(spacing: 0)
                {
                    BlurView()
                    
                    Divider()
                }
                    .onTapGesture(perform: {
                        
                    withAnimation(.spring()){expand = true}
                })
            )
            .cornerRadius(expand ? 20 : 0)
            .offset(y: expand ? 0 : -48)
            .offset(y: offset)
            .gesture(DragGesture().onEnded(onended(value:)).onChanged(onchanged(value:)))
            .ignoresSafeArea()
        }
    }
    
    func onchanged(value: DragGesture.Value)
    {
        if value.translation.height > 0 && expand
        {
            offset = value.translation.height
        }
    }
    
    func onended(value: DragGesture.Value)
    {
        withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 0.95, blendDuration: 0.95))
        {
            //If value > height / 3 then close the view
            
            if value.translation.height > height
            {
                expand = false
            }
            
            offset = 0
        }
    }
}

//MUCH BETTER miniplayer
//Delete this when above code works
struct testPlayer: View
{
    var animation: Namespace.ID
    @Binding var expand : Bool
    
    var height = UIScreen.main.bounds.height / 3
    
    var safeArea = UIApplication.shared.windows.first?.safeAreaInsets
    
    //Volume Slider
    @State var volume : CGFloat = 0
    
    //Gesture Offset
    @State var offset : CGFloat = 0
    
    var body: some View
    {
        VStack
        {
            Capsule()
                .fill(Color.gray)
                .frame(width: expand ? 60 : 0, height: expand ? 4 : 0)
                .opacity(expand ? 1 : 0)
                .padding(.top,expand ? safeArea?.top : 0)
                .padding(.vertical,expand ? 30 : 0)
            
            HStack(spacing: 15)
            {
                if expand{Spacer(minLength: 0)} //Change to song image
                
                Image("defaultTrackImg")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: expand ? height : 55, height: expand ? height : 55)
                    .cornerRadius(15)
                
                if !expand      //Change to Song Title
                {
                    Text("Song Title")
                        .font(.title2)
                        .fontWeight(.bold)
                        .matchedGeometryEffect(id: "Label", in: animation)
                }
                
                Spacer(minLength: 0)
                
                if !expand
                {
                    Button(action: {}, label: {
                        
                        Image(systemName: "backward.fill")
                            .font(.title2)
                            .foregroundColor(.primary)
                    })
                    
                    Button(action: {}, label: {
                        
                        Image(systemName: "play.fill")
                            .font(.title2)
                            .foregroundColor(.primary)
                    })
                    
                    Button(action: {}, label: {
                        
                        Image(systemName: "forward.fill")
                            .font(.title2)
                            .foregroundColor(.primary)
                    })
                }
            }.padding(.horizontal)
            
            VStack(spacing: 15)
            {
                Spacer(minLength: 0)
                
                HStack
                {
                    if expand
                    {
                        Text("Song Title")
                            .font(.title2)
                            .foregroundColor(.primary)
                            .fontWeight(.bold)
                            .matchedGeometryEffect(id: "Label", in: animation)
                    }
                    
                    Spacer(minLength: 0)
                    
                    Button(action: {})
                    {
                        Image(systemName: "ellipsis.circle")
                            .font(.title2)
                            .foregroundColor(.primary)
                    }
                }
                .padding()
                .padding(.top, 20)
                
                HStack
                {
                    Capsule()
                        .fill(
                            LinearGradient(gradient: .init(colors: [Color.white.opacity(0.7),Color.white.opacity(0.1)]), startPoint: .leading, endPoint: .trailing)
                        )
                        .frame(height: 4)
                    
                    Text("LIVE")
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Capsule()
                        .fill(
                            LinearGradient(gradient: .init(colors: [Color.white.opacity(0.1),Color.white.opacity(0.7)]), startPoint: .leading, endPoint: .trailing)
                        )
                        .frame(height: 4)
                }
                .padding()
                
                HStack
                {
                    Button(action: {})
                    {
                        Image(systemName: "backward.fill")
                            .font(.largeTitle)
                            .foregroundColor(.primary)
                    }
                    .padding()
                    
                    Button(action: {})
                    {
                        Image(systemName: "stop.fill")
                            .font(.largeTitle)
                            .foregroundColor(.primary)
                    }
                    .padding()
                    
                    Button(action: {})
                    {
                        Image(systemName: "forward.fill")
                            .font(.largeTitle)
                            .foregroundColor(.primary)
                    }
                    .padding()
                }
                
                Spacer(minLength: 0)
                
                HStack(spacing: 15)
                {
                    Image(systemName: "speaker.fill")
                    
                    Slider(value: $volume)
                    
                    Image(systemName: "speaker.wave.2.fill")
                }
                .padding()
                
                HStack(spacing: 22)
                {
                    Button(action: {})
                    {
                        Image(systemName: "arrow.up.message")
                            .font(.title2)
                            .foregroundColor(.primary)
                    }
                    
                    Button(action: {})
                    {
                        Image(systemName: "airplayaudio")
                            .font(.title2)
                            .foregroundColor(.primary)
                    }
                    
                    Button(action: {})
                    {
                        Image(systemName: "list.bullet")
                            .font(.title2)
                            .foregroundColor(.primary)
                    }
                }
                .padding(.bottom, safeArea?.bottom == 0 ? 15 : safeArea?.bottom)
            }
            //Stretch Effect
            .frame(height: expand ? nil : 0)
            .opacity(expand ? 1 : 0)
            
            
        }
        .frame(maxHeight: expand ? .infinity : 80)
        .background(
            VStack(spacing: 0)
            {
                BlurView()
                
                Divider()
            }
                .onTapGesture(perform: {
                    
                withAnimation(.spring()){expand = true}
            })
        )
        .cornerRadius(expand ? 20 : 0)
        .offset(y: expand ? 0 : -48)
        .offset(y: offset)
        .gesture(DragGesture().onEnded(onended(value:)).onChanged(onchanged(value:)))
        .ignoresSafeArea()
    }
    
    func onchanged(value: DragGesture.Value)
    {
        if value.translation.height > 0 && expand
        {
            offset = value.translation.height
        }
    }
    
    func onended(value: DragGesture.Value)
    {
        withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 0.95, blendDuration: 0.95))
        {
            //If value > height / 3 then close the view
            
            if value.translation.height > height
            {
                expand = false
            }
            
            offset = 0
        }
    }
}

struct PlayerSlider : View {
    @ObservedObject var viewModel : PlayerViewModel
    var body: some View{
        Slider(value: Binding<Double>(
            get: {viewModel.progressPercentage},
            set: {
                viewModel.onEvent(event: MusicPlayerEvent.DraggingSlider)
                viewModel.progressPercentage = $0
            }
        ),
               in: 0 ... 100, step: 1){
            // if dragging ended update music player
            if !$0 {
                   viewModel.onEvent(event: MusicPlayerEvent.SliderChanged)
               }
        }.padding(.leading).padding(.trailing)
    }
}

/*
struct MiniPlayer_Previews: PreviewProvider {
    @State static var expand = false
    @Namespace static var animation
    static var previews: some View {
        MiniPlayerView(viewModel: PlayerViewModel.instancePlayTracks(tracksList: [Track](), index: 0), animation: self.animation, expand: $expand).previewDevice("iPhone 13")
    }
}*/

/*
struct MiniPlayerView_Previews: PreviewProvider
{
    var expand : Bool = true
    
    static var previews: some View
    {
        testPlayer(animation: Namespace.ID, expand: expand)
    }
}*/

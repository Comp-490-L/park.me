//
//  ProfileView.swift
//  soundspot
//
//  Created by Yassine Regragui on 12/4/21.
//

import Foundation
import SwiftUI
import AudioToolbox
import RealmSwift

struct ProfileView: View{
    
    @StateObject var viewModel: ProfileViewModel
    //@ObservedObject var list = viewModel.profile
    var uploadViewModel = UploadViewModel()
    var body: some View{
        VStack{
            ScrollView(){
                VStack(alignment: .leading){
                    VStack (alignment: .leading){
                        Text(viewModel.profile?.displayName ?? "").font(.title2).padding(.top, 60).foregroundColor(.white)
                        Text("Your music")
                            .font(.title3)
                            .padding(.top, 15.0)
                           .foregroundColor(.white)
                    }.padding()
                    
                    
                    VStack {
                        LazyVGrid(columns: [GridItem(), GridItem()]){
                            // Check if profile is found and user has some music uploaded
                            if(viewModel.profile != nil && viewModel.profile!.singlesList != nil){
                                ForEach(0..<viewModel.profile!.singlesList!.count, id: \.self) {
                                    index in
                                    CardWithNavigationLink(index: index,
                                                           list:  viewModel.profile!.singlesList!)
                                }
                            }
                        }
                    }.onAppear{
                        viewModel.onEvent(event: ProfileEvents.ProfileViewLoaded)
                    }
                }
            }.background(Color(#colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)))
            
            Spacer().background(Color(#colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)))
            HStack{
                
                if(viewModel.uploadingFile){
                    VStack(alignment : .leading){
                        Text("Upload Progress")
                        ProgressBar(currentProgress: $viewModel.uploadProgress)
                            .frame(height : 20)
                    }
                }else{
                    Button(action: {
                        viewModel.showFilePicker.toggle()
                    }){
                        SwiftUI.Text("Upload file")
                            .font(.headline)
                            .padding(.horizontal, 60.0)
                            .padding(.vertical, 10.0)
                            .foregroundColor(.white)
                            .background(Color.purple)
                            .cornerRadius(10)
                    }.sheet(isPresented: $viewModel.showFilePicker){
                        viewModel.showDocumentPicker()
                    }
                }
                
            }.padding().background(Color(#colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)))
        }.edgesIgnoringSafeArea(.top)
            // .ignoresSafeArea()
    }
    
    struct trackCard : View{
        @State var single : MusicModel
        var body: some View{
            VStack{
                if(!single.pictureDownloaded){
                    Image("defaultTrackImg")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 150, height: 150)
                        .background(Color.white)
                        .cornerRadius(15)
                        .shadow(radius: 1)
                }else if(single.pictureData != nil){
                    Image(uiImage: UIImage(data: single.pictureData!)!)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 150, height: 150)
                        .cornerRadius(10)
                        .shadow(radius: 1)
                    //.aspectRatio(2/3, contentMode: .fit)
                }
                Text(single.name).foregroundColor(Color.gray)
            }
        }
    }
    
    struct CardWithNavigationLink : View{
        let index : Int
        @State var list : Array<MusicModel>
        @ViewBuilder var body: some View{
            NavigationLink(destination:PlayerView(viewModel: PlayerViewModel(trackList: list, trackIndex: index))){
                trackCard(single: list[index])
            }
        }
    }
    
    
    struct ProgressBar : View{
        @Binding var currentProgress : Double
        var body: some View{
           
            GeometryReader{
                geometry in
                ZStack{
                ZStack(alignment: .leading){
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundColor(.purple)
                        .frame(width: geometry.size.width,
                               height: geometry.size.height,
                               alignment: .center)
                        .opacity(0.5)
                    
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundColor(.purple)
                        .frame(width: min(currentProgress * geometry.size.width, geometry.size.width),
                               height: geometry.size.height,
                               alignment: .center)
                        .animation(.linear)
                }
                    Text("\(String(format: "%.2f", currentProgress * 100)) %")
                }
            }
        }
    }
}




struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(viewModel: ProfileViewModel()).previewDevice("iPhone 13")
    }
}


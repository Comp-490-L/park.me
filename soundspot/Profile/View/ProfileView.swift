//
//  ProfileView.swift
//  soundspot
//
//  Created by Yassine Regragui on 12/4/21.
//

import Foundation
import SwiftUI
import AudioToolbox

struct ProfileView: View{
    
    @StateObject var viewModel: ProfileViewModel
    var uploadViewModel = UploadViewModel()
    var body: some View{
        VStack{
            ScrollView(){
                VStack(alignment: .leading){
                    VStack (alignment: .leading){
                        Text(viewModel.profile?.displayName ?? "").font(.title2)
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
                                    NavigationLink(destination:PlayerView(viewModel:
                                                                            PlayerViewModel(trackList: (viewModel.profile?.singlesList!)!, trackIndex: index))){
                                        trackCard(single: viewModel.profile!.singlesList![index])
                                    }
                                }
                            }
                        }
                    }.onAppear{
                        viewModel.getUserMusic()
                    }
                }
            }
            
            Spacer()
            HStack{
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
                    uploadViewModel.showDocumentPicker()
                }
            }.padding()
            
        }.background(Color(#colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)))
            .ignoresSafeArea()
        
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
                }else{
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
}




struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(viewModel: ProfileViewModel()).previewDevice("iPhone 13")
    }
    
}


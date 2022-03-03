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
    @State var didTap = false
    @State var showUpload = false
    
    var body: some View{
        NavigationView{
            VStack{
                ScrollView{
                    ZStack{
                        
                    Banner()
                        
                    VStack(alignment: .center){
                 
                            
                                Image("FLCL")
                                    .resizable()
                                    .clipShape(Circle())
                                    .shadow(radius: 10)
                                    .overlay(Circle()
                                    .stroke(Color(#colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)), lineWidth: 5))
                                    .frame(width: 200, height: 200)
                                    .scaledToFit()
                                    .padding(.top, 40)
                                
                                Text(viewModel.profile?.displayName ?? "Username")
                                    .font(.title2)
                                    .foregroundColor(.white)
                                    .fontWeight(.bold)
                                    
                     
                    }
                    
                }    // End of Zstack
                        
                        
                        
                        VStack(alignment: .leading) {
                            
                            HStack{
                                
                                Button(action: {
                                    self.didTap = true
                                }){
                                    SwiftUI.Text("Your Likes")
                                        //.font(.headline)
                                        .font(.system(size: 25))
                                        .fontWeight(.bold)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(.vertical, 10.0)
                                        .foregroundColor( .white)
                                        .background(didTap ? Color(#colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)): Color(#colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)) ).onTapGesture {
                                            showUpload.toggle()
                                        }
                                        
                                        //.cornerRadius(8)
                                        //.padding()
                                }
                                Spacer()
                                }
                            HStack{
                                
                                Button(action: {
                                    self.didTap = true
                                }){
                                    SwiftUI.Text("Playlists")
                                        //.font(.headline)
                                        .font(.system(size: 25))
                                        .fontWeight(.bold)
                                        .frame(alignment: .leading)
                                        .padding(.vertical, 10.0)
                                        .foregroundColor( .white)
                                        .background(didTap ? Color(#colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)): Color(#colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)) )
                                        
                                        //.cornerRadius(8)
                                        //.padding()
                                }
                                Spacer()
                                }
                            
                            //ScrollView{
                            LazyVGrid(columns: [GridItem(), GridItem()]){
                                // Check if profile is found and user has some music uploaded
                                if(viewModel.profile != nil && viewModel.profile!.singlesList != nil){
                                    ForEach(0..<viewModel.profile!.singlesList!.count, id: \.self) {
                                        index in
                                        CardWithNavigationLink(index: index,
                                                               list:  viewModel.profile!.singlesList!)

                                }
                            }
                        }.onAppear{
                            viewModel.onEvent(event: ProfileEvents.ProfileViewLoaded)
                        }
                            //}
                    
                }.background(Color(#colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)))
                
               
            
                    //Spacer().frame(maxHeight: .infinity)
            }.background(Color(#colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)))
                .edgesIgnoringSafeArea(.all)
            
                //UploadChoice()
            
            HStack{
                
                if(viewModel.uploadingFile){
                    VStack(alignment : .leading){
                        Text("Upload Progress")
                        ProgressBar(currentProgress: $viewModel.uploadProgress)
                            .frame(height : 20)
                    }
                }else{
                    
                    Menu{
                        Button("Tracks"){
                            viewModel.onEvent(event: ProfileEvents.UploadTracksClicked)
                        }
                        Button("Album"){
                            viewModel.onEvent(event: ProfileEvents.UploadAlbumClicked)
                        }
                        
                    } label: {
                        SwiftUI.Text("Upload music")
                            .font(.headline)
                            .padding(.horizontal, 60.0)
                            .padding(.vertical, 10.0)
                            .foregroundColor(.white)
                            .background(Color.purple)
                            .cornerRadius(10)
                    }
                    .sheet(isPresented: $viewModel.showFilePicker){
                            viewModel.showDocumentPicker()
                        }
            
                }
                
            }
            .padding(.bottom, 10)
            .background(Color(#colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)))
            
                NavigationLink(
                    destination: MusicUploadView(viewModel: MusicUploadViewModel(uploadChoice: viewModel.uploadChoice, selectedFiles: viewModel.selectedFiles)),
                    isActive: $viewModel.navigateToUploadView){}
					
                
                
        }.background(Color(#colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)))
		}.onAppear{
			viewModel.testUpload()
		}
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


struct Banner : View {
    var body: some View{
        VStack{
            Rectangle()
                .strokeBorder(Color(#colorLiteral(red: 0.5, green: 0, blue: 1, alpha: 1))
                              , lineWidth: 10)
                .frame(width: .infinity, height: 20)
            Rectangle()
                .strokeBorder(Color(#colorLiteral(red: 0.6, green: 0.1, blue: 1, alpha: 1)), lineWidth: 10)
                .frame(width: .infinity, height: 22)
            Rectangle()
                .strokeBorder(Color(#colorLiteral(red: 0.7, green: 0.2, blue: 1, alpha: 1)), lineWidth: 8)
                .frame(width: .infinity, height: 24)
            Rectangle()
                .strokeBorder(Color(#colorLiteral(red: 0.8, green: 0.3, blue: 1, alpha: 1)), lineWidth: 6)
                .frame(width: .infinity, height: 26)
            Rectangle()
                .strokeBorder(Color(#colorLiteral(red: 0.9, green: 0.4, blue: 1, alpha: 1)), lineWidth: 4)
                .frame(width: .infinity, height: 28)
            Rectangle()
                .strokeBorder(Color(#colorLiteral(red: 0.9, green: 0.4, blue: 1, alpha: 1)), lineWidth: 4)
                .frame(width: .infinity, height: 28)
            Rectangle()
                .strokeBorder(Color(#colorLiteral(red: 0.8, green: 0.3, blue: 1, alpha: 1)), lineWidth: 6)
                .frame(width: .infinity, height: 26)
            Rectangle()
                .strokeBorder(Color(#colorLiteral(red: 0.7, green: 0.2, blue: 1, alpha: 1)), lineWidth: 8)
                .frame(width: .infinity, height: 24)
            Rectangle()
                .strokeBorder(Color(#colorLiteral(red: 0.6, green: 0.1, blue: 1, alpha: 1)), lineWidth: 10)
                .frame(width: .infinity, height: 22)
            Rectangle()
                .strokeBorder(Color(#colorLiteral(red: 0.5, green: 0, blue: 1, alpha: 1)), lineWidth: 10)
                .frame(maxWidth: .infinity).frame(height : 20)
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(viewModel: ProfileViewModel()).previewDevice("iPhone 13")
    }
}


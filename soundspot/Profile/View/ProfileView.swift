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
                
                    
                    
//<<<<<<< Updated upstream
                    
                //ScrollView(){
                    
                    ZStack{
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
                                .frame(width: .infinity, height: 20)
                        }
                        
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
                                        .background(didTap ? Color(#colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)): Color(#colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)) )
                                        
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
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(.vertical, 10.0)
                                        .foregroundColor( .white)
                                        .background(didTap ? Color(#colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)): Color(#colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)) )
                                        
                                        //.cornerRadius(8)
                                        //.padding()
                                }
                                Spacer()
                                }
                            
                            ScrollView{
                            LazyVGrid(columns: [GridItem(), GridItem()]){
                                // Check if profile is found and user has some music uploaded
                                if(viewModel.profile != nil && viewModel.profile!.singlesList != nil){
                                    ForEach(0..<viewModel.profile!.singlesList!.count, id: \.self) {
                                        index in
                                        CardWithNavigationLink(index: index,
                                                               list:  viewModel.profile!.singlesList!)
//>>>>>>> Stashed changes
                                }
                            }
                        }.onAppear{
                            viewModel.onEvent(event: ProfileEvents.ProfileViewLoaded)
                        }
                            }
//<<<<<<< Updated upstream
                    
//=======
                    
                }.background(Color(#colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)))
                
               
                        
//>>>>>>> Stashed changes
                    
               
            
            
            //             .ignoresSafeArea()
            
//
            
//<<<<<<< Updated upstream
            
                    Spacer().frame(maxHeight: .infinity)
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
            }.background(Color(#colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)))
            .edgesIgnoringSafeArea(.all)
//             .ignoresSafeArea()
////=======
//>>>>>>> Stashed changes
    
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


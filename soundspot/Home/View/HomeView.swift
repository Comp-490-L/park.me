//
//  HomeView.swift
//  soundspot
//
//  Created by MO BALUSHI on 10/17/21.
//

import Foundation
import SwiftUI


struct HomeView: View {
    @ObservedObject var viewModel : HomeViewModel
    @State private var selection = 0
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @ObservedObject var tabBarVisibility = TabBarVisibility.getInstance()
    init(viewModel : HomeViewModel) {
        UITabBar.appearance().backgroundColor = UIColor(Color.backgroundColor)
        self.viewModel = viewModel
    }
    var body: some View
    {
        
        VStack
        {
            if(tabBarVisibility.show){
            NavigationView
            {
                TabBar(viewModel : viewModel)
            }.navigationBarBackButtonHidden(true).navigationBarHidden(false)
            }else{
                NavigationView
                {
                    StartUp(viewModel: AuthenticateUser())
                }
            }
        }
            
        
        
    }
}


struct HomeMainView: View {
    
    @State var hero = false
    @State var data = TrendingCard
    @StateObject var viewModel : HomeViewModel
    
    var body: some View {
        
        VStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    SearchBar()
                    
                    //Trending
                    VStack{
                        HStack {
                            Text("Trending this week")
                                .bold()
                                .multilineTextAlignment(.trailing)
                                .foregroundColor(.white)
                                .padding(.leading, 20)
                            
                            Spacer()
                        }
                        // Card View
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(0..<viewModel.trending.count, id: \.self) { index in
                                    Trending(track: viewModel.trending[index])
                                        .cornerRadius(15)
                                        .shadow(radius: 1)
                                        .buttonStyle(PlainButtonStyle())
                                        .onTapGesture{
                                            _=PlayerViewModel.instancePlayTracks(tracksList: viewModel.trending, index: index)
                                        }
                                }.padding(.leading, 15)
                                .padding(.trailing, 5)
                                
                                
                            }
                        }
                    }//.padding(.top, -50)
                    .opacity(self.hero ? 0 : 1)
                    
                    
                    //Categories
                    VStack{
                        HStack {
                            Text("Categories")
                                .bold()
                                .multilineTextAlignment(.trailing)
                                .padding(.leading, 20)
                                .foregroundColor(.white)
                            
                            Spacer()
                        }
                        // Categories View
                        HStack(spacing: 10) {
                            ForEach(1 ..< 5) { i in
                                VStack {
                                    Image("categ-\(String(i))")
                                    Text(SongTypes[Int(i)-1])
                                        .font(.subheadline)
                                        .bold()
                                        .foregroundColor(.white)
                                    
                                }
                                .frame(width: 80, height: 100, alignment: .center)
                                .background(Color.purple)
                                .cornerRadius(15)
                                .foregroundColor(.white)
                                
                            }
                        }
                        
                        HStack(spacing: 10) {
                            ForEach(3 ..< 7) { i in
                                VStack {
                                    Image("categ-\(String(i))")
                                    Text(SongTypes[Int(i)-1])
                                        .font(.subheadline)
                                        .bold()
                                }
                                .frame(width: 80, height: 100, alignment: .center)
                                .background(Color.purple)
                                .foregroundColor(.white)
                                .cornerRadius(15)
                            }
                        }
                        
                    }
                    .shadow(radius: 1)
                    .opacity(self.hero ? 0 : 1)
                    // PlayList View
                    Spacer()
                    Spacer()
                    HStack{
                        Text("New Music")
                            .bold()
                            .multilineTextAlignment(.trailing)
                            .padding(.leading, 20)
                            .foregroundColor(.white)
                        Spacer()
                    }
                    VStack {
                        ForEach(0..<viewModel.availableTracks.tracks.count, id: \.self){ i in
                            /*
                             Binding(
                             get:{ viewModel.availableTracks.tracks[i] },
                             set: { music in
                                 viewModel.availableTracks.tracks[i] = music as! Track
                                  }
                             
                          
                             */
                            
                            MusicRow(viewModel : MusicRowViewModel(
                                music: viewModel.availableTracks.tracks[i],
                                index: i, onClick: viewModel.onTrackClicked,
                                containedIn: ContainedIn(container: Container.Track, id: viewModel.availableTracks.tracks[i].id))
                                )
                        }
                        if(viewModel.endOfTracks){
                            Text("Looks like you've reached the end.")
                                .font(.footnote)
                            Text("Try again later for more music")
                                .font(.footnote)
                        }
                        HStack{
                            Text("View more")
                        }.onTapGesture{
                            viewModel.onEvent(event: HomeViewEvent.viewMoreTracks)
                        }.padding()
                    }.padding(.bottom, 90)
                        .padding(.leading,10)
                    
                    //end of playlist
                    

                    
                    Spacer()
                    
                    
                }.padding(.top, 90)
                
            }
            //VideoControls()
        
            
            
        }.background(Color(#colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)))
            .edgesIgnoringSafeArea(.top)
            .onAppear{
                //TabBar.showTab.show = true
                viewModel.onEvent(event: HomeViewEvent.onLoad)
            }
        
    }
}




struct SearchBar: View {
    @State var search = ""
    var body: some View {
        /* ZStack {
         LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 0)), Color(#colorLiteral(red: 0.9843164086, green: 0.9843164086, blue: 0.9843164086, alpha: 0))]), startPoint: .top, endPoint: .bottom)
         .frame(width: UIScreen.main.bounds.width, height: (UIScreen.main.bounds.height)*0.25, alignment: .center)
         .edgesIgnoringSafeArea(.all)
         */
        
        VStack {
            HStack {
                Text("Browse")
                    .bold()
                    .font(.title)
                    .multilineTextAlignment(.trailing)
                    .foregroundColor(.white)
                    .padding(.leading, 20)
                    .padding(.top, -40)
                Spacer()
                Text("Filter")
                    .font(.title2)
                    .multilineTextAlignment(.leading)
                    .foregroundColor(.white)
                    .padding(.trailing, 20)
                    .padding(.top, -30)
            }
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                    .font(.title)
                TextField("Search...", text: $search)
                    .font(.title3)
                    .colorScheme(.light)
                    .foregroundColor(Color.white)
            }
            .frame(width:  ( UIScreen.main.bounds.width)*0.85, height: 40, alignment: .leading)
            
            .padding(.leading, 20)
            .background(Color.white)
            .cornerRadius(10)
            
        }//.foregroundColor(Color.backgroundColor)
        //}
    }
}



struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(viewModel: HomeViewModel()).previewDevice("iPhone 13")
    }
}

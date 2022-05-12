//
//  TabBar.swift
//  soundspot
//
//  Created by James Maturino on 5/3/22.
//

import Foundation
import SwiftUI

struct TabBar: View
{
    //@EnvironmentObject var showTab : TabBarVisibility
    
    @ObservedObject var viewModel : HomeViewModel
    //@State var current = 2
    @State private var selection = 0
    //MiniPlayer Properties
    @State var expand = false
    
    @Namespace var animation
    
    var body: some View
    {
        ZStack{
            if(TabBarVisibility.getInstance().show){
            ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom),
                content: {
                var profileViewModel = ProfileViewModel()
                TabView(selection: $selection)
                {
                    HomeMainView(viewModel: viewModel)
                        .navigationBarBackButtonHidden(true).navigationBarHidden(true)
                        .tabItem {
                            VStack {
                                Image(systemName: "globe")
                                    .foregroundColor(Color.white)
                                Text("Categories")
                            }
                        }//.navigationBarBackButtonHidden(true).navigationBarHidden(true)
                    
                        .tag(0)
                    
                    ProfileView(viewModel: profileViewModel).navigationBarBackButtonHidden(true).navigationBarHidden(true)
                        .tabItem {
                            VStack {
                                Image(systemName: "person").background(Color.white)
                                Text("Profile")
                            }
                        }
                    /*.background(Color(#colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)))*/
                        .tag(1)
                }
                MiniPlayerView(animation: animation, expand: $expand)
                //testPlayer(animation: animation, expand: $expand)
            })
        }
        }
    }
}

final class TabBarVisibility : ObservableObject{
    @Published var show = false
    static var inst = TabBarVisibility()
    
    static func getInstance() -> TabBarVisibility{
        return inst
    }
}

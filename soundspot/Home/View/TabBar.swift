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
    @ObservedObject var viewModel : HomeViewModel
    //@State var current = 2
    @State private var selection = 0
    //MiniPlayer Properties
    @State var expand = false
    
    @Namespace var animation
    
    var body: some View
    {
        ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom),
            content: {
            
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
                
                ProfileView(viewModel: ProfileViewModel()).navigationBarBackButtonHidden(true).navigationBarHidden(true)
                    .tabItem {
                        VStack {
                            Image(systemName: "person").background(Color.white)
                            Text("Profile")
                        }
                    }
                /*.background(Color(#colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)))*/
                    .tag(1)
            }
            
            testPlayer(animation: animation, expand: $expand)
        })
    }
}

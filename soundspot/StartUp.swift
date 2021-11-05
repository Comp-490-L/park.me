//
//  StartUp.swift
//  soundspot
//
//  Created by MO BALUSHI on 10/17/21.
//

import SwiftUI

struct StartUp: View {
    var body: some View {
        NavigationView {
                
                ZStack{
                    LinearGradient(gradient: Gradient( colors: [Color(.orange), Color(.orange)]) , startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all)
                        
                    
                    if UIScreen.main.bounds.height > 800 {
                        selectState()
                    } else {
                        ScrollView(.vertical, showsIndicators: false){
                            HomeView()
                        }
                    }
                }
            
        }
        }
//            ZStack {
//                LinearGradient(gradient: Gradient( colors: [Color(.white), Color(.black)]) , startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all)
//
//                if UIScreen.main.bounds.height > 800 {
//                    //HomeView()
//                } else {
//                    ScrollView(.vertical, showsIndicators: false){
//                      //  HomeView()
//                    }
//                }
//
//                    NavigationLink(
//                        destination: NavBar().navigationBarBackButtonHidden(true).navigationBarHidden(true),
//                        label: {
//                            HStack {
//                                Image(systemName: "")
//                                    .foregroundColor(Color(#colorLiteral(red: 0.9580881, green: 0.10593573, blue: 0.3403331637, alpha: 1)))
//
//                                Text("Listen Now")
//                                    .bold()
//                                    .foregroundColor(Color(#colorLiteral(red: 0.9580881, green: 0.10593573, blue: 0.3403331637, alpha: 1)))
//
//                            }
//                            .frame(width: 300, height: 60, alignment: .center)
//                            .border(Color(#colorLiteral(red: 0.9580881, green: 0.10593573, blue: 0.3403331637, alpha: 1)), width: 3)
//                            .cornerRadius(5)
//                        })
//
//
//
//            }
        }

    
    


struct StartUp_Previews: PreviewProvider {
    static var previews: some View {
        StartUp()
    }
}

struct Home: View {
    var body: some View {
        VStack {
            VStack {
                Image("")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 200, alignment: .center)
                    .clipShape(Circle())
            }
            selectState()
        }.padding(.bottom, 50)
    }
}


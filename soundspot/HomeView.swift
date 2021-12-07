//
//  HomeView.swift
//  soundspot
//
//  Created by MO BALUSHI on 10/17/21.
//

import Foundation
import SwiftUI

struct HomeView: View {
    
    @State private var selection = 0
    init() {
        UITabBar.appearance().backgroundColor = UIColor.white
    }
    var body: some View {
        NavigationView{
        TabView(selection: $selection){
                HomeMainView().navigationBarBackButtonHidden(true).navigationBarHidden(true)
            
            .tabItem {
                    VStack {
                        Image(systemName: "globe") // Use globe symbol
                        Text("Categories")
                    }
                }//.navigationBarBackButtonHidden(true).navigationBarHidden(true)
                .tag(0)
           
            ProfileView(viewModel: ProfileViewModel()).navigationBarBackButtonHidden(true).navigationBarHidden(true)
            .tabItem {
                VStack {
                    Image(systemName: "person") // Use person symbol
                    Text("Profile")
                }
            }
            .tag(1)
        }
        
    }.navigationBarBackButtonHidden(true).navigationBarHidden(true)
}
}


struct HomeMainView: View {
    @State var hero = false
    @State var data = TrendingCard
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
                                .padding(.leading, 20)

                            Spacer()
                            Text("View all >")
                                .multilineTextAlignment(.leading)
                                .foregroundColor(.red)
                                .padding(.trailing, 20)
                        }
                        // Card View
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(TrendingCard) { card in
                                    NavigationLink(
                                        destination: Song(Song :card),
                                        label: {
                                            Trending(trendingSong: card)
                                                .background(Color.white)
                                                .cornerRadius(15)
                                                .shadow(radius: 1)
                                        })
                                        .buttonStyle(PlainButtonStyle())
                                }
                                .padding(.bottom, 10)
                                .padding(.leading, 30)

                            }
                        }
                    }.padding(.top, -50)
                    .opacity(self.hero ? 0 : 1)


                    //Categories
                    VStack{
                        HStack {
                            Text("Categories")
                                .bold()
                                .multilineTextAlignment(.trailing)
                                .padding(.leading, 20)

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
                                        .foregroundColor(.red)

                                }
                                .frame(width: 80, height: 100, alignment: .center)
                                .background(Color.white)
                                .cornerRadius(15)
                                .foregroundColor(.red)

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
                                .background(Color.white)
                                .foregroundColor(.red)
                                .cornerRadius(15)
                            }
                        }

                    }
                    .shadow(radius: 1)
                    .opacity(self.hero ? 0 : 1)

                    //Our picks
                    VStack{
                        HStack {
                            Text("Our picks")
                                .bold()
                                .multilineTextAlignment(.trailing)
                                .padding(.leading, 20)

                            Spacer()
                            Text("View all >")
                                .multilineTextAlignment(.leading)
                                .foregroundColor(.red)
                                .padding(.trailing, 20)
                        }
                        .opacity(self.hero ? 0 : 1)


                        // Card View
                        VStack(spacing: 100) {
                            ForEach(0..<self.data.count){i in
                                GeometryReader{g in
                                    OurPicks(card: self.$data[i], hero: self.$hero)

                                        .offset(y: self.data[i].expand ? -g.frame(in: .global).minY : 0)
                                        .opacity(self.hero ? (self.data[i].expand ? 1 : 0) : 1)
                                        .onTapGesture {

                                            withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 0.8, blendDuration: 0)){
                                                if !self.data[i].expand{
                                                    self.hero.toggle()
                                                    self.data[i].expand.toggle()
                                                }
                                            }

                                        }

                                }
                                // going to increase height based on expand...
                                .frame(height: self.data[i].expand ? UIScreen.main.bounds.height : 250)
                                .simultaneousGesture(DragGesture(minimumDistance: self.data[i].expand ? 0 : 800).onChanged({ (_) in

                                    print("dragging")
                                }))
                            }


                        }

                    }.padding(.top, 50)
                    .padding(.bottom, 150)

                    Spacer()


                }
                .background(Color(#colorLiteral(red: 0.9843164086, green: 0.9843164086, blue: 0.9843164086, alpha: 1)))

            }
            .background(Color(.white))
            .edgesIgnoringSafeArea(.top)


        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}


struct SearchBar: View {
    @State var search = ""
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1)), Color(#colorLiteral(red: 0.9843164086, green: 0.9843164086, blue: 0.9843164086, alpha: 1))]), startPoint: .top, endPoint: .bottom)
                .frame(width: UIScreen.main.bounds.width, height: (UIScreen.main.bounds.height)*0.25, alignment: .center)
                .edgesIgnoringSafeArea(.all)


            VStack {
                HStack {
                    Text("Browse")
                        .bold()
                        .font(.title)
                        .multilineTextAlignment(.trailing)
                        .foregroundColor(.red)
                        .padding(.leading, 20)
                        .padding(.top, -40)
                    Spacer()
                    Text("Filter")
                        .font(.title2)
                        .multilineTextAlignment(.leading)
                        .foregroundColor(.red)
                        .padding(.trailing, 20)
                        .padding(.top, -30)
                }
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                        .font(.title)
                    TextField("Search...", text: $search)

                        .font(.title3)
                }
                .frame(width:  ( UIScreen.main.bounds.width)*0.85, height: 40, alignment: .leading)
                .padding(.leading, 20)
                .background(Color.white)
                .cornerRadius(10)

            }
        }
    }
  }

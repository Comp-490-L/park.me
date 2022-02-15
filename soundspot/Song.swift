//
//  Song.swift
//  soundspot
//
//  Created by MO BALUSHI on 10/17/21.
//

import SwiftUI

struct Song: View {
    @State private var quantity = 0
    @State var Song : Card
    @State var heart = "heart.fill"
    var placeHolder = "  "
    var body: some View {
        VStack {
            ScrollView(.vertical, showsIndicators: false, content: {
                GeometryReader{reader in
                    Image(Song.image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        
                        .offset(y: -reader.frame(in: .global).minY)
                        // going to add parallax effect....
                        .frame(width: UIScreen.main.bounds.width, height:  reader.frame(in: .global).minY + 300)
                    
                }
                .frame(height: 280)
                
                VStack(alignment: .leading,spacing: 15){
                    
                    Text(Song.title)
                        .font(.system(size: 35, weight: .bold))
                    
                    
                    HStack(spacing: 10){
                        
                        ForEach(1..<5){_ in
                            
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                        }
                    }
                    
                    HStack {
                        Text(Song.descrip)
                            .font(.caption)
                            .foregroundColor(.red)
                            .padding(.top,5)
                        Spacer()
                        
                        Button(action: {
                            withAnimation(.spring(dampingFraction: 0.5)) {
                                heart = "heart"
                            }
                        }, label: {
                            Image(systemName: heart)
                                .font(.largeTitle)
                                .foregroundColor(.red)
                            
                        })
                        .padding(.all, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                    }
                    
                    
                    Text("Description")
                        .font(.system(size: 25, weight: .bold))
                        .foregroundColor(.black)

                    Text(placeHolder)
                        .padding(.top, 10)
                        .fixedSize(horizontal: false, vertical: true)
                        .foregroundColor(.black)

                    .padding(.top, 10)
                }
                .padding(.top, 25)
                .padding(.horizontal)
                .background(Color.white)
                .foregroundColor(.black)
                .cornerRadius(20)
                .offset(y: -35)
            })
            
            
            Spacer()
            
            HStack{
                Spacer()
                // Next line is temporary
                NavigationLink(destination: PlayerView(viewModel: PlayerViewModel(trackList: Array<MusicModel>(), trackIndex: 0)),
                    label: {
                    Image(systemName: "play.circle.fill").resizable()
                }).frame(width: 70, height: 30, alignment: .center).padding()
                Spacer()
            }
            .padding(.all, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
            
            .edgesIgnoringSafeArea(.all)
            .background(Color.red.edgesIgnoringSafeArea(.all))
        }
    }
    
}

struct Song_Previews: PreviewProvider {
    static var previews: some View {
        Song(Song: TrendingCard[0])
    }
}

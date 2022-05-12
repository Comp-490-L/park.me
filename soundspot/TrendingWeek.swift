//
//  Trending.swift
//  soundspot
//
//  Created by MO BALUSHI on 10/17/21.
//



import SwiftUI

struct Trending: View {
    var track : Track
    var body: some View {
        ZStack{
            if let data = track.pictureData{
                if let uiimage = UIImage(data: data){
                    ZStack{
                     Image(uiImage: uiimage).resizable()
                        .frame(width: 270, height:270)
                    }.opacity(0.5)
                }else{
                    Image("defaultTrackImg").resizable()
                        .frame(width: 270, height:270).background(Color.gray)
                }
            }else{
                Image("defaultTrackImg").resizable()
                .frame(width: 270, height:270)
                .background(Color.gray)
            }
                
        
        VStack {
            Spacer()
            HStack {
                Text(track.title)
                    .bold()
                    .foregroundColor(.white)
                    .padding(.all, 4)
                Spacer()
            }
            
            HStack {
                Text("\(String(track.streams)) Streams")
                    .font(.subheadline)
                    .foregroundColor(.white)
                    .padding(.leading, 10)
                    .padding(.bottom, 20)
                Spacer()
            }
            
            
        }.padding(.leading, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
            
        }
        .frame(width: 250, height: 250)
        .cornerRadius(10)
        
    }
    
}

/*
struct Trending_Previews: PreviewProvider {
    static var previews: some View {
        Trending(trendingSong: TrendingCard[0])
    }
}*/

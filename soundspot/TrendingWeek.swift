//
//  Trending.swift
//  soundspot
//
//  Created by MO BALUSHI on 10/17/21.
//



import SwiftUI

struct Trending: View {
    @State var trendingSong : Card
    var body: some View {
        VStack {
            Image(trendingSong.image)
                .resizable()
                .frame(width: 270, height: 150)
            
            HStack {
                Text(trendingSong.title)
                    .bold()
                    .foregroundColor(.white)
                    .padding(.all, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                Spacer()
            }
            
            HStack {
                Text(trendingSong.descrip)
                    .font(.subheadline)
                    .foregroundColor(.white)
                    .padding(.leading, 10)
                Spacer()
            }
            
            HStack {
                ForEach(0 ..< trendingSong.stars) { item in
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                        .font(.subheadline)
                }
                Spacer()
            }
            .padding(.bottom, 30)
            .padding(.leading, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
            .padding(.trailing, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
            
        }
        .frame(width: 250, height: 250)
        .cornerRadius(10)
        
    }
    
}

struct Trending_Previews: PreviewProvider {
    static var previews: some View {
        Trending(trendingSong: TrendingCard[0])
    }
}

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
            VStack {
                    Text("Listen to Music")
                        .font(.title)
                        .bold()
                    Text("CHILLAX")
                        .font(.title3)
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)))
                        .padding(.all, 20)
                    
                    NavigationLink(
                        destination: NavBar().navigationBarBackButtonHidden(true).navigationBarHidden(true),
                        label: {
                            HStack {
                                Image(systemName: "")
                                    .foregroundColor(Color(#colorLiteral(red: 0.9580881, green: 0.10593573, blue: 0.3403331637, alpha: 1)))
                                
                                Text("Listen Now")
                                    .bold()
                                    .foregroundColor(Color(#colorLiteral(red: 0.9580881, green: 0.10593573, blue: 0.3403331637, alpha: 1)))
                                
                            }
                            .frame(width: 300, height: 60, alignment: .center)
                            .border(Color(#colorLiteral(red: 0.9580881, green: 0.10593573, blue: 0.3403331637, alpha: 1)), width: 3)
                            .cornerRadius(5)
                        })
                    
                    
                    
            }
        }

    }
    
}

struct StartUp_Previews: PreviewProvider {
    static var previews: some View {
        StartUp()
    }
}

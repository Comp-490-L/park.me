//
//  CreatePlaylistView.swift
//  soundspot
//
//  Created by James Maturino on 4/19/22.
//

import Foundation
import SwiftUI

struct CreatePlaylistView : View
{
    //@ObservedObject var viewModel : PlaylistViewModel
    @State private var playlistName: String = ""
    
    var body : some View
    {
        VStack
        {
            Spacer()
            Text("Give your playlist a name.")
                .bold()
                .font(.system(size: 27))
                .multilineTextAlignment(.center)
            Spacer()
                .frame(height: 30)
            
            TextField("Name Me!", text: $playlistName)
                .multilineTextAlignment(.center)
                .font(.system(size: 25))
            Rectangle()
                .frame(height: 1)
                .foregroundColor(.gray)
                .padding(.leading, 16)
                .padding(.trailing, 16)
            
            Spacer()
                .frame(height: 30)
                
            HStack
            {
                Spacer()
                Button("Cancel", action: {})
                Spacer()
                    .frame(width: 30)
                Button("Skip", action:{})
                Spacer()
                    .frame(width: 30)
                Button("Next", action:{})
                Spacer()
            }
            
            Spacer()
                .frame(height: 400)

        }
    }
    

}

struct CreatePlaylistView_Previews: PreviewProvider
{
    static var previews: some View
    {
        CreatePlaylistView()
            .previewDevice(PreviewDevice(rawValue: "iPhone 13"))
    }
}

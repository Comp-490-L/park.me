//
//  ContentView.swift
//  soundspot
//
//  Created by Yassine Regragui on 10/13/21.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack{
            CardView(title: "Email", secureField : false)
            CardView(title: "Password", secureField : true)
            Button("Sign in ", action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/)
        }.padding(10)
    }
}

struct CardView: View{
    var title : String
    var secureField : Bool
    @State private var input : String = ""
    var body: some View{
        VStack(alignment: .leading){
            Text(title).font(.subheadline).foregroundColor(Color("black"))
            ZStack{
                let shape = RoundedRectangle(cornerRadius : 10)
                shape.fill().foregroundColor(Color("lightGray"))
                if(secureField){
                    SecureField("", text: $input)
                        .padding(.horizontal, 10)
                }
                else{
                    TextField("", text: $input)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .padding(.horizontal, 10)
                }
                
            }.frame(height: 35.0)
        }
    }
}










struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDevice("iPhone 13")
    }
}

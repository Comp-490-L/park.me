//
//  selectedState.swift
//  soundspot
//
//  Created by MO BALUSHI on 10/28/21.
//


import SwiftUI

struct selectState: View {
    @State var index = 0
    var body: some View {
        VStack{
            HStack{
                Button(action: {
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.7, blendDuration: 0.3)){
                        self.index = 0
                    }
                }) {
                    Text("SoundSpotter")
                        .foregroundColor(self.index == 0 ? .black : .white)
                        .fontWeight(.bold)
                        .padding(.vertical, 10)
                        .frame(width: (UIScreen.main.bounds.width - 50) / 2)
                    
                }.background(self.index == 0 ? Color.white : Color.clear)
                    .clipShape(Capsule())
                
                Button(action: {
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.7, blendDuration: 0.3)){
                        self.index = 1
                    }
                }) {
                    Text("New")
                        .foregroundColor(self.index == 1 ? .black : .white)
                        .fontWeight(.bold)
                        .padding(.vertical, 10)
                        .frame(width: (UIScreen.main.bounds.width - 50) / 2)
                    
                }.background(self.index == 1 ? Color.white : Color.clear)
                    .clipShape(Capsule())
            }.frame(width: UIScreen.main.bounds.width - 100 / 2)
                .background(Color.gray.opacity(0.1))
                .clipShape(Capsule())
                .padding(.top, 30)

            if self.index == 1 {
                SignUp()
            }else{
                LoginFields()
            }
            
            Button(action: {

            }) {
                Text("Forget Password?")
                    .foregroundColor(.white)
            }
            
            HStack{
                Color.white.opacity(0.7)
                .frame(width: 20, height: 1)
                
                Text("Or")
                    .foregroundColor(.white)
                
                Color.white.opacity(0.7)
                .frame(width: 20, height: 1)
            }.padding(.top, 10)
            
            HStack{

                
                Button(action: {
                    
                }) {
                    Image("googleLogo")
                        .renderingMode(.original)
                        .resizable()
                        .frame(width: 20, height: 20)
                }
                
            }.padding(.top, 50)
            .frame(width: (UIScreen.main.bounds.width - 300), height: 30)
        }
    }
}

struct selectedFiels_Previews: PreviewProvider {
    static var previews: some View {
        selectState().previewLayout(.sizeThatFits)
    }
}

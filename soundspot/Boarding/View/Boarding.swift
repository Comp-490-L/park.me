//
//  Boarding.swift
//  soundspot
//
//  Created by MO BALUSHI on 10/17/21.
//


import SwiftUI
import UIKit

struct Boarding_View: View {
    @State var showSheetView = false
    init() {
        UIPageControl.appearance().currentPageIndicatorTintColor = .black
        UIPageControl.appearance().pageIndicatorTintColor = UIColor.black.withAlphaComponent(0.2)
    }
    var body: some View {
        NavigationView{
            VStack{
                
                pages()
  
            }
        }
    }
}


struct pages: View {
    let deviceWidth = UIScreen.main.bounds.width
    let deviceHeight = UIScreen.main.bounds.height
    
    var body: some View {
        ZStack{
            Image("wavy")
                .resizable(resizingMode: .tile)
                .ignoresSafeArea(.all)
                //.edgesIgnoringSafeArea(.all)
                //.aspectRatio(contentMode: .fill)
                //.frame(width: deviceWidth, height: deviceHeight, alignment: .topLeading)
                
                
 
            
         
            VStack {
                TabView {
                    ForEach(Data) { page in
                        GeometryReader { g in
                                HStack {
                                    Spacer()
                                    VStack{
                                        Spacer()
                                        Spacer()
                                        Text(page.title)
                                            .font(.largeTitle).bold()
                                            .foregroundColor(.white)
                                        
                                        Text(page.descrip)
                                            .foregroundColor(.white)
                                            .font(.title)
                                            .multilineTextAlignment(.center)
                                            .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                                        Spacer()
                                    }
                                    Spacer()
                                }
                                .opacity(Double(g.frame(in : . global).minX)/200+1)
                            }
                        }
                    }
                
                NavigationLink(
                    destination: StartUp(viewModel: AuthenticateUser()).navigationBarBackButtonHidden(true).navigationBarHidden(true),
                    label: {
                        Text("Listen Now")
                            .font(.headline)
                            .padding(.init(top: 10.0, leading: 40.0, bottom: 10.0, trailing: 40.0))
                            .foregroundColor(.black)
                            .background(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)))
                            .cornerRadius(10)
                        
                    })
                
                
                
                }
                .edgesIgnoringSafeArea(.top)
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
            
    
            
            }
        

            
        }
        
      
    }










struct Boarding_Previews: PreviewProvider {
    static var previews: some View {
        Boarding_View()
    }
}

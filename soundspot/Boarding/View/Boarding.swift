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
                
                Spacer()
            }
        }
    }
}


struct pages: View {
    var body: some View {
        ZStack{
            Image("Aux-Cord-1")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()
         
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
                            .foregroundColor(.white)
                            .background(Color(#colorLiteral(red: 0.95294118, green: 0.18431373, blue: 0.2, alpha: 1)))
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

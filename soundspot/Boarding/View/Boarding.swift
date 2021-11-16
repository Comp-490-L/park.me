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
                NavigationLink(
                    destination: StartUp(viewModel: AuthenticateUser()).navigationBarBackButtonHidden(true).navigationBarHidden(true),
                    label: {
                        Text("Start")
                            .font(.headline)
                            .padding(.init(top: 10.0, leading: 40.0, bottom: 10.0, trailing: 40.0))
                            .foregroundColor(.white)
                            .background(Color(#colorLiteral(red: 0.9580881, green: 0.10593573, blue: 0.3403331637, alpha: 1)))
                            .cornerRadius(10)
                    })
                Spacer()
            }
        }
    }
}


struct pages: View {
    var body: some View {
        VStack {
            
            TabView {
                ForEach(Data) { page in
                    GeometryReader { g in
                        VStack {
                            Image(page.image)
                                .resizable()
                                .scaledToFit()
                            Text(page.title)
                                .font(.title).bold()
                                .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/, 20)
                            Text(page.descrip)
                                .multilineTextAlignment(.center)
                                .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                        }
                        .opacity(Double(g.frame(in : . global).minX)/200+1)
                    }
                }
            }
            .edgesIgnoringSafeArea(.top)
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
            
            /*NavigationLink(
                destination: StartUp().navigationBarBackButtonHidden(true).navigationBarHidden(true),
                label: {
                    Text("Start")
                        .font(.headline)
                        .frame(width: 200, height: 40, alignment: .center)
                        .foregroundColor(.white)
                        .background(Color(#colorLiteral(red: 0.9580881, green: 0.10593573, blue: 0.3403331637, alpha: 1)))
                        .cornerRadius(10)
                })
            Spacer()*/
            
        }
        
        /*.navigationBarItems(trailing:
                                NavigationLink(
                                    destination: StartUp().navigationBarBackButtonHidden(true).navigationBarHidden(true),
                                    label: {
                                        Image(systemName: "arrow.right")
                                            .font(Font.system(.title3))
                                            .foregroundColor(Color(#colorLiteral(red: 0.9580881, green: 0.10593573, blue: 0.3403331637, alpha: 1)))
                                    })
        )
        .navigationBarBackButtonHidden(true)*/
    }
}









struct Boarding_Previews: PreviewProvider {
    static var previews: some View {
        Boarding_View()
    }
}

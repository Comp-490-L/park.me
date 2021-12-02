//
//  BoardingPage.swift
//  soundspot
//
//  Created by MO BALUSHI on 10/17/21.
//
//
//import SwiftUI
//struct ContentView: View{
//    var body: some View{
//
//        ZStack {
//
//            Image("Aux-Cord-1")
//        }
//
//    }
//}
//
//struct ContentView_Previews: PreviewProvider{
//    static var previews: some View{
//        ContentView()
//    }
//}
import Foundation
import SwiftUI

struct Page : Identifiable {
    var id : Int
    var image : String
    var title : String
    var descrip : String

}

var Data = [
    Page(id: 0, image: "Aux-Cord-1", title: "SoundSpot", descrip: "Listen to Music for free"),
    Page(id: 1, image: "Aux-Cord-1", title: "No Ads", descrip: "No Subscriptions"),
    Page(id: 2, image: "On the go", title: "Post Your Own Music", descrip: "And Listen to Your Friends!")
]

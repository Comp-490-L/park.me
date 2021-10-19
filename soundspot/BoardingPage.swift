//
//  BoardingPage.swift
//  soundspot
//
//  Created by MO BALUSHI on 10/17/21.
//

import Foundation

struct Page : Identifiable {
    var id : Int
    var image : String
    var title : String
    var descrip : String
}

var Data = [
    Page(id: 0, image: "LISTEN", title: "SoundSpot", descrip: "on here u can do whatever u want"),
    Page(id: 1, image: "Chill", title: "SoundSpot", descrip: "on here u can do whatever u want"),
    Page(id: 2, image: "On the go", title: "SoundSpot", descrip: "on here u can do whatever u want")
]

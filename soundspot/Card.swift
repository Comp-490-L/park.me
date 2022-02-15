//
//  Card.swift
//  soundspot
//
//  Created by MO BALUSHI on 10/17/21.
//

import Foundation


struct Card : Identifiable {
    var id : Int
    var image : String
    var title : String
    var descrip : String
    var stars : Int
    var expand : Bool
}

var TrendingCard = [
    Card(id: 0, image: "SadMachineSingleCover", title: "Sad Machine", descrip: "TECHNO",stars: 5, expand: false),
    Card(id: 1, image: "SadMachineSingleCover", title: "Sad Machine", descrip: "TECHNO",stars: 3, expand: false),
    Card(id: 2, image: "SadMachineSingleCover", title: "Sad Machine", descrip: "TECHNO",stars: 4, expand: false),
    Card(id: 3, image: "SadMachineSingleCover", title: "Sad Machine", descrip: "TECHNO",stars: 5, expand: false),
    Card(id: 4, image: "SadMachineSingleCover", title: "Sad Machine", descrip: "TECHNO",stars: 3, expand: false),
    Card(id: 5, image: "SadMachineSingleCover", title: "Sad Machine", descrip: "TECHNO",stars: 1, expand: false),
]

var SongTypes = ["HIPHOP","RAP","HOME","TECHNO","GENRE","GENRE"]

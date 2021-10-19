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
    Card(id: 0, image: " ", title: "song0", descrip: "Genre",stars: 5, expand: false),
    Card(id: 1, image: " ", title: "song1", descrip: "Genre",stars: 3, expand: false),
    Card(id: 2, image: " ", title: "song2", descrip: "Genre",stars: 4, expand: false),
    Card(id: 3, image: " ", title: "song3", descrip: "Genre",stars: 5, expand: false),
    Card(id: 4, image: " ", title: "song4", descrip: "Genre",stars: 3, expand: false),
    Card(id: 5, image: " ", title: "song5", descrip: "Genre",stars: 1, expand: false),
]

var SongTypes = ["HIPHOP","RAP","HOME","TECHNO","GENRE","GENRE"]

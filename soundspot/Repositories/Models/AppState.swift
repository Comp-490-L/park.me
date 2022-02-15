//
//  AppLaunch.swift
//  soundspot
//
//  Created by Yassine Regragui on 2/2/22.
//

import Foundation
import RealmSwift

class AppState : Object{
    @objc dynamic var firstLaunch = true
    @objc dynamic var userLoggedIn = false
    @objc dynamic var _id : ObjectId = ObjectId.generate()
    convenience init(firstLaunch : Bool, userLoggedIn : Bool){
        self.init()
        self.firstLaunch = firstLaunch
        self.userLoggedIn = userLoggedIn
    }
    
    override static func primaryKey() -> String {
        return "_id"
    }
}

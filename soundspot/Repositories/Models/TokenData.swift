//
//  Token.swift
//  soundspot
//
//  Created by Yassine Regragui on 2/1/22.
//

import Foundation
import RealmSwift

// Returns a RealmDB object
class TokenData : Object{
    @objc dynamic var token : String = ""
    @objc dynamic var refreshToken : String = ""
    @objc dynamic var _id : ObjectId = ObjectId.generate()
    convenience init(token : String, refreshToken : String){ //_id : String
        self.init()
        self.token = token
        self.refreshToken = refreshToken
    }
    
    override static func primaryKey() -> String {
        return "_id"
    }
}

//
//  Data.swift
//  StarWarsPeoples
//
//  Created by Aleksandr Skorotkin on 28/05/2019.
//  Copyright © 2019 Aleksandr Skorotkin. All rights reserved.
//

import Foundation
import RealmSwift

class StarObject: Object {

    @objc dynamic var name = ""
    @objc dynamic var gender = ""
    @objc dynamic var skin_color = ""
    @objc dynamic var eye_color = ""
    @objc dynamic var mass = ""
    @objc dynamic var height = ""
    @objc dynamic var birth_year = ""
    @objc dynamic var hair_color = ""
    
}

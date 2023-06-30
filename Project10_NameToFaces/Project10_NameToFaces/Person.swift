//
//  Person.swift
//  Project10_NameToFaces
//
//  Created by Maxim on 13.06.2023.
//

import UIKit

class Person: NSObject {
    var name: String
    var image: String
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
}

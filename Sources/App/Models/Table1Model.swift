//
//  Table1Model.swift
//  
//
//  Created by Michael Franklin on 10/11/21.
//

import Foundation
import Vapor

struct Table1Model : Content {
    
    var id: String?
    var field1: String
    var field2: String
    
    init(id: String, field1: String, field2: String) {
        self.id = id
        self.field1 = field1
        self.field2 = field2
    }
}

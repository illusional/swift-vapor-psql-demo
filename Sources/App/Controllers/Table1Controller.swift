//
//  File.swift
//  
//
//  Created by Michael Franklin on 5/10/21.
//

import Foundation
import CoreLocation
import PostgresNIO

extension PostgresDatabase {
    func Table1() -> Table1Controller {
        return Table1Controller(connection: self)
    }
}

class Table1Controller {
    
    var connection: PostgresDatabase
    
    init(connection: PostgresDatabase) {
        self.connection = connection
    }
    
    func create(model: Table1Model) async -> String {
        let response = try! await self.connection.query(
            "INSERT INTO table1 (field1, field2) VALUES($1, $2) RETURNING id",
            [
                PostgresData(string: model.field1),
                PostgresData(string: model.field2)
            ]).get()
        
        return response[0].column("id")!.string!
    }
    
    func getAll() async -> [Table1Model] {
        let rows = try! await self.connection.simpleQuery("SELECT * FROM table1").get()
        return rows.map { element in
            Table1Model(
                id: element.column("id")!.string!,
                field1: element.column("field1")!.string!,
                field2: element.column("field2")!.string!
            )
        }
    }
}

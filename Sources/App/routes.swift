import Vapor
import PostgresKit


func routes(_ app: Application) throws {
    

    app.get { req in
        return "It works!"
    }

    app.get("hello") { req -> String in
        return "Hello, world!"
    }
    
    app.on(.GET, "hello", ":name") {req -> String in
        let name = req.parameters.get("name")!
        return "Hello, \(name)!"
    }
    
    app.put("create") { req -> String in
        
        do {
            let d = try req.content.decode(Table1Model.self)
            return await req.db.Table1().create(model: d)
        }
        catch {
             return "FAILED \(error)"
             
        }
    }
    
    app.get("list") { req async -> [Table1Model] in
        return await req.db.Table1().getAll()
    }
    
    app.get("sql") { req -> EventLoopFuture<String> in
        let rows = req.db.simpleQuery("SELECT version();")

        return rows.map { v in
            v.description
        }
    }
}

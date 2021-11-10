import Vapor
import SQLKit
import PostgresKit
import Foundation

// The database extension stuff here is from Juri Pakaste
// https://juripakaste.fi/db-in-vapor4/

struct DatabaseService {
    let pool: EventLoopGroupConnectionPool<PostgresConnectionSource>
}

struct DatabaseServiceKey: StorageKey {
    typealias Value = DatabaseService
}

extension Application {
    var databaseService: DatabaseService? {
        get { self.storage[DatabaseServiceKey.self] }
        set { self.storage[DatabaseServiceKey.self] = newValue }
    }
}

extension DatabaseService: LifecycleHandler {
    func shutdown(_ application: Application) {
        self.pool.shutdown()
    }
}

extension Request {
    var db: PostgresDatabase {
        guard let dbService = self.application.databaseService else {
            fatalError("Missing DatabaseService")
        }
        let db = dbService.pool.database(logger: self.logger)
        return db
    }
}

class DBClient {
    
}

// configures your application
public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    /// Register providers first
    let configuration = PostgresConfiguration(
        hostname: "localhost",
        username: "michael",
        password: "",
        database: "example"
    )

    
    let pool = EventLoopGroupConnectionPool(
        source: PostgresConnectionSource(configuration: configuration),
        on: app.eventLoopGroup
    )
    
    let dbService = DatabaseService(pool: pool)
    app.databaseService = dbService
    app.lifecycle.use(dbService)
    
    // to build table, within psql run:
    
    // >>> CREATE DATABASE example;
    // >>> \c example;
    // # make sure the uuid-ossp function is working for default ID
    // >>> CREATE EXTENSION "uuid-ossp";
    // >>> CREATE TABLE table1(id UUID NOT NULL DEFAULT uuid_generate_v1(), field1 VARCHAR, field2 VARCHAR, CONSTRAINT pkey_example PRIMARY KEY ( id ));
    
//    let db = dbService.pool.database(logger: app.logger)
//    let dbClient = DBClient(database: db)
//    app.logger.info("Will run migrate on DB")
//    _ = try dbClient.migrate().wait()
//    app.logger.info("DB migration done")


    // register routes
    try routes(app)
}

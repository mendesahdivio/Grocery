import Vapor
import Fluent
import FluentPostgresDriver
import JWT

// configures your application
public func configure(_ app: Application) async throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
   app.databases.use(.postgres(configuration: SQLPostgresConfiguration(hostname: "localhost", username: "postgres", password: "", database: "grocerydb", tls: .prefer(try .init(configuration: .clientDefault)))), as: .psql)
  
  //register migrations
  app.migrations.add(CreateUsersTableMigration())
  app.migrations.add(CreateGroceryCategoryTabelMigration())
  
  //register controller
  try app.register(collection: UserController())
  try app.register(collection: GroceryController())
  
  //encrypt key
  app.jwt.signers.use(.hs256(key: "SECRETKEY"))
  
  
  // register routes
  try routes(app)
}
